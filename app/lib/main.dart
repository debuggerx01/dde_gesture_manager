import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/themes/dark.dart';
import 'package:dde_gesture_manager/themes/light.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/init.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.logger.enableLevels = [];
  await EasyLocalization.ensureInitialized();
  await initConfigs();
  runApp(EasyLocalization(
    supportedLocales: supportedLocales,
    fallbackLocale: zh_CN,
    path: 'resources/langs',
    assetLoader: CodegenLoader(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ConfigsProvider()),
      ],
      builder: (context, child) {
        var isDarkMode = context.watch<SettingsProvider>().isDarkMode;
        var brightnessMode = context.watch<ConfigsProvider>().brightnessMode;
        var activeColor = context.watch<SettingsProvider>().currentActiveColor;
        H().sp.updateInt(SPKeys.brightnessMode, brightnessMode?.index ?? 0);
        late bool showDarkMode;
        if (brightnessMode == BrightnessMode.system) {
          showDarkMode = isDarkMode ?? false;
        } else {
          showDarkMode = brightnessMode == BrightnessMode.dark;
        }
        return MaterialApp(
          title: CodegenLoader.mapLocales[context.locale.toString()]?[LocaleKeys.app_name],
          theme: (showDarkMode ? darkTheme : lightTheme).copyWith(
            highlightColor: activeColor,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          home: AnimatedCrossFade(
            crossFadeState: isDarkMode != null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            alignment: Alignment.center,
            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(key: bottomChildKey, child: bottomChild),
                Positioned(key: topChildKey, child: topChild),
              ],
            ),
            firstChild: Builder(builder: (context) {
              Future.microtask(() {
                initEvents(context);
                if (H().lastCheckAuthStatusTime != null &&
                    H().lastCheckAuthStatusTime!.difference(DateTime.now()) < Duration(minutes: 10)) return;
                if (context.read<ConfigsProvider>().accessToken.notNull) {
                  Api.checkAuthStatus().then((value) {
                    if (!value) context.read<ConfigsProvider>().setProps(email: '', accessToken: '');
                  });
                } else {
                  H().lastCheckAuthStatusTime = DateTime.now();
                }
              });
              return Container();
            }),
            secondChild: HomePage(),
            duration: longDuration,
          ),
        );
      },
    );
  }
}
