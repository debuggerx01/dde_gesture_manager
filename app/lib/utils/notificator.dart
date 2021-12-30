import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'alert_interface.dart';

class Notificator {
  static Future<CustomButton> showAlert({
    required String title,
    required String description,
    String? positiveButtonTitle,
  }) {
    return AlertImpl().showAlert(
      windowTitle: title,
      text: description,
      positiveButtonTitle: positiveButtonTitle,
    );
  }

  static Future<CustomButton> showConfirm({
    required String title,
    required String description,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  }) {
    return AlertImpl().showConfirm(
      windowTitle: title,
      text: description,
      positiveButtonTitle: positiveButtonTitle ?? LocaleKeys.str_yes.tr(),
      negativeButtonTitle: negativeButtonTitle ?? LocaleKeys.str_no.tr(),
    );
  }

  static _setToastIconBackgroundColor(CherryToast toast, bool isDarkMode) {
    var hslColor = HSLColor.fromColor(toast.themeColor);
    toast.themeColor = hslColor.withLightness((hslColor.lightness + (isDarkMode ? 0.4 : 0.1)).clamp(0, 1)).toColor();
  }

  static CherryToast info(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    var themeData = Theme.of(context);
    var toast = CherryToast.info(
      title: title,
      description: description,
      autoDismiss: true,
      animationType: ANIMATION_TYPE.FROM_TOP,
      animationDuration: Duration(milliseconds: 300),
      toastDuration: Duration(seconds: 3),
      backgroundColor: themeData.backgroundColor,
      titleStyle: themeData.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
      descriptionStyle: themeData.textTheme.bodyText1!,
    );
    _setToastIconBackgroundColor(toast, themeData.brightness == Brightness.dark);
    toast.show(context);
    return toast;
  }

  static CherryToast warning(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    var themeData = Theme.of(context);
    var toast = CherryToast.warning(
      title: title,
      description: description,
      autoDismiss: true,
      animationType: ANIMATION_TYPE.FROM_TOP,
      animationDuration: Duration(milliseconds: 300),
      toastDuration: Duration(seconds: 3),
      backgroundColor: themeData.backgroundColor,
      titleStyle: themeData.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
      descriptionStyle: themeData.textTheme.bodyText1!,
    );
    _setToastIconBackgroundColor(toast, themeData.brightness == Brightness.dark);
    toast.show(context);
    return toast;
  }

  static CherryToast error(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    var themeData = Theme.of(context);
    var toast = CherryToast.error(
      title: title,
      description: description,
      autoDismiss: true,
      animationType: ANIMATION_TYPE.FROM_TOP,
      animationDuration: Duration(milliseconds: 300),
      toastDuration: Duration(seconds: 3),
      backgroundColor: themeData.backgroundColor,
      titleStyle: themeData.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
      descriptionStyle: themeData.textTheme.bodyText1!,
    );
    _setToastIconBackgroundColor(toast, themeData.brightness == Brightness.dark);
    toast.show(context);
    return toast;
  }

  static CherryToast success(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    var themeData = Theme.of(context);
    var toast = CherryToast.success(
      title: title,
      description: description,
      autoDismiss: true,
      animationType: ANIMATION_TYPE.FROM_TOP,
      animationDuration: Duration(milliseconds: 300),
      toastDuration: Duration(seconds: 3),
      backgroundColor: themeData.backgroundColor,
      titleStyle: themeData.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
      descriptionStyle: themeData.textTheme.bodyText1!,
    );
    _setToastIconBackgroundColor(toast, themeData.brightness == Brightness.dark);
    toast.show(context);
    return toast;
  }
}
