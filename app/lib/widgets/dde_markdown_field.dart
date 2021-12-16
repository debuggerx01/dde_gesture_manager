import 'package:cached_network_image/cached_network_image.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_ot/markdown_editor.dart';
import 'package:url_launcher/url_launcher.dart';

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                    cursor: widget.readOnly ? SystemMouseCursors.basic : SystemMouseCursors.click,
                    child: MdPreview(
                      text: _previewText ?? '',
                      padding: EdgeInsets.only(left: 15),
                      onTapLink: _launchURL,
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
                ),
        );
      }),
    );
  }
}
