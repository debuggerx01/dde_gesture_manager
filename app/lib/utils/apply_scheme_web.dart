import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'apply_scheme_interface.dart';
import 'package:flutter/services.dart';

class SchemeApplyUtil implements SchemeApplyUtilStub {
  void apply(BuildContext context, Scheme scheme) {
    var cmd = scheme.id == Uuid.NAMESPACE_NIL
        ? [
            'rm \$XDG_CONFIG_HOME/${userGestureConfigFilePath}',
          ]
        : [
            'cat > \$XDG_CONFIG_HOME/${userGestureConfigFilePath} << EOF',
            '${H.transGesturePropsToConfig(scheme.gestures ?? [])}',
            'EOF',
          ];
    cmd.add('dialog'
        ' --title "${LocaleKeys.info_apply_scheme_success.tr()}"'
        ' --yes-label "${LocaleKeys.info_apply_scheme_logout_immediately.tr()}"'
        ' --no-label "${LocaleKeys.str_cancel.tr()}"'
        ' --yesno "${LocaleKeys.info_apply_scheme_description.tr()}"'
        ' 8 30'
        ' && ${deepinLogoutCommands.join(' ')}');
    Clipboard.setData(ClipboardData(
      text: cmd.join('\n'),
    ));
    Notificator.success(
      context,
      title: LocaleKeys.info_apply_scheme_commands_copied_title.tr(),
      description: LocaleKeys.info_apply_scheme_commands_copied_description.tr(),
    );
  }
}
