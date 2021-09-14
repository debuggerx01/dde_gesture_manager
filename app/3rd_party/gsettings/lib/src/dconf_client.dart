import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dbus/dbus.dart';
import 'package:xdg_directories/xdg_directories.dart';

import 'getuid.dart';
import 'gvariant_binary_codec.dart';
import 'gvariant_database.dart';

XDGDirectories xdg = XDGDirectories();

/// Message received when DConf notifies changes.
class DConfNotifyEvent {
  /// A prefixed applied to each value in [keys].
  final String prefix;

  /// The paths to each key that has changed, to be prefixed with [prefix].
  /// If empty, a single key has changed with the value [prefix].
  final List<String> paths;

  /// Unique tag for this change, used to detect if this client generated the change.
  final String tag;

  const DConfNotifyEvent(this.prefix, this.paths, this.tag);

  @override
  String toString() => "DConfNotifyEvent('$prefix', $paths, '$tag')";
}

/// A client that connects to DConf.
class DConfClient {
  final String? profile;

  /// Stream of key names that indicate when a value has changed.
  Stream<DConfNotifyEvent> get notify => _notifyController.stream;
  final _notifyController = StreamController<DConfNotifyEvent>();

  /// The D-Bus buses this client is connected to.
  final DBusClient _systemBus;
  final DBusClient _sessionBus;
  final bool _closeSystemBus;
  final bool _closeSessionBus;

  /// Creates a new DConf client.
  DConfClient({this.profile, DBusClient? systemBus, DBusClient? sessionBus})
      : _systemBus = systemBus ?? DBusClient.system(),
        _sessionBus = sessionBus ?? DBusClient.session(),
        _closeSessionBus = sessionBus == null,
        _closeSystemBus = systemBus == null {
    _notifyController.onListen = () {
      _loadSources().then((sources) {
        if (sources.isEmpty) {
          throw 'No DConf source to write to';
        }
        _notifyController.addStream(DBusRemoteObjectSignalStream(
                object: sources[0].writer,
                interface: 'ca.desrt.dconf.Writer',
                name: 'Notify',
                signature: DBusSignature('sass'))
            .map((signal) => DConfNotifyEvent(
                (signal.values[0] as DBusString).value,
                (signal.values[1] as DBusArray)
                    .children
                    .map((child) => (child as DBusString).value)
                    .toList(),
                (signal.values[2] as DBusString).value)));
      });
    };
  }

  /// Gets all the keys available underneath the given directory.
  Future<List<String>> list(String dir) async {
    var sources = await _loadSources();
    var keys = <String>{};
    for (var source in sources) {
      keys.addAll(await source.database.list(dir: dir));
    }
    return keys.toList();
  }

  /// Gets the value of a given [key].
  Future<DBusValue?> read(String key) async {
    var sources = await _loadSources();
    for (var source in sources) {
      var value = await source.database.lookup(key);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  /// Sets key values in the dconf database.
  Future<String> write(Map<String, DBusValue?> values) async {
    var sources = await _loadSources();
    if (sources.isEmpty) {
      throw 'No DConf source to write to';
    }

    var changeset = DBusDict(
        DBusSignature('s'),
        DBusSignature('mv'),
        values.map((key, value) => MapEntry(
            DBusString(key),
            DBusMaybe(DBusSignature('v'),
                value != null ? DBusVariant(value) : null))));
    var codec = GVariantBinaryCodec();
    var result = await sources[0].writer.callMethod(
        'ca.desrt.dconf.Writer',
        'Change',
        [DBusArray.byte(codec.encode(changeset, endian: Endian.host))],
        replySignature: DBusSignature('s'));
    return (result.values[0] as DBusString).value;
  }

  /// Terminates the connection to the DConf daemon. If a client remains unclosed, the Dart process may not terminate.
  Future<void> close() async {
    if (_closeSystemBus) {
      await _systemBus.close();
    }
    if (_closeSessionBus) {
      await _sessionBus.close();
    }
  }

  // Load the DConf sources in use.
  Future<List<DConfEngineSource>> _loadSources() async {
    // Generate list of files to look for the profile in.
    var paths = <String>[];
    var profileName = profile;
    if (profileName == null) {
      var uid = getuid();
      paths.add('/run/dconf/user/$uid');
      profileName = Platform.environment['DCONF_PROFILE'];
    }
    if (profileName != null) {
      if (profileName.startsWith('/')) {
        paths.add(profileName);
      } else {
        paths.addAll(_getProfilePaths(profileName));
      }
    } else {
      var rd = xdg.runtimeDir;
      if (rd != null) {
        paths.add(_buildFilename([rd.path, 'dconf', 'profile']));
      }
      paths.addAll(_getProfilePaths('user'));
    }

    // Find the first file that exists.
    for (var path in paths) {
      var sources = await _loadProfileFile(path);
      if (sources != null) {
        return sources;
      }
    }

    // Return the default profile.
    if (profileName == null) {
      return [DConfEngineSourceUser('user', _sessionBus)];
    } else {
      return [];
    }
  }

  // Get the paths to find a DConf profile with [profileName].
  List<String> _getProfilePaths(String profileName) {
    var paths = [
      _buildFilename(['/etc', 'dconf', 'profile', profileName])
    ];
    for (var dir in xdg.dataDirs) {
      paths.add(_buildFilename([dir.path, 'dconf', 'profile', profileName]));
    }
    return paths;
  }

  // Load a DConf profile file.
  Future<List<DConfEngineSource>?> _loadProfileFile(String path) async {
    var file = File(path);
    List<String> lines;
    try {
      lines = await file.readAsLines();
    } on FileSystemException {
      return null;
    }

    var sources = <DConfEngineSource>[];
    for (var line in lines) {
      // Strip off comments.
      var commentIndex = line.lastIndexOf('#');
      if (commentIndex >= 0) {
        line = line.substring(0, commentIndex);
      }
      line = line.trim();
      if (line.isEmpty) {
        continue;
      }

      var index = line.indexOf(':');
      if (index < 0) {
        throw "Invalid DConf profile line: '$line'";
      }
      var type = line.substring(0, index);
      var value = line.substring(index + 1);
      DConfEngineSource source;
      switch (type) {
        case 'user-db':
          source = DConfEngineSourceUser(value, _sessionBus);
          break;
        case 'system-db':
          source = DConfEngineSourceSystem(value, _systemBus);
          break;
        case 'service-db': // Not implemented
        case 'file-db': // Not implemented
        default:
          throw "Unknown DConf source: 'line'";
      }
      sources.add(source);
    }

    return sources;
  }
}

class DConfEngineSource {
  /// The database containing configuration.
  GVariantDatabase get database {
    throw ('Not implemented');
  }

  /// D-Bus object to write to configuration.
  DBusRemoteObject get writer {
    throw ('Not implemented');
  }
}

class DConfEngineSourceUser extends DConfEngineSource {
  final String name;
  final DBusClient sessionBus;

  DConfEngineSourceUser(this.name, this.sessionBus);

  @override
  GVariantDatabase get database =>
      GVariantDatabase(_buildFilename([xdg.configHome.path, 'dconf', name]));

  @override
  DBusRemoteObject get writer => DBusRemoteObject(sessionBus,
      name: 'ca.desrt.dconf',
      path: DBusObjectPath('/ca/desrt/dconf/Writer/$name'));

  @override
  String toString() => "DConfEngineSourceUser('$name')";
}

class DConfEngineSourceSystem extends DConfEngineSource {
  final String name;
  final DBusClient systemBus;

  DConfEngineSourceSystem(this.name, this.systemBus);

  @override
  GVariantDatabase get database =>
      GVariantDatabase(_buildFilename(['/etc', 'dconf', 'db', name]));

  @override
  DBusRemoteObject get writer => DBusRemoteObject(systemBus,
      name: 'ca.desrt.dconf',
      path: DBusObjectPath('/ca/desrt/dconf/Writer/$name'));

  @override
  String toString() => "DConfEngineSourceSystem('$name')";
}

// Build a filename from parts.
String _buildFilename(List<String> parts) {
  var path = parts.join('/');
  while (true) {
    var updatedPath = path.replaceAll('//', '/');
    if (updatedPath == path) {
      return path;
    }
    path = updatedPath;
  }
}
