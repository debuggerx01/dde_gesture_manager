// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library xdg_directories;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:universal_io/io.dart';

class XDGDirectoriesPlugin {
  static void registerWith(Registrar registrar) => null;
}

@override
Directory get cacheHome => throw UnimplementedError();

@override
List<Directory> get configDirs => throw UnimplementedError();

@override
Directory get configHome => throw UnimplementedError();

@override
List<Directory> get dataDirs => throw UnimplementedError();

@override
Directory get dataHome => throw UnimplementedError();

@override
Directory? getUserDirectory(String dirName) {
  throw UnimplementedError();
}

@override
Set<String> getUserDirectoryNames() {
  throw UnimplementedError();
}

@override
Directory? get runtimeDir => throw UnimplementedError();
