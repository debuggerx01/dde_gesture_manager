import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension ContextExtension on BuildContext {
  ThemeData get t => Theme.of(this);

  NavigatorState get n => Navigator.of(this);
}
