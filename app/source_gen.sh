#!/usr/bin/env bash

flutter packages pub get
flutter pub run easy_localization:generate
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
flutter packages pub run build_runner build --delete-conflicting-outputs
