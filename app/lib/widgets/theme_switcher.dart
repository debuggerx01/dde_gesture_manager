import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/locale_keys.g.dart';
import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _brightnessMode = context.watch<ConfigsProvider>().brightnessMode;
    return PopupMenuButton(
      initialValue: _brightnessMode,
      child: Row(
        children: [
          Icon(Icons.palette_outlined, size: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(LocaleKeys.theme_label).tr(),
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      tooltip: LocaleKeys.theme_tip.tr(),
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
    );
  }
}
