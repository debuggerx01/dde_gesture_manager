import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/extensions.dart';

@ProviderModel()
class ContentLayout {
  @ProviderModelProp()
  bool? localManagerOpened;

  @ProviderModelProp()
  bool? marketOrMeOpened;

  @ProviderModelProp()
  bool? currentIsMarket = H().sp.getString(SPKeys.accessToken).isNull;

  bool get isMarket => currentIsMarket ?? true;
}
