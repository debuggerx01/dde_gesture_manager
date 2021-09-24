import 'package:dde_gesture_manager/builder/provider_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

Builder providerBuilder(BuilderOptions options) =>
    LibraryBuilder(ProviderGenerator(), generatedExtension: '.provider.dart');
