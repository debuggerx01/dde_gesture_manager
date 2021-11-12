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
    return PopupMenuButton<BrightnessMode>(
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
      onSelected: (value) => context.read<ConfigsProvider>().setProps(brightnessMode: value),
      tooltip: LocaleKeys.theme_tip.tr(),
      itemBuilder: (BuildContext context) => [
        CheckedPopupMenuItem<BrightnessMode>(
          child: Text(LocaleKeys.theme_system).tr(),
          checked: _brightnessMode == BrightnessMode.system,
          value: BrightnessMode.system,
        ),
        CheckedPopupMenuItem<BrightnessMode>(
          child: Text(LocaleKeys.theme_light).tr(),
          checked: _brightnessMode == BrightnessMode.light,
          value: BrightnessMode.light,
        ),
        CheckedPopupMenuItem<BrightnessMode>(
          child: Text(LocaleKeys.theme_dark).tr(),
          checked: _brightnessMode == BrightnessMode.dark,
          value: BrightnessMode.dark,
        ),
      ],
    );
  }
}
