import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';

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
