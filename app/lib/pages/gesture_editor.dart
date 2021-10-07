import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/solution.dart';
import 'package:dde_gesture_manager/models/solution.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager/widgets/dde_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GestureEditor extends StatelessWidget {
  const GestureEditor({Key? key}) : super(key: key);

  List<DDataRow> _buildDataRow(List<GestureProp>? gestures, BuildContext context) => (gestures ?? [])
      .map((gesture) => DDataRow(
            onSelectChanged: (selected) {
              if (selected == true)
                context.read<GesturePropProvider>().setProps(
                      gesture: gesture.gesture,
                      direction: gesture.direction,
                      fingers: gesture.fingers,
                      type: gesture.type,
                      command: gesture.command,
                      remark: gesture.remark,
                    );
            },
            selected: context.watch<GesturePropProvider>() == gesture,
            cells: [
              Center(
                child: Text('${LocaleKeys.gesture_editor_gestures}.${H.getGestureName(gesture.gesture)}').tr(),
              ),
              Text('${LocaleKeys.gesture_editor_directions}.${H.getGestureDirectionName(gesture.direction)}').tr(),
              Center(
                child: Text('${gesture.fingers}'),
              ),
              Center(child: Text('${LocaleKeys.gesture_editor_types}.${H.getGestureTypeName(gesture.type)}').tr()),
              Text(gesture.command ?? ''),
              Text(gesture.remark ?? ''),
            ]
                .map(
                  (ele) => DDataCell(ele),
                )
                .toList(),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    var solutionProvider = context.watch<SolutionProvider>();
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
                              showCheckboxColumn: true,
                              headerBackgroundColor: context.t.dialogBackgroundColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(defaultBorderRadius),
                                border: Border.all(
                                  width: .2,
                                  color: context.t.dividerColor,
                                ),
                              ),
                              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) return Colors.grey;
                                if (states.contains(MaterialState.selected)) return Colors.green;
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
                              rows: _buildDataRow(solutionProvider.gestures, context),
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
