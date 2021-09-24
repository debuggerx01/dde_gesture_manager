import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/widgets/language_switcher.dart';
import 'package:dde_gesture_manager/widgets/theme_switcher.dart';
import 'package:dde_gesture_manager/widgets/version_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.t.backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VersionChecker(),
            Row(
              children: [
                LanguageSwitcher(),
                Container(width: 6),
                ThemeSwitcher(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
