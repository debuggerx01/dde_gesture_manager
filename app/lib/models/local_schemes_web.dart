import 'dart:convert';
import 'dart:html';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:uuid/uuid.dart';

import 'local_schemes.dart';

export 'local_schemes.dart';

@ProviderModel()
class LocalSchemes implements LocalSchemesInterface<LocalSchemeEntryWeb> {
  LocalSchemes() {
    schemeEntries.then((value) => schemes = [LocalSchemeEntryWeb.systemDefault(), ...value..sort()]);
  }

  @override
  Future<List<LocalSchemeEntryWeb>> get schemeEntries async {
    List<LocalSchemeEntryWeb> _localeSchemes = [];
    for (var key in window.localStorage.keys) {
      if (key.startsWith('schemes.')) {
        var content = window.localStorage[key] ?? '';
        var schemeJson;
        try {
          schemeJson = json.decode(content);
        } catch (e) {
          e.sout();
        }
        if (schemes != null) {
          _localeSchemes.add(LocalSchemeEntryWeb(
            path: key,
            scheme: Scheme.parse(schemeJson),
            lastModifyTime: DateTime.parse(schemeJson['modified_at']),
          ));
        }
      }
    }
    return Future.value(_localeSchemes);
  }

  @ProviderModelProp()
  List<LocalSchemeEntry>? schemes;

  @override
  Future<LocalSchemeEntry> create() => Future.value(
        LocalSchemeEntryWeb(
          path: 'schemes.${Uuid().v1()}',
          scheme: Scheme.create(),
          lastModifyTime: DateTime.now(),
        ),
      );

  @override
  remove(String path) => window.localStorage.remove(path);
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
  save(LocalSchemesProvider provider) {
    var schemeMap = scheme.toJson();
    schemeMap['modified_at'] = DateTime.now().toIso8601String();
    window.localStorage[path] = JsonEncoder.withIndent(' ' * 4).convert(schemeMap);
    provider.schemes!.firstWhere((ele) => ele.scheme.id == scheme.id).lastModifyTime = DateTime.now();
    provider.setProps(schemes: [...provider.schemes!]..sort());
  }

  @override
  int compareTo(other) {
    assert(other is LocalSchemeEntry);
    return lastModifyTime.isAfter(other.lastModifyTime) ? -1 : 1;
  }
}
