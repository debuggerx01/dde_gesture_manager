import 'dart:io';

import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:uuid/uuid.dart';
import 'apply_scheme_interface.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:path/path.dart' show join;

class SchemeApplyUtil implements SchemeApplyUtilStub {
  void apply(BuildContext context, Scheme scheme) {
    var configFilePath = join(xdg.configHome.path, userGestureConfigFilePath);
    configFilePath.sout();
    var file = File(configFilePath);
    if (scheme.id == Uuid.NAMESPACE_NIL) {
      if (file.existsSync()) file.deleteSync();
    } else {
      if (!file.existsSync()) file.createSync(recursive: true);
      file.writeAsStringSync(
        H.transGesturePropsToConfig(scheme.gestures ?? []),
        flush: true,
      );
      Notificator.showConfirm(
        title: LocaleKeys.info_apply_scheme_success.tr(),
        description: LocaleKeys.info_apply_scheme_description.tr(),
        positiveButtonTitle: LocaleKeys.info_apply_scheme_logout_immediately.tr(),
        negativeButtonTitle: LocaleKeys.str_cancel.tr(),
      ).then((value) {
        if (value == CustomButton.positiveButton) {
          Process.run(deepinLogoutCommands.first, deepinLogoutCommands.skip(1).toList());
        }
      });
    }
  }
}
