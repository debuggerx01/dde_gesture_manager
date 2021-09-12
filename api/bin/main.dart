import 'package:dde_gesture_manager/dde_gesture_manager.dart';

Future main() async {
  final app = Application<DdeGestureManagerChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  await app.startOnCurrentIsolate();

  print("Application started on port: ${app.options.port}.");
  print("Click to open in browser: http://localhost:${app.options.port}");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
