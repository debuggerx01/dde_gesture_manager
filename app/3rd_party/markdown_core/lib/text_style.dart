import 'package:flutter/material.dart';

const List<String> kTextTags = const <String>[
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'code',
  'strong',
  'em',
  'del',
  'a',
];

const List<String> kTextParentTags = const <String>[
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'li',
];

TextStyle defaultTextStyle(BuildContext context) => TextStyle(
      fontSize: 18,
      height: 1.8,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffaaaaaa)
          : const Color(0xff444444),
    );

TextStyle defaultTagTextStyle(String lastTag, String tag, TextStyle textStyle) {
  switch (tag) {
    case 'h1':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 9,
      );
      break;
    case 'h2':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 6,
      );
      break;
    case 'h3':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 4,
      );
      break;
    case 'h4':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 3,
      );
      break;
    case 'h5':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 2,
      );
      break;
    case 'h6':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) + 1,
      );
      break;
    case 'p':
      break;
    case 'li':
      break;
    case 'code':
      textStyle = textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 0) - 3,
        color: textStyle.color?.withAlpha(200),
      );
      if (lastTag == 'p') {
        textStyle = textStyle.copyWith(
          color: Colors.red.shade800,
        );
      }

      break;
    case 'strong':
      textStyle = textStyle.copyWith(
        fontWeight: FontWeight.bold,
      );
      break;
    case 'em':
      textStyle = textStyle.copyWith(
        fontStyle: FontStyle.italic,
      );
      break;
    case 'del':
      textStyle = textStyle.copyWith(
        decoration: TextDecoration.lineThrough,
      );
      break;
    case 'a':
      textStyle = textStyle.copyWith(
        color: Colors.blue,
      );
      break;
  }
  return textStyle;
}
