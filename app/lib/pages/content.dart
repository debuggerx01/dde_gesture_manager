import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/pages/gesture_editor.dart';
import 'package:dde_gesture_manager/pages/local_manager.dart';
import 'package:dde_gesture_manager/pages/market.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  double? preWindowWidth;

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var preferredPanelsStatus = H.getPreferredPanelsStatus(windowWidth);
    var widthChanged = preWindowWidth != null && preWindowWidth != windowWidth;
    var widget = ChangeNotifierProvider(
      create: (context) => ContentLayoutProvider()
        ..localManagerOpened = preferredPanelsStatus.localManagerPanelOpened
        ..marketOpened = preferredPanelsStatus.marketPanelOpened,
      builder: (context, child) {
        if (widthChanged && mounted) {
          Future.microtask(
            () => context.read<ContentLayoutProvider>().setProps(
                  localManagerOpened: preferredPanelsStatus.localManagerPanelOpened,
                  marketOpened: preferredPanelsStatus.marketPanelOpened,
                ),
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocalManager(),
            GestureEditor(),
            Market(),
          ],
        );
      },
    );
    preWindowWidth = windowWidth;
    return widget;
  }
}
