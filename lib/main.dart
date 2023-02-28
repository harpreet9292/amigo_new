import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/services/background/main_background.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/views/general/App.dart';
import 'package:amigotools/view_models/general/AppStateModel.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';

void main() async {
  // call it first, even before services initialization
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // do not call it with EasyLocalization: initializeDateFormatting();

  if (!await FlutterBackgroundService.initialize(mainBackground, autoStart: false)) {
    exit(-1);
  }

  await setupServiceLocator(backgroundChannel: false);

  runApp(
    EasyLocalization(
      supportedLocales: GeneralConfig.SupportedLocales,
      path: GeneralConfig.TranslationsPath,
      fallbackLocale: GeneralConfig.SupportedLocales.first,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateModel()),
          ChangeNotifierProvider(create: (_) => SettingsModel()),
        ],
        child: const App(),
      ),
    ),
  );
}
