import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager/widgets/login.dart';
import 'package:dde_gesture_manager/widgets/me.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketOrMe extends StatelessWidget {
  const MarketOrMe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    bool isOpen = layoutProvider.marketOrMeOpened == true;
    bool isMarket = layoutProvider.isMarket;
    bool showLogin = context.watch<ConfigsProvider>().accessToken.isNull && !isMarket;
    return AnimatedContainer(
      duration: mediumDuration,
      curve: Curves.easeInOut,
      width: isOpen ? marketOrMePanelWidth * (showLogin ? 1.5 : 1) : 0,
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: marketOrMePanelWidth * (showLogin ? 1.5 : 1),
        minWidth: marketOrMePanelWidth * (showLogin ? 1.5 : 1),
        child: Material(
          color: context.t.backgroundColor,
          elevation: isOpen ? 10 : 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DButton(
                      width: defaultButtonHeight - 2,
                      height: defaultButtonHeight - 2,
                      onTap: () => context.read<ContentLayoutProvider>().setProps(marketOrMeOpened: !isOpen),
                      child: Icon(
                        CupertinoIcons.chevron_right_2,
                        size: 20,
                      ),
                    ),
                    Flexible(
                      child: Center(
                        child: Text(
                          isMarket ? LocaleKeys.market_title : LocaleKeys.me_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                    ),
                    DButton(
                      width: defaultButtonHeight - 2,
                      height: defaultButtonHeight - 2,
                      onTap: () => context.read<ContentLayoutProvider>().setProps(currentIsMarket: !isMarket),
                      child: Icon(
                        !isMarket ? CupertinoIcons.cart : CupertinoIcons.person,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                if (isMarket) buildMarketContent(context),
                if (!isMarket) buildMeContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMeContent(BuildContext context) {
    var accessToken = context.watch<ConfigsProvider>().accessToken;
    if (accessToken.isNull) return LoginWidget();
    return Expanded(child: MeWidget());
  }

  Widget buildMarketContent(BuildContext context) {
    return Container();
  }
}
