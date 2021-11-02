import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager/widgets/dde_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _headingRowHeight = 56;
const double _scrollBarWidth = 14;

class GestureEditor extends StatelessWidget {
  const GestureEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    var schemeProvider = context.watch<SchemeProvider>();
    final horizontalCtrl = ScrollController();
    final verticalCtrl = ScrollController();

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
                  child: GestureDetector(
                    onTap: () {
                      context.read<GesturePropProvider>().copyFrom(GestureProp.empty());
                    },
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
                        return AdaptiveScrollbar(
                          controller: verticalCtrl,
                          underColor: Colors.transparent,
                          sliderDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                            color: Colors.grey.withOpacity(.4),
                          ),
                          sliderActiveDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                            color: Colors.grey.withOpacity(.6),
                          ),
                          position: ScrollbarPosition.right,
                          underSpacing: EdgeInsets.only(top: _headingRowHeight),
                          width: _scrollBarWidth,
                          child: AdaptiveScrollbar(
                            width: _scrollBarWidth,
                            underColor: Colors.transparent,
                            sliderDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                              color: Colors.grey.withOpacity(.4),
                            ),
                            sliderActiveDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                              color: Colors.grey.withOpacity(.6),
                            ),
                            controller: horizontalCtrl,
                            position: ScrollbarPosition.bottom,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: horizontalCtrl,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: DDataTable(
                                  showBottomBorder: true,
                                  headingRowHeight: _headingRowHeight,
                                  showCheckboxColumn: true,
                                  headerBackgroundColor: context.t.dialogBackgroundColor,
                                  verticalScrollController: verticalCtrl,
                                  dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) return context.t.dialogBackgroundColor;
                                    if (states.contains(MaterialState.selected))
                                      return context.read<SettingsProvider>().currentActiveColor;
                                    return null;
                                  }),
                                  columns: [
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_fingers.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_gesture.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_direction.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_type.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_command.tr())),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_remark.tr())),
                                  ],
                                  rows: _buildDataRows(schemeProvider.gestures, context),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
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

List<DDataRow> _buildDataRows(List<GestureProp>? gestures, BuildContext context) => (gestures ?? []).map((gesture) {
      var gesturePropProvider = context.watch<GesturePropProvider>();
      bool editing = gesturePropProvider == gesture && gesturePropProvider.editMode == true;
      bool selected = gesturePropProvider == gesture && !editing;
      return DDataRow(
        onSelectChanged: (selected) {
          if (selected == true)
            context.read<GesturePropProvider>().setProps(
                  id: gesture.id,
                  editMode: false,
                );
          else if (selected == false) {
            var provider = context.read<GesturePropProvider>();
            provider.onEditEnd = () {
              /// todo: resort rows && check where changed
            };
            provider.setProps(
              editMode: true,
            );
          }
        },
        selected: selected,
        cells: editing ? _buildRowCellsEditing(gesture) : _buildRowCellsNormal(context, selected, gesture),
      );
    }).toList();

List<DDataCell> _buildRowCellsEditing(GestureProp gesture) => [
      Center(child: Text('1')),
      Center(child: Text('2')),
      Center(child: Text('3')),
      Center(child: Text('4')),
      TextField(controller: TextEditingController(text: gesture.command)),
      TextField(controller: TextEditingController(text: gesture.remark)),
    ].map((e) => DDataCell(e)).toList();

List<DDataCell> _buildRowCellsNormal(BuildContext context, bool selected, GestureProp gesture) => [
      Center(
        child: Text(
          '${gesture.fingers}',
        ),
      ),
      Center(
        child: Text(
          '${LocaleKeys.gesture_editor_gestures}.${H.getGestureName(gesture.gesture)}',
        ).tr(),
      ),
      Center(
          child: Text(
        '${LocaleKeys.gesture_editor_directions}.${H.getGestureDirectionName(gesture.direction)}',
      ).tr()),
      Center(
          child: Text(
        '${LocaleKeys.gesture_editor_types}.${H.getGestureTypeName(gesture.type)}',
      ).tr()),
      Text(
        gesture.command ?? '',
      ),
      Text(
        gesture.remark ?? '',
      ),
    ]
        .map(
          (ele) => DDataCell(DefaultTextStyle(
              style: context.t.textTheme.bodyText2!.copyWith(
                color: selected ? Colors.white : null,
              ),
              child: ele)),
        )
        .toList();
