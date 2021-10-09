import 'dart:convert';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'dart:html';

import 'local_schemes.dart';
export 'local_schemes.dart';

@ProviderModel()
class LocalSchemes implements LocalSchemesInterface<LocalSchemeEntryWeb> {
  LocalSchemes() {
    schemeEntries.then((value) => schemes = value);
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

  @override
  save() {
    // TODO: implement save
    throw UnimplementedError();
  }
}
