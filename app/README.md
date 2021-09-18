# DDE Gesture Manager
专为 DDE 桌面环境打造的触摸板手势管理工具

## ProviderGenerator
利用 [source_gen](https://pub.dev/packages/source_gen) 和 [build_runner](https://pub.flutter-io.cn/packages/build_runner) 生成 [provider](https://pub.flutter-io.cn/packages/provider) 的模板代码：
1. 在 `lib/models/` 下编写模型类
```dart
import 'package:dde_gesture_manager/builder/provider_annotation.dart';

@ProviderModel()
class Test {
  @ProviderModelProp()
  bool? tested;

  @ProviderModelProp()
  String? name;
}

```

2. `app` 项目目录下执行 `flutter packages pub run build_runner build`

3. 将在 `lib/models/test.provider.dart` 生成如下代码:
```dart
import 'package:flutter/foundation.dart';
import 'package:dde_gesture_manager/extensions/compare_extension.dart';
import 'test.dart';

class TestProvider extends Test with ChangeNotifier {
  void setProps({
    bool? tested,
    String? name,
  }) {
    bool changed = false;
    if (tested.diff(this.tested)) {
      this.tested = tested;
      changed = true;
    }
    if (name.diff(this.name)) {
      this.name = name;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}

```
