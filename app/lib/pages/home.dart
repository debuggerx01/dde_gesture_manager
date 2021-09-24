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
      body: Column(
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
    );
  }
}
