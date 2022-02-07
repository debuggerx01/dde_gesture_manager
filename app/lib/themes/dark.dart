import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: kIsWeb ? null : defaultFontFamily,
);

var darkTheme = _darkTheme.copyWith(
  primaryColor: Colors.grey,
  scaffoldBackgroundColor: Color(0xff252525),
  backgroundColor: Color(0xff282828),
  iconTheme: IconThemeData(
    color: Color(0xffc0c6d4),
  ),
  dividerColor: Color(0xfff3f3f3),
  textTheme: _darkTheme.textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xffc0c6d4),
          fontFamilyFallback: kIsWeb ? null : [defaultFontFamily],
        ),
        bodyText2: TextStyle(
          color: Color(0xffc0c6d4),
          fontFamilyFallback: kIsWeb ? null : [defaultFontFamily],
        ),
      ),
  popupMenuTheme: _darkTheme.popupMenuTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
      ),
  dialogBackgroundColor: Color(0xff202020),
  tooltipTheme: _darkTheme.tooltipTheme.copyWith(
        textStyle: TextStyle(
          color: Colors.grey,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xff282828).withOpacity(.9),
          border: Border.all(color: Colors.black38),
        ),
      ),
);
