import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/generated/locale_keys.g.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:gsettings/gsettings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

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
  var userLanguageIndex = H().sp.getInt(SPKeys.userLanguage) ?? 0;
  var locale = supportedLocales[userLanguageIndex];
  windowManager.setTitle(CodegenLoader.mapLocales[locale.toString()]?[LocaleKeys.app_name]);
  windowManager.setMinimumSize(const Size(800, 600));
}

var windowManager = WindowManager.instance;
