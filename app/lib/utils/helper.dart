import 'package:shared_preferences/shared_preferences.dart';

class H {
  H._();

  static final _h = H._();

  factory H() => _h;

  late SharedPreferences _sp;

  SharedPreferences get sp => _sp;

  initSharedPreference() async {
    _sp = await SharedPreferences.getInstance();
  }
}
