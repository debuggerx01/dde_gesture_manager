import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/src/models/app_version.dart';
import 'package:file/file.dart';
import 'package:yaml/yaml.dart';

late FileSystem fs;

Future configureServer(Angel app) async {
  app.get(
    Apis.system.appVersion,
    (req, res) async {
      var pubspec = fs.currentDirectory.parent.childDirectory('app').childFile('pubspec.yaml').readAsStringSync();
      var version = loadYaml(pubspec)['version'] as String;
      var versions = version.split('+');
      return res.json(AppVersion(versionName: versions.first, versionCode: int.parse(versions.last)));
    },
  );
}

configureServerWithFileSystem(FileSystem fileSystem) {
  fs = fileSystem;
  return configureServer;
}
