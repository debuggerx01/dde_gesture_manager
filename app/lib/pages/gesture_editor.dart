import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GestureEditor extends StatelessWidget {
  const GestureEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: context.t.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: layoutProvider.localManagerOpened == false,
                      child: DButton(
                        width: defaultButtonHeight,
                        onTap: () => H.openPanel(context, PanelType.local_manager),
                        child: Icon(
                          CupertinoIcons.square_list,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: layoutProvider.marketOpened == false,
                      child: DButton(
                        width: defaultButtonHeight,
                        onTap: () => H.openPanel(context, PanelType.market),
                        child: Icon(
                          CupertinoIcons.cart,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("<编辑器区域"),
                      Text("编辑器区域>"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
