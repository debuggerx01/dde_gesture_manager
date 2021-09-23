import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/themes/dark.dart';
import 'package:dde_gesture_manager/themes/light.dart';
import 'package:dde_gesture_manager/utils/init.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.logger.enableLevels = [];
  await EasyLocalization.ensureInitialized();
  await initConfigs();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('zh', 'CN'),
      Locale('en'),
    ],
    fallbackLocale: Locale('zh', 'CN'),
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
        late bool showDarkMode;
        if (brightnessMode == BrightnessMode.system) {
          showDarkMode = isDarkMode ?? false;
        } else {
          showDarkMode = brightnessMode == BrightnessMode.dark;
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: showDarkMode ? darkTheme : lightTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
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
              Future.microtask(() => initEvents(context));
              return Container();
            }),
            secondChild: HomePage(),
            duration: Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}
