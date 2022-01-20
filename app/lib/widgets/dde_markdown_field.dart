import 'package:cached_network_image/cached_network_image.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_ot/markdown_editor.dart';

class DMarkdownField extends StatefulWidget {
  const DMarkdownField({
    Key? key,
    required this.initText,
    required this.onComplete,
    required this.readOnly,
  }) : super(key: key);

  final bool readOnly;
  final String? initText;
  final OnComplete onComplete;

  @override
  _DMarkdownFieldState createState() => _DMarkdownFieldState();
}

class _DMarkdownFieldState extends State<DMarkdownField> {
  String? _previewText;

  bool get isPreview => _previewText != null || widget.readOnly;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _previewText = widget.initText;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DMarkdownField oldWidget) {
    if (oldWidget.initText != widget.initText) {
      setState(() {
        _previewText = widget.initText;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            color: Colors.grey.withOpacity(.3),
            border: Border.all(
                width: 2,
                color: Focus.of(context).hasFocus && !widget.readOnly
                    ? context.watch<SettingsProvider>().activeColor ?? Color(0xff565656)
                    : Color(0xff565656)),
          ),
          child: isPreview
              ? GestureDetector(
                  onTap: widget.readOnly
                      ? null
                      : () {
                          setState(() {
                            _previewText = null;
                          });
                        },
                  child: MouseRegion(
                    cursor: widget.readOnly ? SystemMouseCursors.basic : SystemMouseCursors.text,
                    child: MdPreview(
                      text: _previewText ?? '',
                      padding: EdgeInsets.only(left: 15),
                      onTapLink: H.launchURL,
                      onCodeCopied: () {
                        Notificator.success(
                          context,
                          title: LocaleKeys.info_code_copied_titte.tr(),
                          description: LocaleKeys.info_code_copied_description.tr(),
                        );
                      },
                      widgetImage: (imageUrl) => CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                )
              : MdEditor(
                  initText: widget.initText,
                  hintText: LocaleKeys.md_editor_init_text.tr(),
                  textFocusNode: _focusNode,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  onComplete: (content) {
                    if (content == widget.initText)
                      setState(() {
                        _previewText = content;
                      });
                    else
                      widget.onComplete(content);
                  },
                  actionMessages: {
                    ActionType.done: LocaleKeys.md_editor_done.tr(),
                    ActionType.undo: LocaleKeys.md_editor_undo.tr(),
                    ActionType.redo: LocaleKeys.md_editor_redo.tr(),
                    ActionType.image: LocaleKeys.md_editor_image.tr(),
                    ActionType.link: LocaleKeys.md_editor_link.tr(),
                    ActionType.fontBold: LocaleKeys.md_editor_font_bold.tr(),
                    ActionType.fontItalic: LocaleKeys.md_editor_font_italic.tr(),
                    ActionType.fontStrikethrough: LocaleKeys.md_editor_font_strikethrough.tr(),
                    ActionType.textQuote: LocaleKeys.md_editor_text_quote.tr(),
                    ActionType.list: LocaleKeys.md_editor_list.tr(),
                    ActionType.h1: LocaleKeys.md_editor_h1.tr(),
                    ActionType.h2: LocaleKeys.md_editor_h2.tr(),
                    ActionType.h3: LocaleKeys.md_editor_h3.tr(),
                    ActionType.h4: LocaleKeys.md_editor_h4.tr(),
                    ActionType.h5: LocaleKeys.md_editor_h5.tr(),
                  },
                ),
        );
      }),
    );
  }
}
