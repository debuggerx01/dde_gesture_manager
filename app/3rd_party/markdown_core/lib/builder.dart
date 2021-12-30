import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_core/text_style.dart';

/// 递归解析标签
/// [_elementList] 每个标签依次放入该集合
/// 在[visitElementBefore]时添加
/// 在[visitElementAfter]时将其移除

class MarkdownBuilder implements md.NodeVisitor {
  MarkdownBuilder(
    this.context,
    this.linkTap,
    this.widgetImage,
    this.maxWidth,
    this.defaultTextStyle, {
    this.tagTextStyle = defaultTagTextStyle,
    required this.onCodeCopied,
  });

  final _widgets = <Widget>[];
  // int _level = 0;
  List<_Element> _elementList = <_Element>[];

  final TextStyle defaultTextStyle;
  final TagTextStyle tagTextStyle;

  final BuildContext context;
  final LinkTap linkTap;
  final WidgetImage widgetImage;
  final double maxWidth;
  final Function onCodeCopied;

  @override
  bool visitElementBefore(md.Element element) {
    // _level++;
    // debugPrint('visitElementBefore $_level ${element.textContent}');

    String lastTag = '';
    if (_elementList.isNotEmpty) {
      lastTag = _elementList.last.tag;
    }

    var textStyle = tagTextStyle(
      lastTag,
      element.tag,
      _elementList.isNotEmpty ? _elementList.last.textStyle : defaultTextStyle,
    );

    _elementList.add(_Element(
      element.tag,
      textStyle,
      element.attributes,
    ));

    return true;
  }

  @override
  void visitText(md.Text text) {
    // debugPrint('text ${text.text}');

    if (_elementList.isEmpty) return;
    var last = _elementList.last;
    last.textSpans ??= [];

    // 替换特定字符串
    var content = text.text.replaceAll('&gt;', '>');
    content = content.replaceAll('&lt;', '<');

    if (last.tag == 'a') {
      last.textSpans?.add(TextSpan(
        text: content,
        style: last.textStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            debugPrint(last.attributes.toString());
            linkTap(last.attributes['href'] ?? '');
          },
      ));
      return;
    }

    last.textSpans?.add(TextSpan(
      text: content,
      style: last.textStyle,
    ));
  }

  final padding = const EdgeInsets.fromLTRB(0, 5, 0, 5);

  String getTextFromElement(dynamic element) {
    String result = '';
    if (element is List) {
      result = element.map(getTextFromElement).join('\n');
    } else if (element is md.Element) {
      result = result = element.children?.map(getTextFromElement).join('\n') ?? '';
    } else {
      result = element.text;
    }
    return result;
  }

  @override
  void visitElementAfter(md.Element element) {
    // debugPrint('visitElementAfter $_level ${element.tag}');
    // _level--;

    if (_elementList.isEmpty) return;
    var last = _elementList.last;
    _elementList.removeLast();
    var tempWidget;
    if (kTextTags.indexOf(element.tag) != -1) {
      if (_elementList.isNotEmpty && kTextParentTags.indexOf(_elementList.last.tag) != -1) {
        // 内联标签处理
        _elementList.last.textSpans ??= [];
        _elementList.last.textSpans?.addAll(last.textSpans ?? []);
      } else {
        if (last.textSpans?.isNotEmpty ?? false) {
          tempWidget = SelectableText.rich(
            TextSpan(
              children: last.textSpans,
              style: last.textStyle,
            ),
          );
        }
      }
    } else if ('li' == element.tag) {
      tempWidget = _resolveToLi(last);
    } else if ('pre' == element.tag) {
      var preCode = HtmlUnescape().convert(getTextFromElement(element.children));
      tempWidget = _resolveToPre(last, preCode);
    } else if ('blockquote' == element.tag) {
      tempWidget = _resolveToBlockquote(last);
    } else if ('img' == element.tag) {
      if (_elementList.isNotEmpty && (_elementList.last.textSpans?.isNotEmpty ?? false)) {
        _widgets.add(
          Padding(
            padding: padding,
            child: RichText(
              text: TextSpan(
                children: _elementList.last.textSpans,
                style: _elementList.last.textStyle,
              ),
            ),
          ),
        );
        _elementList.last.textSpans = null;
      }
      // debugPrint(element.attributes.toString());
      //_elementList.clear();
      _widgets.add(
        Padding(
          padding: padding,
          child: widgetImage(element.attributes['src'] ?? ''),
        ),
      );
    } else if (last.widgets?.isNotEmpty ?? false) {
      if (last.widgets?.length == 1) {
        tempWidget = last.widgets?[0];
      } else {
        tempWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: last.widgets ?? [],
        );
      }
    }

    if (tempWidget != null) {
      if (_elementList.isEmpty) {
        _widgets.add(
          Padding(
            padding: padding,
            child: tempWidget,
          ),
        );
      } else {
        _elementList.last.widgets ??= [];
        if (tempWidget is List<Widget>) {
          _elementList.last.widgets?.addAll(tempWidget);
        } else {
          _elementList.last.widgets?.add(tempWidget);
        }
      }
    }
  }

  List<Widget> build(List<md.Node> nodes) {
    _widgets.clear();

    for (md.Node node in nodes) {
      // _level = 0;
      _elementList.clear();

      node.accept(this);
    }
    return _widgets;
  }

  dynamic _resolveToLi(_Element last) {
    int liNum = 1;
    _elementList.forEach((element) {
      if (element.tag == 'li') liNum++;
    });
    List<Widget> widgets = last.widgets ?? [];
    List<InlineSpan> spans = [];
    spans.addAll(last.textSpans ?? []);
    widgets.insert(
        0,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                8,
                ((last.textStyle.fontSize ?? 0) * 2 - 10) / 2.2,
                8,
                0,
              ),
              child: Icon(
                Icons.circle,
                size: 10,
                color: last.textStyle.color,
              ),
            ),
            Container(
              width: maxWidth - (26 * liNum),
              child: RichText(
                strutStyle: StrutStyle(
                  height: 1,
                  fontSize: last.textStyle.fontSize,
                  forceStrutHeight: true,
                  leading: 1,
                ),
                // textAlign: TextAlign.center,
                text: TextSpan(
                  children: spans,
                  style: last.textStyle,
                ),
              ),
            )
          ],
        ));

    /// 如果是顶层，返回column
    if (liNum == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      );
    } else {
      return widgets;
    }
  }

  Widget _resolveToPre(_Element last, String preCode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xff111111) : const Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: last.widgets ?? [],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.copy_outlined),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: preCode)).then((_) {
                    onCodeCopied();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resolveToBlockquote(_Element last) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: double.infinity,
            color: Colors.grey.shade400,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: last.widgets ?? [],
            ),
          ),
        ],
      ),
    );
  }
}

class _Element {
  _Element(
    this.tag,
    this.textStyle,
    this.attributes,
  );

  final String tag;
  List<Widget>? widgets;
  List<TextSpan>? textSpans;
  TextStyle textStyle;
  Map<String, String> attributes;
}

/// 链接点击
typedef void LinkTap(String link);

typedef Widget WidgetImage(String imageUrl);

typedef TextStyle TagTextStyle(String lastTag, String tag, TextStyle textStyle);
