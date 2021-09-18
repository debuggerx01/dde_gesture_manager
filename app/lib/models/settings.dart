import 'package:dde_gesture_manager/builder/provider_annotation.dart';

@ProviderModel()
class Settings {
  @ProviderModelProp()
  bool? isDarkMode;

  @ProviderModelProp()
  String? name;
}
