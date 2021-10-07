import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/solution.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager/widgets/dde_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GestureEditor extends StatelessWidget {
  const GestureEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    var solutionProvider = context.watch<SolutionProvider>();
    solutionProvider.name.sout();
    solutionProvider.gestures.sout();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: context.t.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
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
                    Text(
                      LocaleKeys.gesture_editor_label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
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
                Container(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      border: Border.all(
                        width: .2,
                        color: context.t.dividerColor,
                      ),
                    ),
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                      return Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          primary: true,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DDataTable(
                              headerBackgroundColor: context.t.dialogBackgroundColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(defaultBorderRadius),
                                border: Border.all(
                                  width: .2,
                                  color: context.t.dividerColor,
                                ),
                              ),
                              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.blue;
                                return null;
                              }),
                              columns: [
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_gesture.tr())),
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_direction.tr())),
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_fingers.tr())),
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_type.tr())),
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_command.tr())),
                                DDataColumn(label: Text(LocaleKeys.gesture_editor_remark.tr())),
                              ],
                              rows: [
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_right).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_shortcut).tr()),
                                    DDataCell(Text('ctrl+w')),
                                    DDataCell(Text('close current page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_left).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_shortcut).tr()),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_left).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_shortcut).tr()),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_left).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_shortcut).tr()),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_left).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_shortcut).tr()),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text(LocaleKeys.gesture_editor_gestures_swipe).tr()),
                                    DDataCell(Text(LocaleKeys.gesture_editor_directions_down).tr()),
                                    DDataCell(Text('3')),
                                    DDataCell(Text(LocaleKeys.gesture_editor_types_commandline).tr()),
                                    DDataCell(Text(
                                        'dbus-send --type=method_call --dest=com.deepin.dde.Launcher /com/deepin/dde/Launcher com.deepin.dde.Launcher.Toggle')),
                                    DDataCell(TextButton(
                                      onPressed: () => print(123),
                                      child: Text('show launcher.'),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(height: 10),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    border: Border.all(
                      width: .2,
                      color: context.t.dividerColor,
                    ),
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
