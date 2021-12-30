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
          ChangeNotifierProvider(create: (context) => SchemeProvider.systemDefault()),
          ChangeNotifierProvider(create: (context) => GesturePropProvider.empty()),
          ChangeNotifierProvider(create: (context) => LocalSchemesProvider(), lazy: false),
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
