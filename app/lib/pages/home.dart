import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/pages/content.dart';
import 'package:dde_gesture_manager/pages/footer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SchemeProvider.parse('''
          {
            "name": "test",
            "desc": "some desc",
            "gestures": [
              {
                "gesture": "swipe",
                "direction": "down",
                "fingers": 3,
                "type": "shortcut",
                "command": "ctrl+w",
                "remark": "close current page."
              },
              {
                "gesture": "swipe",
                "direction": "up",
                "fingers": 3,
                "type": "shortcut",
                "command": "ctrl+alt+t",
                "remark": "reopen last closed page."
              },
              {
                "gesture": "pinch",
                "direction": "in",
                "fingers": 4,
                "type": "shortcut",
                "command": "ctrl+alt+f",
                "remark": "search files."
              },
              {
                "gesture": "tap",
                "fingers": 4,
                "type": "built_in",
                "command": "handle4FingersTap",
                "remark": "handle4FingersTap."
              },
              {
                "gesture": "swipe",
                "direction": "down",
                "fingers": 5,
                "type": "commandline",
                "command": "dbus-send --type=method_call --dest=com.deepin.dde.Launcher /com/deepin/dde/Launcher com.deepin.dde.Launcher.Toggle",
                "remark": "toggle launcher."
              }
            ]
          }
          ''')),
          ChangeNotifierProvider(create: (context) => GesturePropProvider.empty()),
          ChangeNotifierProvider(create: (context) => LocalSchemesProvider(),lazy: false),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Content(),
            ),
            SizedBox(
              height: 36,
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}
