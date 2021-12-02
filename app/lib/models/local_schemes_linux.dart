import 'dart:convert';
import 'dart:io';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'local_schemes.dart';
import 'local_schemes_provider.dart';

export 'local_schemes.dart';

@ProviderModel()
class LocalSchemes implements LocalSchemesInterface<LocalSchemeEntryLinux> {
  LocalSchemes() {
    schemeEntries.then((value) => schemes = [LocalSchemeEntryLinux.systemDefault(), ...value..sort()]);
  }

  @override
  Future<List<LocalSchemeEntryLinux>> get schemeEntries async {
    var _supportDirectory = await getApplicationSupportDirectory();
    var directory = Directory(join(_supportDirectory.path, 'schemes'));
    if (!directory.existsSync()) directory.createSync();
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

  @override
  Future<LocalSchemeEntry> create() async {
    var _supportDirectory = await getApplicationSupportDirectory();
    return LocalSchemeEntryLinux(
        path: join(_supportDirectory.path, 'schemes', '${Uuid().v1()}.json'),
        scheme: Scheme.create(),
        lastModifyTime: DateTime.now(),
      );
  }

  @override
  void remove(String path) {
    File(path).delete();
  }
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

  LocalSchemeEntryLinux.systemDefault()
      : this.path = '',
        this.scheme = Scheme.systemDefault(),

        /// max value of DateTime ![Time Values and Time Range](https://262.ecma-international.org/11.0/#sec-time-values-and-time-range)
        this.lastModifyTime = DateTime.fromMillisecondsSinceEpoch(8640000000000000);

  @override
  save(LocalSchemesProvider provider) {
    var file = File(path);
    file.writeAsStringSync(JsonEncoder.withIndent(' ' * 4).convert(scheme));
    provider.schemes!.firstWhere((ele) => ele.scheme.id == scheme.id).lastModifyTime = DateTime.now();
    provider.setProps(schemes: [...provider.schemes!]..sort());
  }

  @override
  int compareTo(other) {
    assert(other is LocalSchemeEntry);
    return lastModifyTime.isAfter(other.lastModifyTime) ? -1 : 1;
  }
}
