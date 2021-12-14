export 'alert_web.dart' if (dart.library.io) 'alert_platform.dart';

import 'package:flutter_platform_alert/flutter_platform_alert.dart';

abstract class Alert {
  Future<CustomButton> showAlert({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
  });

  Future<CustomButton> showConfirm({
    required String windowTitle,
    required String text,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  });
}