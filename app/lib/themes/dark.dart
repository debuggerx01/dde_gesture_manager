import 'package:flutter/material.dart';

var darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.grey,
  scaffoldBackgroundColor: Color(0xff252525),
  backgroundColor: Color(0xff282828),
  iconTheme: IconThemeData(
    color: Color(0xffc0c6d4),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xffc0c6d4),
        ),
        bodyText2: TextStyle(
          color: Color(0xffc0c6d4),
        ),
      ),
);
