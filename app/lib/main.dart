import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/generated/locale_keys.g.dart';
import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/themes/dark.dart';
import 'package:dde_gesture_manager/themes/light.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/init.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        H().sp.updateInt(SPKeys.brightnessMode, brightnessMode?.index ?? 0);
        late bool showDarkMode;
        if (brightnessMode == BrightnessMode.system) {
          showDarkMode = isDarkMode ?? false;
        } else {
          showDarkMode = brightnessMode == BrightnessMode.dark;
        }
        return MaterialApp(
          title: CodegenLoader.mapLocales[context.locale.toString()]?[LocaleKeys.app_name],
          theme: showDarkMode ? darkTheme : lightTheme,
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
