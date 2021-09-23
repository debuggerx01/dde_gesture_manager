import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
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
    return Container(
      color: context.t.backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            PopupMenuButton(
              initialValue: context.watch<ConfigsProvider>().brightnessMode,
              child: Icon(Icons.brightness_4_outlined),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<BrightnessMode>(
                  child: Text(LocaleKeys.theme_label).tr(),
                  onTap: () => context.read<ConfigsProvider>().setProps(brightnessMode: BrightnessMode.system),
                ),
                PopupMenuItem<BrightnessMode>(
                  child: Text(LocaleKeys.theme_light).tr(),
                  onTap: () => context.read<ConfigsProvider>().setProps(brightnessMode: BrightnessMode.light),
                ),
                PopupMenuItem<BrightnessMode>(
                  child: Text(LocaleKeys.theme_dark).tr(),
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
