import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:flutter/material.dart';
export 'apply_scheme_web.dart' if (dart.library.io) 'apply_scheme_linux.dart';

abstract class SchemeApplyUtilStub {
  void apply(BuildContext context, Scheme scheme);
}
