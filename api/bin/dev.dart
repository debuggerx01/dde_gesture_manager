import 'dart:io';
import 'package:dde_gesture_manager_api/dde_gesture_manager_api.dart';
import 'package:belatuk_pretty_logging/belatuk_pretty_logging.dart';
import 'package:angel3_container/mirrors.dart';
import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_hot/angel3_hot.dart';
import 'package:logging/logging.dart';

void main() async {
  // Watch the config/ and web/ directories for changes, and hot-reload the server.
  var hot = HotReloader(() async {
    Logger.root
      ..level = Level.ALL
      ..onRecord.listen(prettyLog);
    var logger = Logger.detached('dde_gesture_manager_api');
    var app = Angel(logger: logger, reflector: MirrorsReflector());
    await app.configure(configureServer);
    return app;
  }, [
    Directory('config'),
    Directory('lib'),
  ]);

  var server = await hot.startServer('127.0.0.1', 3000);
  print('dde_gesture_manager_api server listening at http://${server.address.address}:${server.port}');
}
