import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DButton(
                      width: defaultButtonHeight - 2,
                      height: defaultButtonHeight - 2,
                      onTap: () => context.read<ContentLayoutProvider>().setProps(marketOpened: !isOpen),
                      child: Icon(
                        CupertinoIcons.chevron_right_2,
                        size: 20,
                      ),
                    ),
                    Flexible(
                      child: Center(
                        child: Text(
                          "方案市场",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(width: defaultButtonHeight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
