import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(defaultBorderRadius),
                                border: Border.all(
                                  width: .2,
                                  color: context.t.dividerColor,
                                ),
                              ),
                              columns: [
                                DDataColumn(label: Text('gesture')),
                                DDataColumn(label: Text('direction')),
                                DDataColumn(label: Text('fingers')),
                                DDataColumn(label: Text('type')),
                                DDataColumn(label: Text('command')),
                                DDataColumn(label: Text('remark')),
                              ],
                              rows: [
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('right')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('shortcut')),
                                    DDataCell(Text('ctrl+w')),
                                    DDataCell(Text('close current page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('left')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('shortcut')),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('left')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('shortcut')),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('left')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('shortcut')),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('left')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('shortcut')),
                                    DDataCell(Text('ctrl+alt+t')),
                                    DDataCell(Text('reopen last closed page.')),
                                  ],
                                ),
                                DDataRow(
                                  cells: [
                                    DDataCell(Text('swipe')),
                                    DDataCell(Text('down')),
                                    DDataCell(Text('3')),
                                    DDataCell(Text('commandline')),
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
                  height: 400,
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
