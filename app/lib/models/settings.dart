import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:flutter/material.dart';

export 'package:flutter/material.dart' show Color;

@ProviderModel()
class Settings {
  @ProviderModelProp()
  bool? isDarkMode;

  @ProviderModelProp()
  Color? activeColor;

  Color get currentActiveColor => activeColor ?? const Color(0xff0069cc);
}
