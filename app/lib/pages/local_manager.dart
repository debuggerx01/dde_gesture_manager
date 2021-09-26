import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/constants/constants.dart';

class LocalManager extends StatelessWidget {
  const LocalManager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isOpen = context.watch<ContentLayoutProvider>().localManagerOpened == true;
    return AnimatedContainer(
      duration: mediumDuration,
      curve: Curves.easeInOut,
      width: isOpen ? localManagerPanelWidth : 0,
      child: OverflowBox(
        alignment: Alignment.centerRight,
        maxWidth: localManagerPanelWidth,
        minWidth: localManagerPanelWidth,
        child: Material(
          color: context.t.backgroundColor,
          elevation: isOpen ? 10 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Center(
                      child: Text(
                        "本地配置",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.read<ContentLayoutProvider>().setProps(localManagerOpened: !isOpen),
                    icon: Icon(
                      CupertinoIcons.chevron_left_2,
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
