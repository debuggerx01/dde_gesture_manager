import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:flutter/material.dart';

var lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Color(0xfff8f8f8),
  backgroundColor: Color(0xffffffff),
  iconTheme: IconThemeData(
    color: Color(0xff414d68),
  ),
  dividerColor: Color(0xfff3f3f3),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xff414d68),
        ),
        bodyText2: TextStyle(
          color: Color(0xff414d68),
        ),
      ),
  popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
      ),
  dialogBackgroundColor: Color(0xfffefefe),
  tooltipTheme: ThemeData.dark().tooltipTheme.copyWith(
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
