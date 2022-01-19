import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/pages/local_manager.dart';
import 'package:dde_gesture_manager_api/src/models/scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

extension EnumByName<T extends Enum> on Iterable<T> {
  T? findByName(String name) {
    for (var value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

class H {
  H._();

  static final _h = H._();

  factory H() => _h;

  late SharedPreferences _sp;

  SharedPreferences get sp => _sp;

  initSharedPreference() async {
    _sp = await SharedPreferences.getInstance();
  }

  late BuildContext _topContext;

  BuildContext get topContext => _topContext;

  DateTime? lastCheckAuthStatusTime;

  static final localManagerKey = GlobalKey<LocalManagerState>();

  initTopContext(BuildContext context) {
    _topContext = context;
  }

  static void openPanel(BuildContext context, PanelType panelType) {
    var windowWidth = MediaQuery.of(context).size.width;
    if (windowWidth < minWindowSize.width + localManagerPanelWidth + marketOrMePanelWidth) {
      context.read<ContentLayoutProvider>().setProps(
            localManagerOpened: panelType == PanelType.local_manager,
            marketOrMeOpened: panelType == PanelType.market_or_me,
          );
    } else {
      switch (panelType) {
        case PanelType.local_manager:
          return context.read<ContentLayoutProvider>().setProps(localManagerOpened: true);
        case PanelType.market_or_me:
          return context.read<ContentLayoutProvider>().setProps(marketOrMeOpened: true);
      }
    }
  }

  static PreferredPanelsStatus getPreferredPanelsStatus(double windowWidth) {
    var preferredPanelsStatus = PreferredPanelsStatus(localManagerPanelOpened: true, marketOrMePanelOpened: true);
    if (windowWidth > minWindowSize.width + localManagerPanelWidth + marketOrMePanelWidth)
      return preferredPanelsStatus;
    else if (windowWidth < minWindowSize.width + localManagerPanelWidth)
      return preferredPanelsStatus
        ..marketOrMePanelOpened = false
        ..localManagerPanelOpened = false;
    else
      return preferredPanelsStatus..marketOrMePanelOpened = false;
  }

  static Gesture getGestureByName(String gestureName) => Gesture.values.findByName(gestureName) ?? Gesture.swipe;

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

  static GestureType getGestureTypeByName(String typeName) =>
      GestureType.values.findByName(typeName) ?? GestureType.built_in;

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

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void handleDownloadScheme(BuildContext context, SchemeForDownload value) =>
      localManagerKey.currentState?.addLocalScheme(context, value);
}

class PreferredPanelsStatus {
  bool localManagerPanelOpened;
  bool marketOrMePanelOpened;

  PreferredPanelsStatus({
    required this.localManagerPanelOpened,
    required this.marketOrMePanelOpened,
  });

  @override
  String toString() {
    return 'PreferredPanelsStatus{localManagerPanelOpened: $localManagerPanelOpened, marketOrMePanelOpened: $marketOrMePanelOpened}';
  }
}
