import 'package:flutter/material.dart';

enum SupportedLocale {
  zh_CN,
  en,
}

const zh_CN = Locale('zh', 'CN');
const en = Locale('en');

const supportedLocales = [
  zh_CN,
  en,
];

const supportedLocaleNames = {
  SupportedLocale.zh_CN: '简体中文',
  SupportedLocale.en: 'English',
};

Locale transformSupportedLocale(SupportedLocale supportedLocale) => supportedLocales[supportedLocale.index];

SupportedLocale? getSupportedLocale(Locale? locale) =>
    supportedLocales.contains(locale) ? SupportedLocale.values[supportedLocales.indexOf(locale!)] : null;
