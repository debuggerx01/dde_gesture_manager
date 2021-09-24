import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/locale_keys.g.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:window_manager/window_manager.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _locale = EasyLocalization.of(context)?.currentLocale;
    var _supportedLocale = supportedLocales.firstWhereOrNull((element) => element == _locale);

    return PopupMenuButton<SupportedLocale>(
      child: Row(
        children: [
          Icon(Icons.language_outlined, size: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(LocaleKeys.language_label).tr(),
          ),
        ],
      ),
      itemBuilder: (BuildContext context) => supportedLocales
          .map(
            (locale) => PopupMenuItem(
              value: SupportedLocale.zh_CN,
              child: ListTile(
                leading: Visibility(
                  child: Icon(CupertinoIcons.check_mark),
                  visible: _supportedLocale == locale,
                ),
                title: Text(supportedLocaleNames[SupportedLocale.values[supportedLocales.indexOf(locale)]] ?? ''),
              ),
              onTap: () {
                EasyLocalization.of(context)?.setLocale(locale).then((_) {
                  if (!kIsWeb) WindowManager.instance.setTitle(LocaleKeys.app_name.tr());
                });
                H().sp.setInt(SPKeys.userLanguage, supportedLocales.indexOf(locale));
              },
            ),
          )
          .toList(),
    );
  }
}
