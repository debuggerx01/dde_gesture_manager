import 'package:dde_gesture_manager/builder/provider_annotation.dart';

@ProviderModel()
class ContentLayout {
  @ProviderModelProp()
  bool? localManagerOpened;

  @ProviderModelProp()
  bool? marketOrMeOpened;

  @ProviderModelProp()
  bool? currentIsMarket = true;

  bool get isMarket => currentIsMarket ?? true;
}
