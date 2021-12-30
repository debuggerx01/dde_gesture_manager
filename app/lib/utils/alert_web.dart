import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'alert_interface.dart';

import 'dart:html' as html;

class AlertImpl implements Alert {
  @override
  Future<CustomButton> showAlert({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
  }) {
    html.window.alert([windowTitle, text].join('\n'));
    return Future.value(CustomButton.positiveButton);
  }

  @override
  Future<CustomButton> showConfirm({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  }) {
    var confirmed = html.window.confirm([windowTitle, text].join('\n'));
    return Future.value(
      confirmed ? CustomButton.positiveButton : CustomButton.negativeButton,
    );
  }
}
