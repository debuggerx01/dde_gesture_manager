import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/constants/constants.dart';

var darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.grey,
  scaffoldBackgroundColor: Color(0xff252525),
  backgroundColor: Color(0xff282828),
  iconTheme: IconThemeData(
    color: Color(0xffc0c6d4),
  ),
  dividerColor: Color(0xfff3f3f3),
  textTheme: ThemeData.dark().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xffc0c6d4),
        ),
        bodyText2: TextStyle(
          color: Color(0xffc0c6d4),
        ),
      ),
  popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
    ),
  ),
  dialogBackgroundColor: Color(0xff202020),
);
