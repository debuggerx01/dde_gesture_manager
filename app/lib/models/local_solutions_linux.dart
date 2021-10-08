import 'dart:io';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/solution.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'local_solutions.dart';

export 'local_solutions.dart';

@ProviderModel()
class LocalSolutions implements LocalSolutionsInterface<LocalSolutionEntryLinux> {
  LocalSolutions() {
    solutionEntries.then((value) => solutions = value);
  }

  @override
  Future<List<LocalSolutionEntryLinux>> get solutionEntries async {
    var _supportDirectory = await getApplicationSupportDirectory();
    var directory = Directory(join(_supportDirectory.path, 'solutions'));
    if (!directory.existsSync()) directory.createSync();
    directory.path.sout();
    return directory
        .list()
        .map<LocalSolutionEntryLinux?>((f) {
          LocalSolutionEntryLinux? entry;
          try {
            var content = File(f.path).readAsStringSync();
            entry = LocalSolutionEntryLinux(
                path: f.path, solution: Solution.parse(content), lastModifyTime: f.statSync().modified);
          } catch (e) {
            e.sout();
          }
          return entry;
        })
        .where((e) => e != null)
        .cast<LocalSolutionEntryLinux>()
        .toList();
  }

  @ProviderModelProp()
  List<LocalSolutionEntry>? solutions;
}

class LocalSolutionEntryLinux implements LocalSolutionEntry {
  @override
  String path;

  @override
  Solution solution;

  @override
  DateTime lastModifyTime;

  LocalSolutionEntryLinux({
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
