import 'package:flutter/foundation.dart';

class Settings {
  Settings({
    this.isDarkMode,
  });

  bool? isDarkMode;
}

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings();

  Settings get settings => _settings;

  set settings(Settings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void setProps({
    bool? isDarkMode,
  }) {
    bool changed = false;
    if (isDarkMode != _settings.isDarkMode) {
      _settings.isDarkMode = isDarkMode;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}
