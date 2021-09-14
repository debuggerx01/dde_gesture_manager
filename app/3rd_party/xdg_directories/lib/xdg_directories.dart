// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library xdg_directories;

import 'package:universal_io/io.dart';

import 'xdg_directories_web.dart' if (dart.library.io) 'xdg_directories_linux.dart';

typedef EnvironmentAccessor = String? Function(String envVar);

abstract class XDGDirectories {
  factory XDGDirectories() => getXDGDirectories();

  /// The base directory relative to which user-specific
  /// non-essential (cached) data should be written. (Corresponds to
  /// `$XDG_CACHE_HOME`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  Directory get cacheHome;

  /// The list of preference-ordered base directories relative to
  /// which configuration files should be searched. (Corresponds to
  /// `$XDG_CONFIG_DIRS`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  List<Directory> get configDirs;

  /// The a single base directory relative to which user-specific
  /// configuration files should be written. (Corresponds to `$XDG_CONFIG_HOME`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  Directory get configHome;

  /// The list of preference-ordered base directories relative to
  /// which data files should be searched. (Corresponds to `$XDG_DATA_DIRS`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  List<Directory> get dataDirs;

  /// The base directory relative to which user-specific data files should be
  /// written. (Corresponds to `$XDG_DATA_HOME`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  Directory get dataHome;

  /// The base directory relative to which user-specific runtime
  /// files and other file objects should be placed. (Corresponds to
  /// `$XDG_RUNTIME_DIR`).
  ///
  /// Throws [StateError] if the HOME environment variable is not set.
  Directory? get runtimeDir;

  /// Gets the xdg user directory named by `dirName`.
  ///
  /// Use [getUserDirectoryNames] to find out the list of available names.
  Directory? getUserDirectory(String dirName);

  /// Gets the set of user directory names that xdg knows about.
  ///
  /// These are not paths, they are names of xdg values.  Call [getUserDirectory]
  /// to get the associated directory.
  ///
  /// These are the names of the variables in "[configHome]/user-dirs.dirs", with
  /// the `XDG_` prefix removed and the `_DIR` suffix removed.
  Set<String> getUserDirectoryNames();
}
