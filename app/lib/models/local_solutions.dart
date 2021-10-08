export 'local_solutions_web.dart' if (dart.library.io) 'local_solutions_linux.dart';

import 'package:dde_gesture_manager/models/solution.dart';

abstract class LocalSolutionEntry {
  Solution solution;
  DateTime lastModifyTime;
  String path;

  LocalSolutionEntry({
    required this.path,
    required this.solution,
    required this.lastModifyTime,
  });

  save();
}

abstract class LocalSolutionsInterface<T extends LocalSolutionEntry> {
  Future<List<T>> get solutionEntries;
}