import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableCellTextField extends StatefulWidget {
  final String? initText;
  final String? hint;
  final Function(String value) onComplete;

  const TableCellTextField({
    Key? key,
    this.initText,
    this.hint,
    required this.onComplete,
  }) : super(key: key);

  @override
  _TableCellTextFieldState createState() => _TableCellTextFieldState();
}

class _TableCellTextFieldState extends State<TableCellTextField> {
  final FocusNode _focusNode = FocusNode(
    onKeyEvent: (_, __) => KeyEventResult.skipRemainingHandlers,
  );
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(_handleFocusChange);
    _controller.text = widget.initText ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onComplete(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kMinInteractiveDimension * .86,
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
          padding: EdgeInsets.only(left: 15),
          child: TextField(
            focusNode: _focusNode,
            cursorColor: context.watch<SettingsProvider>().activeColor,
            decoration: InputDecoration.collapsed(hintText: widget.hint),
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
