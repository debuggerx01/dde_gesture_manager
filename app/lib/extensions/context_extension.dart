import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';

extension ContextExtension on BuildContext {
  ThemeData get t => Theme.of(this);

  NavigatorState get n => Navigator.of(this);

  bool get hasToken => this.read<ConfigsProvider>().accessToken.notNull;

  bool get watchHasToken => this.watch<ConfigsProvider>().accessToken.notNull;
}
