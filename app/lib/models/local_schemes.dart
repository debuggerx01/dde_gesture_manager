export 'local_schemes_web.dart' if (dart.library.io) 'local_schemes_linux.dart';

import 'package:dde_gesture_manager/models/scheme.dart';

abstract class LocalSchemeEntry {
  Scheme scheme;
  DateTime lastModifyTime;
  String path;

  LocalSchemeEntry({
    required this.path,
    required this.scheme,
    required this.lastModifyTime,
  });

  save();
}

abstract class LocalSchemesInterface<T extends LocalSchemeEntry> {
  Future<List<T>> get schemeEntries;
}