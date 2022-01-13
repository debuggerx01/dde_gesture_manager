import 'package:dde_gesture_manager/builder/provider_annotation.dart';

@ProviderModel()
class SchemeListRefreshKey {
  @ProviderModelProp(nullable: false)
  int refreshKey;

  SchemeListRefreshKey() : refreshKey = DateTime.now().millisecondsSinceEpoch;
}
