import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/pages/gesture_editor.dart';
import 'package:dde_gesture_manager/pages/local_manager.dart';
import 'package:dde_gesture_manager/pages/market_or_me.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class CopiedGesturePropProvider extends GesturePropProvider {
  CopiedGesturePropProvider.empty() : super.empty();
}

class _ContentState extends State<Content> {
  double? preWindowWidth;

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var preferredPanelsStatus = H.getPreferredPanelsStatus(windowWidth);
    var widthChanged = preWindowWidth != null && preWindowWidth != windowWidth;
    var widget = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContentLayoutProvider()
            ..localManagerOpened = preferredPanelsStatus.localManagerPanelOpened
            ..marketOrMeOpened = preferredPanelsStatus.marketOrMePanelOpened,
        ),
        ChangeNotifierProvider(
          create: (context) => CopiedGesturePropProvider.empty(),
        ),
      ],
      builder: (context, child) {
        if (widthChanged && mounted) {
          Future.microtask(
            () => context.read<ContentLayoutProvider>().setProps(
                  localManagerOpened: preferredPanelsStatus.localManagerPanelOpened,
                  marketOrMeOpened: preferredPanelsStatus.marketOrMePanelOpened,
                ),
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocalManager(),
            GestureEditor(),
            MarketOrMe(),
          ],
        );
      },
    );
    preWindowWidth = windowWidth;
    return widget;
  }
}
