import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DTextField extends StatefulWidget {
  final String? initText;
  final String? hint;
  final bool readOnly;
  final Function(String value) onComplete;

  const DTextField({
    Key? key,
    this.initText,
    this.hint,
    this.readOnly = false,
    required this.onComplete,
  }) : super(key: key);

  @override
  _DTextFieldState createState() => _DTextFieldState();
}

class _DTextFieldState extends State<DTextField> {
  final FocusNode _focusNode = FocusNode();
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
  void didUpdateWidget(covariant DTextField oldWidget) {
    if (oldWidget.initText != widget.initText) {
      _controller.text = widget.initText ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (context) {
        return Container(
          height: kMinInteractiveDimension * .86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            color: Colors.grey.withOpacity(.3),
            border: Border.all(
                width: 2,
                color: Focus.of(context).hasFocus && !widget.readOnly
                    ? context.watch<SettingsProvider>().activeColor ?? Color(0xff565656)
                    : Color(0xff565656)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextField(
                readOnly: widget.readOnly,
                focusNode: _focusNode,
                cursorColor: context.watch<SettingsProvider>().activeColor,
                decoration: InputDecoration.collapsed(hintText: widget.hint),
                controller: _controller,
              ),
            ),
          ),
        );
      }),
    );
  }
}
