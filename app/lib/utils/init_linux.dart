import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:gsettings/gsettings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';

Future<void> initEvents(BuildContext context) async {
  var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  if (isDark) {
    context.read<SettingsProvider>().setProps(isDarkMode: isDark);
  } else {
    var xsettings = GSettings('com.deepin.xsettings');
    String? themeName;
    try {
      themeName = (await xsettings.get('theme-name')).toString();
    } catch (e) {
      print(e);
      context.read<SettingsProvider>().setProps(isDarkMode: false);
    }

    if (themeName != null) {
      context.read<SettingsProvider>().setProps(isDarkMode: themeName.contains('dark'));
      xsettings.keysChanged.listen((event) {
        xsettings.get('theme-name').then((value) {
          context.read<SettingsProvider>().setProps(isDarkMode: value.toString().contains('dark'));
        });
      });
    }
  }
}

Future<void> initConfigs() async {
  await H().initSharedPreference();
  var windowManager = WindowManager.instance;
  windowManager.setTitle('Gesture Manager For DDE');
  windowManager.setMinimumSize(const Size(800, 600));
}
