import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/constants/supported_locales.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/generated/codegen_loader.g.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _locale = EasyLocalization.of(context)?.currentLocale;
    var _supportedLocale = getSupportedLocale(_locale) ?? SupportedLocale.zh_CN;

    return PopupMenuButton<SupportedLocale>(
      tooltip: LocaleKeys.language_tip.tr(),
      child: Row(
        children: [
          Icon(Icons.language_outlined, size: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(LocaleKeys.language_label).tr(),
          ),
        ],
      ),
      initialValue: _supportedLocale,
      onSelected: (value) {
        EasyLocalization.of(context)?.setLocale(transformSupportedLocale(value)).then((_) {
          var localeMap = Translations(CodegenLoader.mapLocales[context.locale.toString()]!);
          if (!kIsWeb) WindowManager.instance.setTitle(localeMap.get(LocaleKeys.app_name)!);
          var localSchemesProvider = context.read<LocalSchemesProvider>();
          var schemes = localSchemesProvider.schemes!;
          var newSchemes = [
            schemes.first
              ..scheme.name = localeMap.get(LocaleKeys.local_manager_default_scheme_label)
              ..scheme.description = localeMap.get(LocaleKeys.local_manager_default_scheme_description),
            ...schemes.skip(1),
          ];
          localSchemesProvider.setProps(schemes: newSchemes);
        });
        H().sp.setInt(SPKeys.userLanguage, value.index);
      },
      itemBuilder: (BuildContext context) => SupportedLocale.values
          .map(
            (supportedLocale) => CheckedPopupMenuItem(
              value: supportedLocale,
              checked: EasyLocalization.of(context)?.locale == transformSupportedLocale(supportedLocale),
              child: Text(supportedLocaleNames[supportedLocale] ?? ''),
            ),
          )
          .toList(),
    );
  }
}
