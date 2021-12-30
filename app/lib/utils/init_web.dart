import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> initEvents(BuildContext context) async {
  H().initTopContext(context);
  var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  context.read<SettingsProvider>().setProps(isDarkMode: isDark);
}

Future<void> initConfigs() async {
  await H().initSharedPreference();
}
