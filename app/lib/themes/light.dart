import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: kIsWeb ? null : defaultFontFamily,
);

var lightTheme = _lightTheme.copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Color(0xfff8f8f8),
  backgroundColor: Color(0xffffffff),
  iconTheme: IconThemeData(
    color: Color(0xff414d68),
  ),
  dividerColor: Colors.grey.shade600,
  textTheme: _lightTheme.textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xff414d68),
          fontFamilyFallback: kIsWeb ? null : [defaultFontFamily],
        ),
        bodyText2: TextStyle(
          color: Color(0xff414d68),
          fontFamilyFallback: kIsWeb ? null : [defaultFontFamily],
        ),
      ),
  popupMenuTheme: _lightTheme.popupMenuTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
      ),
  dialogBackgroundColor: Color(0xfffefefe),
  tooltipTheme: _lightTheme.tooltipTheme.copyWith(
        textStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xfff8f8f8).withOpacity(.9),
          border: Border.all(color: Colors.grey.shade400),
        ),
      ),
);
