import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtenstion on SharedPreferences {
  Future<bool> updateInt(String key, int value) {
    if (this.getInt(key) == value) return Future.value(false);
    return this.setInt(key, value);
  }

  Future<bool> updateDouble(String key, double value) {
    if (this.getDouble(key) == value) return Future.value(false);
    return this.setDouble(key, value);
  }

  Future<bool> updateString(String key, String value) {
    if (this.getString(key) == value) return Future.value(false);
    return this.setString(key, value);
  }
}
