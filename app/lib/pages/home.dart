import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/solution.provider.dart';
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
          ChangeNotifierProvider(create: (context) => SolutionProvider.parse('''
          {
            "name": "test",
            "desc": "some desc",
            "gestures": [
              {
                "gesture": "swipe",
                "direction": "up",
                "fingers": 3,
                "type": "shortcut",
                "command": "ctrl+w"
              }
            ]
          }
          ''')),
          // ChangeNotifierProvider(create: (context) => GesturePropProvider()),
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
