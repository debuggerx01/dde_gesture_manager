import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

class LocalManager extends StatelessWidget {
  const LocalManager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isOpen = context.watch<ContentLayoutProvider>().localManagerOpened == true;
    isOpen.sout();
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: context.t.backgroundColor,
      width: isOpen ? 200 : 36,
      child: Column(
        children: [
          OverflowBox(
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text("本地配置"),
                  ),
                  IconButton(
                    onPressed: () => context.read<ContentLayoutProvider>().setProps(localManagerOpened: !isOpen),
                    icon: Icon(
                      isOpen ? CupertinoIcons.chevron_left_2 : CupertinoIcons.chevron_right_2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
