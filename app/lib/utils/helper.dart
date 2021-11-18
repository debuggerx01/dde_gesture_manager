import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class H {
  H._();

  static final _h = H._();

  factory H() => _h;

  late SharedPreferences _sp;

  SharedPreferences get sp => _sp;

  initSharedPreference() async {
    _sp = await SharedPreferences.getInstance();
  }

  static void openPanel(BuildContext context, PanelType panelType) {
    var windowWidth = MediaQuery.of(context).size.width;
    if (windowWidth < minWindowSize.width + localManagerPanelWidth + marketPanelWidth) {
      context.read<ContentLayoutProvider>().setProps(
            localManagerOpened: panelType == PanelType.local_manager,
            marketOpened: panelType == PanelType.market,
          );
    } else {
      switch (panelType) {
        case PanelType.local_manager:
          return context.read<ContentLayoutProvider>().setProps(localManagerOpened: true);
        case PanelType.market:
          return context.read<ContentLayoutProvider>().setProps(marketOpened: true);
      }
    }
  }

  static PreferredPanelsStatus getPreferredPanelsStatus(double windowWidth) {
    var preferredPanelsStatus = PreferredPanelsStatus(localManagerPanelOpened: true, marketPanelOpened: true);
    if (windowWidth > minWindowSize.width + localManagerPanelWidth + marketPanelWidth)
      return preferredPanelsStatus;
    else if (windowWidth < minWindowSize.width + localManagerPanelWidth)
      return preferredPanelsStatus
        ..marketPanelOpened = false
        ..localManagerPanelOpened = false;
    else
      return preferredPanelsStatus..marketPanelOpened = false;
  }

  static String? getGestureName(Gesture? gesture) => const {
        Gesture.swipe: 'swipe',
        Gesture.tap: 'tap',
        Gesture.pinch: 'pinch',
      }[gesture];

  static Gesture getGestureByName(String gestureName) =>
      const {
        'swipe': Gesture.swipe,
        'tap': Gesture.tap,
        'pinch': Gesture.pinch,
      }[gestureName] ??
      Gesture.swipe;

  static String? getGestureDirectionName(GestureDirection? direction) => const {
        GestureDirection.up: 'up',
        GestureDirection.down: 'down',
        GestureDirection.left: 'left',
        GestureDirection.right: 'right',
        GestureDirection.pinch_in: 'in',
        GestureDirection.pinch_out: 'out',
        GestureDirection.none: 'none',
      }[direction];

  static GestureDirection getGestureDirectionByName(String? directionName) =>
      const {
        'up': GestureDirection.up,
        'down': GestureDirection.down,
        'left': GestureDirection.left,
        'right': GestureDirection.right,
        'in': GestureDirection.pinch_in,
        'out': GestureDirection.pinch_out,
      }[directionName] ??
      GestureDirection.none;

  static String? getGestureTypeName(GestureType? type) => const {
        GestureType.built_in: 'built_in',
        GestureType.shortcut: 'shortcut',
        GestureType.commandline: 'commandline',
      }[type];

  static GestureType getGestureTypeByName(String typeName) =>
      const {
        'built_in': GestureType.built_in,
        'shortcut': GestureType.shortcut,
        'commandline': GestureType.commandline,
      }[typeName] ??
      GestureType.built_in;

  static Color? parseQtActiveColor(String? inp) {
    if (inp == null) return null;
    var list = inp.split(',');
    if (list.length != 4) return null;
    var rgba = list.map<int>((e) => int.parse(e) ~/ 257).toList();
    return Color.fromARGB(rgba[3], rgba[0], rgba[1], rgba[2]);
  }

  static GestureProp? getNextAvailableGestureProp(SchemeTree tree) {
    var gestureProp = GestureProp.empty()
      ..id = Uuid().v1()
      ..type = GestureType.built_in
      ..command = builtInCommands.first;
    if (tree.fullFiled) return null;
    gestureProp.fingers = tree.availableNode.fingers;
    gestureProp.gesture = tree.availableNode.availableNode.type;
    gestureProp.direction = tree.availableNode.availableNode.availableNode.direction;
    return gestureProp;
  }
}

class PreferredPanelsStatus {
  bool localManagerPanelOpened;
  bool marketPanelOpened;

  PreferredPanelsStatus({
    required this.localManagerPanelOpened,
    required this.marketPanelOpened,
  });

  @override
  String toString() {
    return 'PreferredPanelsStatus{localManagerPanelOpened: $localManagerPanelOpened, marketPanelOpened: $marketPanelOpened}';
  }
}
