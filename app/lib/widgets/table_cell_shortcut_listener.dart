import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/constants/keyboard_mapper.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/services.dart';

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
  _TableCellShortcutListenerState createState() => _TableCellShortcutListenerState();
}

class _TableCellShortcutListenerState extends State<TableCellShortcutListener> {
  List<String> _shortcut = [];
  bool inputMode = false;
  FocusNode _focusNode = FocusNode();

  _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onComplete(_shortcut.join('+'));
    }
  }

  _tryToAddKey(LogicalKeyboardKey key) {
    if (key.keyLabel.length == 1) key.keyLabel.sout();
    late String _key;
    if (keyMapper.containsKey(key))
      _key = keyMapper[key]!;
    else if (key.keyLabel.length == 1) _key = key.keyLabel.toLowerCase();

    if (!_shortcut.contains(_key)) {
      setState(() {
        _shortcut.add(_key);
      });
    }
  }

  @override
  void initState() {
    _shortcut = widget.initShortcut.split('+');
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (evt) {
        RawKeyboard.instance.keysPressed.forEach(_tryToAddKey);
        RawKeyboard.instance.keysPressed.sout();
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _shortcut = [];
            inputMode = true;
          });
        },
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
                      ? context.watch<SettingsProvider>().activeColor ?? Color(0xff565656)
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
                              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
                              color: context.t.dialogBackgroundColor,
                              border: Border.all(width: 1, color: Color(0xff565656)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                e.notNull ? e : LocaleKeys.str_null.tr(),
                                style: TextStyle(
                                  color: context.watch<SettingsProvider>().activeColor,
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
