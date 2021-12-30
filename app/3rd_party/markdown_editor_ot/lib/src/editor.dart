import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_ot/src/action.dart';
import 'package:markdown_editor_ot/customize_physics.dart';
import 'package:markdown_editor_ot/src/edit_perform.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void OnComplete(String content);

class MdEditor extends StatefulWidget {
  MdEditor({
    Key? key,
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.initText,
    this.hintText,
    this.hintTextStyle,
    this.imageSelect,
    this.textChange,
    this.actionIconColor,
    this.cursorColor,
    this.appendBottomWidget,
    this.splitWidget,
    this.textFocusNode,
    required this.onComplete,
  }) : super(key: key);

  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final EdgeInsetsGeometry padding;
  final String? initText;
  final String? hintText;

  /// see [ImageSelectCallback]
  final ImageSelectCallback? imageSelect;

  final VoidCallback? textChange;

  /// Change icon color, eg: color of font_bold icon.
  final Color? actionIconColor;

  final Color? cursorColor;

  final Widget? appendBottomWidget;

  final Widget? splitWidget;

  final FocusNode? textFocusNode;

  final OnComplete onComplete;

  @override
  State<StatefulWidget> createState() => MdEditorState();
}

class MdEditorState extends State<MdEditor> with AutomaticKeepAliveClientMixin {
  final _textEditingController = TextEditingController(text: '');
  var _editPerform;
  SharedPreferences? _pres;

  String getText() {
    return _textEditingController.value.text;
  }

  // 将文本框光标移动至末尾
  void moveTextCursorToEnd() {
    final str = _textEditingController.text;
    _textEditingController.value = TextEditingValue(text: str, selection: TextSelection.collapsed(offset: str.length));
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.initText ?? '';

    _editPerform = EditPerform(
      _textEditingController,
      initText: _textEditingController.text,
    );
  }

  void _disposeText(
    ActionType type,
    String text,
    int index, [
    int? cursorPosition,
  ]) {
    final _tempKey = 'markdown_editor_${type.toString()}';
    _pres?.setInt(_tempKey, (_pres?.getInt(_tempKey) ?? 0) + 1);
    debugPrint('$_tempKey   ${_pres?.getInt(_tempKey)}');

    var position = cursorPosition ?? _textEditingController.selection.base.offset;

    if (position < 0) {
      print('WARN: The insert position value is $position');
      return;
    }

    var startText = _textEditingController.text.substring(0, position);
    var endText = _textEditingController.text.substring(position);

    var str = startText + text + endText;
    _textEditingController.value =
        TextEditingValue(text: str, selection: TextSelection.collapsed(offset: startText.length + text.length - index));

    if (widget.textChange != null) widget.textChange!();

    _editPerform.change(_textEditingController.text);
  }

  /// 获取光标位置
  int _getCursorPosition() {
    if (_textEditingController.text.isEmpty) return 0;
    if (_textEditingController.selection.base.offset < 0) return _textEditingController.text.length;
    return _textEditingController.selection.base.offset;
  }

  Future<void> _initSharedPreferences() async {
    _pres = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: widget.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    maxLines: null,
                    minLines: 7,
                    textAlignVertical: TextAlignVertical.top,
                    cursorColor: widget.cursorColor,
                    cursorWidth: 1.5,
                    controller: _textEditingController,
                    focusNode: widget.textFocusNode,
                    autofocus: false,
                    scrollPhysics: const CustomizePhysics(),
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: 17,
                          height: kIsWeb ? null : 1.3,
                        ),
                    onChanged: (text) {
                      _editPerform.change(text);
                      if (widget.textChange != null) widget.textChange!();
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? '请输入内容',
                      border: InputBorder.none,
                      hintStyle: widget.hintTextStyle,
                    ),
                  ),
                  widget.appendBottomWidget ?? const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black87 : const Color(0xFFF0F0F0),
                boxShadow: [
                  BoxShadow(
                      color:
                          Theme.of(context).brightness == Brightness.dark ? Colors.black87 : const Color(0xAAF0F0F0)),
                ],
              ),
              child: FutureBuilder(
                future: _pres == null ? _initSharedPreferences() : null,
                builder: (con, snap) {
                  final widgets = <ActionImage>[];

                  widgets.add(ActionImage(
                    type: ActionType.done,
                    color: widget.actionIconColor,
                    tap: (t, s, i, [p]) {
                      widget.onComplete(getText());
                    },
                  ));

                  widgets.add(ActionImage(
                    type: ActionType.undo,
                    color: widget.actionIconColor,
                    tap: (t, s, i, [p]) {
                      _editPerform.undo();
                    },
                  ));
                  widgets.add(ActionImage(
                    type: ActionType.redo,
                    color: widget.actionIconColor,
                    tap: (t, s, i, [p]) {
                      _editPerform.redo();
                    },
                  ));

                  // sort
                  if (snap.connectionState == ConnectionState.done || snap.connectionState == ConnectionState.none)
                    widgets.addAll(_getSortActionWidgets().map((sort) => sort.widget));

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widgets,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Sort action buttons by used count.
  List<_SortActionWidget> _getSortActionWidgets() {
    final sortWidget = <_SortActionWidget>[];
    final key = 'markdown_editor';
    final getSortValue = (ActionType type) {
      return int.parse((_pres?.get('${key}_${type.toString()}') ?? '0').toString());
    };
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.image),
      widget: ActionImage(
        type: ActionType.image,
        color: widget.actionIconColor,
        tap: _disposeText,
        imageSelect: widget.imageSelect,
        getCursorPosition: _getCursorPosition,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.link),
      widget: ActionImage(
        type: ActionType.link,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.fontBold),
      widget: ActionImage(
        type: ActionType.fontBold,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.fontItalic),
      widget: ActionImage(
        type: ActionType.fontItalic,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.fontStrikethrough),
      widget: ActionImage(
        type: ActionType.fontStrikethrough,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.textQuote),
      widget: ActionImage(
        type: ActionType.textQuote,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.list),
      widget: ActionImage(
        type: ActionType.list,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.h4),
      widget: ActionImage(
        type: ActionType.h4,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.h5),
      widget: ActionImage(
        type: ActionType.h5,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.h1),
      widget: ActionImage(
        type: ActionType.h1,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.h2),
      widget: ActionImage(
        type: ActionType.h2,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: getSortValue(ActionType.h3),
      widget: ActionImage(
        type: ActionType.h3,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));

    sortWidget.sort((a, b) => (b.sortValue).compareTo(a.sortValue));

    return sortWidget;
  }

  @override
  bool get wantKeepAlive => true;
}

class _SortActionWidget {
  final ActionImage widget;
  final int sortValue;

  _SortActionWidget({
    required this.widget,
    required this.sortValue,
  });
}
