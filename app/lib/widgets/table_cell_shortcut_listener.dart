import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

class TableCellShortcutListener extends StatefulWidget {
  final double width;
  final String initShortcut;
  final Function(String shortcut) onComplete;

  const TableCellShortcutListener({
    Key? key,
    this.width = 150.0,
    required this.initShortcut,
    required this.onComplete,
  }) : super(key: key);

  @override
  _TableCellShortcutListenerState createState() =>
      _TableCellShortcutListenerState();
}

class _TableCellShortcutListenerState extends State<TableCellShortcutListener> {
  List<String> _shortcut = [];

  @override
  void initState() {
    _shortcut = widget.initShortcut.split('+');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (evt) {
        evt.sout();
      },
      child: GestureDetector(
        onTap: () {},
        child: Focus(
          autofocus: true,
          onKeyEvent: (_, __) => KeyEventResult.skipRemainingHandlers,
          child: Container(
            height: kMinInteractiveDimension * .86,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              color: Colors.grey.withOpacity(.3),
              border: Border.all(
                  width: 2,
                  color: Focus.of(context).hasFocus
                      ? context.watch<SettingsProvider>().activeColor ??
                          Color(0xff565656)
                      : Color(0xff565656)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _shortcut
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  defaultBorderRadius / 2),
                              color: context.t.dialogBackgroundColor,
                              border: Border.all(
                                  width: 1,
                                  color: Focus.of(context).hasFocus
                                      ? context
                                              .watch<SettingsProvider>()
                                              .activeColor ??
                                          Color(0xff565656)
                                      : Color(0xff565656)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: context
                                      .watch<SettingsProvider>()
                                      .activeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
