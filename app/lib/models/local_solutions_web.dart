import 'dart:convert';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/models/solution.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'dart:html';

import 'local_solutions.dart';
export 'local_solutions.dart';

@ProviderModel()
class LocalSolutions implements LocalSolutionsInterface<LocalSolutionEntryWeb> {
  LocalSolutions() {
    solutionEntries.then((value) => solutions = value);
  }

  @override
  Future<List<LocalSolutionEntryWeb>> get solutionEntries async {
    return window.localStorage.keys
        .map<LocalSolutionEntryWeb?>((key) {
          if (key.startsWith('solutions.')) {
            LocalSolutionEntryWeb? entry;
            try {
              var content = window.localStorage[key] ?? '';
              var solutionJson = json.decode(content);
              entry = LocalSolutionEntryWeb(
                path: key,
                solution: Solution.parse(solutionJson),
                lastModifyTime: DateTime.parse(solutionJson['modified_at']),
              );
            } catch (e) {
              e.sout();
            }
            return entry;
          }
        })
        .where((e) => e != null)
        .cast<LocalSolutionEntryWeb>()
        .toList();
  }

  @ProviderModelProp()
  List<LocalSolutionEntry>? solutions;
}

class LocalSolutionEntryWeb implements LocalSolutionEntry {
  @override
  String path;

  @override
  Solution solution;

  @override
  DateTime lastModifyTime;

  LocalSolutionEntryWeb({
    required this.path,
    required this.solution,
    required this.lastModifyTime,
  });

  @override
  save() {
    // TODO: implement save
    throw UnimplementedError();
  }
}
