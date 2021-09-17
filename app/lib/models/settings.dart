import 'package:flutter/foundation.dart';

class Settings {
  bool? _isDarkMode;

  bool? get isDarkMode => _isDarkMode;
}

class SettingsProvider extends Settings with ChangeNotifier {
  void setProps({
    bool? isDarkMode,
  }) {
    bool changed = false;
    if (this._isDarkMode != isDarkMode) {
      this._isDarkMode = isDarkMode;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}
