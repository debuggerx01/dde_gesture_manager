import 'package:flutter/material.dart';

var lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Color(0xfff8f8f8),
  backgroundColor: Color(0xffffffff),
  iconTheme: IconThemeData(
    color: Color(0xff414d68),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xff414d68),
        ),
        bodyText2: TextStyle(
          color: Color(0xff414d68),
        ),
      ),
);
