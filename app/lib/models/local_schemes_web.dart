import 'dart:convert';
import 'dart:html';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart';

import 'local_schemes.dart';

export 'local_schemes.dart';

@ProviderModel()
class LocalSchemes implements LocalSchemesInterface<LocalSchemeEntryWeb> {
  LocalSchemes() {
    schemeEntries.then((value) => schemes = [LocalSchemeEntryWeb.systemDefault(), ...value]);
  }

  @override
  Future<List<LocalSchemeEntryWeb>> get schemeEntries async {
    return window.localStorage.keys
        .map<LocalSchemeEntryWeb?>((key) {
          if (key.startsWith('schemes.')) {
            LocalSchemeEntryWeb? entry;
            try {
              var content = window.localStorage[key] ?? '';
              var schemeJson = json.decode(content);
              entry = LocalSchemeEntryWeb(
                path: key,
                scheme: Scheme.parse(schemeJson),
                lastModifyTime: DateTime.parse(schemeJson['modified_at']),
              );
            } catch (e) {
              e.sout();
            }
            return entry;
          }
        })
        .where((e) => e != null)
        .cast<LocalSchemeEntryWeb>()
        .toList();
  }

  @ProviderModelProp()
  List<LocalSchemeEntry>? schemes;
}

class LocalSchemeEntryWeb implements LocalSchemeEntry {
  @override
  String path;

  @override
  Scheme scheme;

  @override
  DateTime lastModifyTime;

  LocalSchemeEntryWeb({
    required this.path,
    required this.scheme,
    required this.lastModifyTime,
  });

  LocalSchemeEntryWeb.systemDefault()
      : this.path = '',
        this.scheme = Scheme.systemDefault(),

        /// max value of DateTime ![Time Values and Time Range](https://262.ecma-international.org/11.0/#sec-time-values-and-time-range)
        this.lastModifyTime = DateTime.fromMillisecondsSinceEpoch(8640000000000000);

  @override
  save() {
    // TODO: implement save
    throw UnimplementedError();
  }
}
