import 'dart:io';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'local_schemes.dart';

export 'local_schemes.dart';

@ProviderModel()
class LocalSchemes implements LocalSchemesInterface<LocalSchemeEntryLinux> {
  LocalSchemes() {
    schemeEntries.then((value) => schemes = value);
  }

  @override
  Future<List<LocalSchemeEntryLinux>> get schemeEntries async {
    var _supportDirectory = await getApplicationSupportDirectory();
    var directory = Directory(join(_supportDirectory.path, 'schemes'));
    if (!directory.existsSync()) directory.createSync();
    directory.path.sout();
    return directory
        .list()
        .map<LocalSchemeEntryLinux?>((f) {
          LocalSchemeEntryLinux? entry;
          try {
            var content = File(f.path).readAsStringSync();
            entry = LocalSchemeEntryLinux(
                path: f.path, scheme: Scheme.parse(content), lastModifyTime: f.statSync().modified);
          } catch (e) {
            e.sout();
          }
          return entry;
        })
        .where((e) => e != null)
        .cast<LocalSchemeEntryLinux>()
        .toList();
  }

  @ProviderModelProp()
  List<LocalSchemeEntry>? schemes;
}

class LocalSchemeEntryLinux implements LocalSchemeEntry {
  @override
  String path;

  @override
  Scheme scheme;

  @override
  DateTime lastModifyTime;

  LocalSchemeEntryLinux({
    required this.path,
    required this.scheme,
    required this.lastModifyTime,
  });

  @override
  save() {
    // TODO: implement save
    throw UnimplementedError();
  }
}
