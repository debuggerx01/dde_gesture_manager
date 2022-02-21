import 'package:flutter/material.dart';
import 'package:markdown_core/builder.dart';
import 'package:markdown_core/markdown.dart';

class MdPreview extends StatefulWidget {
  MdPreview({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.onTapLink,
    required this.widgetImage,
    required this.onCodeCopied,
    this.textStyle,
    this.richTap,
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;
  final WidgetImage widgetImage;
  final TextStyle? textStyle;

  final Function onCodeCopied;

  /// Call this method when it tap link of markdown.
  /// If [onTapLink] is null,it will open the link with your default browser.
  final TapLinkCallback? onTapLink;

  final VoidCallback? richTap;

  @override
  State<StatefulWidget> createState() => MdPreviewState();
}

class MdPreviewState extends State<MdPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: widget.padding,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Markdown(
              data: widget.text,
              maxWidth: constraints.maxWidth,
              linkTap: (link) {
                debugPrint(link);
                if (widget.onTapLink != null) {
                  widget.onTapLink!(link);
                }
              },
              image: widget.widgetImage,
              textStyle: widget.textStyle,
              onCodeCopied: widget.onCodeCopied,
              richTap: widget.richTap,
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

typedef void TapLinkCallback(String link);
