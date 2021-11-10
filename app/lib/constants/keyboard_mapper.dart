import 'package:flutter/services.dart';

/// https://github.com/linuxdeepin/dde-daemon/blob/76be73fbf019cee73983292e1edf47611ed9a219/gesture/manager.go#L386
final Map<LogicalKeyboardKey, String> keyMapper = {
  LogicalKeyboardKey.control: 'ctrl',
  LogicalKeyboardKey.controlLeft: 'ctrl',
  LogicalKeyboardKey.controlRight: 'ctrl',
  LogicalKeyboardKey.shift: 'shift',
  LogicalKeyboardKey.shiftLeft: 'shift',
  LogicalKeyboardKey.shiftRight: 'shift',
};
