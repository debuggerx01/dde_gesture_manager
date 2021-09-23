import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    var _brightnessMode = context.watch<ConfigsProvider>().brightnessMode;
    return Container(
      color: context.t.backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),
            PopupMenuButton(
              initialValue: _brightnessMode,
              icon: Icon(Icons.brightness_4_outlined),
              tooltip: LocaleKeys.theme_label.tr(),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<BrightnessMode>(
                  child: ListTile(
                    leading: Visibility(
                      child: Icon(CupertinoIcons.check_mark),
                      visible: _brightnessMode == BrightnessMode.system,
                    ),
                    title: Text(LocaleKeys.theme_system).tr(),
                  ),
                  onTap: () => context.read<ConfigsProvider>().setProps(brightnessMode: BrightnessMode.system),
                ),
                PopupMenuItem<BrightnessMode>(
                  child: ListTile(
                      leading: Visibility(
                        child: Icon(CupertinoIcons.check_mark),
                        visible: _brightnessMode == BrightnessMode.light,
                      ),
                      title: Text(LocaleKeys.theme_light).tr()),
                  onTap: () => context.read<ConfigsProvider>().setProps(brightnessMode: BrightnessMode.light),
                ),
                PopupMenuItem<BrightnessMode>(
                  child: ListTile(
                      leading: Visibility(
                        child: Icon(CupertinoIcons.check_mark),
                        visible: _brightnessMode == BrightnessMode.dark,
                      ),
                      title: Text(LocaleKeys.theme_dark).tr()),
                  onTap: () => context.read<ConfigsProvider>().setProps(brightnessMode: BrightnessMode.dark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
