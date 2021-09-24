import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/pages/gesture_editor.dart';
import 'package:dde_gesture_manager/pages/local_manager.dart';
import 'package:dde_gesture_manager/pages/market.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContentLayoutProvider()
        ..localManagerOpened = true
        ..marketOpened = true,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LocalManager(),
          GestureEditor(),
          Market(),
        ],
      ),
    );
  }
}
