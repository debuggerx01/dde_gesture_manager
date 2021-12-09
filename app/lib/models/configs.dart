import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
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
  String? appliedSchemeId;

  Configs() {
    this.brightnessMode =
        BrightnessMode.values[H().sp.getInt(SPKeys.brightnessMode)?.clamp(0, BrightnessMode.values.length - 1) ?? 0];
    this.appliedSchemeId = H().sp.getString(SPKeys.appliedSchemeId);
  }
}
