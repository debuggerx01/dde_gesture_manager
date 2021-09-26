import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

class Market extends StatelessWidget {
  const Market({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isOpen = context.watch<ContentLayoutProvider>().marketOpened == true;
    return AnimatedContainer(
      duration: mediumDuration,
      curve: Curves.easeInOut,
      width: isOpen ? marketPanelWidth : 0,
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: marketPanelWidth,
        minWidth: marketPanelWidth,
        child: Material(
          color: context.t.backgroundColor,
          elevation: isOpen ? 10 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.read<ContentLayoutProvider>().setProps(marketOpened: !isOpen),
                    icon: Icon(
                      CupertinoIcons.chevron_right_2,
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child: Text(
                        "配置市场",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
