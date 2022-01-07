import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:gsettings/gsettings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

bool _updateChecked = false;

Future<void> initEvents(BuildContext context) async {
  H().initTopContext(context);
  var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  if (isDark) {
    context.read<SettingsProvider>().setProps(isDarkMode: isDark);
  } else {
    var xsettings = GSettings('com.deepin.xsettings');
    String? themeName;
    Color? activeColor;
    try {
      themeName = (await xsettings.get('theme-name')).toString();
      var _activeColor = (await xsettings.get('qt-active-color'));
      activeColor = H.parseQtActiveColor(_activeColor.toNative());
    } catch (e) {
      print(e);
      context.read<SettingsProvider>().setProps(isDarkMode: false);
    }

    if (themeName != null) {
      context.read<SettingsProvider>().setProps(isDarkMode: themeName.contains('dark'));
      context.read<SettingsProvider>().setProps(activeColor: activeColor);
      xsettings.keysChanged.listen((event) {
        xsettings.get('theme-name').then((value) {
          context.read<SettingsProvider>().setProps(isDarkMode: value.toString().contains('dark'));
        });
        xsettings.get('qt-active-color').then((value) {
          context.read<SettingsProvider>().setProps(activeColor: H.parseQtActiveColor(value.toNative()));
        });
      });
    }
  }

  if (!_updateChecked) {
    _updateChecked = true;
    Api.checkAppVersion(ignoreErrorHandle: true).then((value) async {
      var info = await PackageInfo.fromPlatform();
      var _buildNumber = int.parse(info.buildNumber);
      var _newVersionCode = value?.versionCode ?? 0;
      var _ignoredVersionCode = H().sp.getInt(SPKeys.ignoredUpdateVersion) ?? 0;
      if (_buildNumber < _newVersionCode && _ignoredVersionCode < _newVersionCode) {
        Notificator.showConfirm(
          title: LocaleKeys.info_new_version_title.tr(namedArgs: {'version': '${value?.versionName}'}),
          description: LocaleKeys.info_new_version_description_for_startup.tr(namedArgs: {
            'yes': LocaleKeys.str_yes.tr(),
            'no': LocaleKeys.str_no.tr(),
          }),
        ).then((confirmed) async {
          if (confirmed == CustomButton.positiveButton) {
            if (await canLaunch(Apis.appNewVersionUrl)) {
              await launch(Apis.appNewVersionUrl);
            }
          } else if (confirmed == CustomButton.negativeButton) {
            H().sp.updateInt(SPKeys.ignoredUpdateVersion, value?.versionCode ?? 0);
          }
        });
      }
    });
  }
}

Future<void> initConfigs() async {
  await H().initSharedPreference();
  var userLanguageIndex = H().sp.getInt(SPKeys.userLanguage) ?? 0;
  var locale = supportedLocales[userLanguageIndex];
  windowManager.setTitle(CodegenLoader.mapLocales[locale.toString()]?[LocaleKeys.app_name]);
  windowManager.setMinimumSize(minWindowSize);
}

var windowManager = WindowManager.instance;
