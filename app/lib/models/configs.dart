import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/utils/helper.dart';

enum BrightnessMode {
  system,
  light,
  dark,
}

@ProviderModel()
class Configs {
  @ProviderModelProp()
  BrightnessMode? brightnessMode;

  @ProviderModelProp()
  String? get appliedSchemeId => _appliedSchemeId;

  set appliedSchemeId(String? schemeId) {
    _appliedSchemeId = schemeId;
    if (schemeId.notNull)
      H().sp.updateString(SPKeys.appliedSchemeId, schemeId!);
    else
      H().sp.remove(SPKeys.appliedSchemeId);
  }

  String? _appliedSchemeId;

  @ProviderModelProp()
  String? get accessToken => _accessToken;

  set accessToken(String? token) {
    _accessToken = token;
    if (token.notNull)
      H().sp.updateString(SPKeys.accessToken, token!);
    else
      H().sp.remove(SPKeys.accessToken);
  }

  String? _accessToken;

  @ProviderModelProp()
  String? get email => _email;

  set email(String? emailAddress) {
    _email = emailAddress;
    if (emailAddress.notNull)
      H().sp.updateString(SPKeys.loginEmail, emailAddress!);
    else
      H().sp.remove(SPKeys.loginEmail);
  }

  String? _email;

  Configs() {
    this.brightnessMode =
        BrightnessMode.values[H().sp.getInt(SPKeys.brightnessMode)?.clamp(0, BrightnessMode.values.length - 1) ?? 0];
    this.appliedSchemeId = H().sp.getString(SPKeys.appliedSchemeId);
    this.accessToken = H().sp.getString(SPKeys.accessToken);
    this.email = H().sp.getString(SPKeys.loginEmail);
  }
}
