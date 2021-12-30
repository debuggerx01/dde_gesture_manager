import 'alert_interface.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

class AlertImpl implements Alert {
  @override
  Future<CustomButton> showAlert({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
  }) =>
      FlutterPlatformAlert.showCustomAlert(
        windowTitle: windowTitle,
        text: text,
        positiveButtonTitle: positiveButtonTitle,
      );

  @override
  Future<CustomButton> showConfirm({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  }) =>
      FlutterPlatformAlert.showCustomAlert(
        windowTitle: windowTitle,
        text: text,
        positiveButtonTitle: positiveButtonTitle,
        negativeButtonTitle: negativeButtonTitle,
      );
}
