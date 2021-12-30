import 'package:dde_gesture_manager/models/scheme.dart';

import 'local_schemes_provider.dart';

export 'local_schemes_web.dart' if (dart.library.io) 'local_schemes_linux.dart';

abstract class LocalSchemeEntry implements Comparable {
  Scheme scheme;
  DateTime lastModifyTime;
  String path;

  LocalSchemeEntry({
    required this.path,
    required this.scheme,
    required this.lastModifyTime,
  });

  LocalSchemeEntry.systemDefault()
      : this.path = '',
        this.scheme = Scheme.systemDefault(),

        /// max value of DateTime ![Time Values and Time Range](https://262.ecma-international.org/11.0/#sec-time-values-and-time-range)
        this.lastModifyTime = DateTime.fromMillisecondsSinceEpoch(8640000000000000);

  save(LocalSchemesProvider provider);
}

abstract class LocalSchemesInterface<T extends LocalSchemeEntry> {
  Future<List<T>> get schemeEntries;

  Future<LocalSchemeEntry> create();

  void remove(String path);
}
