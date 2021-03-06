import 'package:flutter/cupertino.dart';

/// [UOS设计指南](https://docs.uniontech.com/zh/content/t_dbG3kBK9iDf9B963ok)
const double localManagerPanelWidth = 260;

const double marketOrMePanelWidth = 400;

const shortDuration = const Duration(milliseconds: 100);

const mediumDuration = const Duration(milliseconds: 300);

const longDuration = const Duration(milliseconds: 500);

const minWindowSize = const Size(800, 600);

const defaultWindowSize = const Size(1120, 720);

const double defaultBorderRadius = 8;

const double defaultButtonHeight = 36;

const userGestureConfigFilePath = 'deepin/dde-daemon/gesture.json';

const defaultFontFamily = 'NotoSansSC';

const deepinLogoutCommands = [
  'dbus-send',
  '--type=method_call',
  '--dest=com.deepin.SessionManager',
  '/com/deepin/SessionManager',
  'com.deepin.SessionManager.RequestLogout'
];

const List<String> builtInCommands = [
  'ShowWorkspace',
  'Handle4Or5FingersSwipeUp',
  'Handle4Or5FingersSwipeDown',
  'ToggleMaximize',
  'Minimize',
  'ShowWindow',
  'ShowAllWindow',
  'SwitchApplication',
  'ReverseSwitchApplication',
  'SwitchWorkspace',
  'ReverseSwitchWorkspace',
  'SplitWindowLeft',
  'SplitWindowRight',
  'MoveWindow',
];

enum PanelType {
  local_manager,
  market_or_me,
}

enum UploadRespStatus {
  done,
  name_occupied,
  error,
}
