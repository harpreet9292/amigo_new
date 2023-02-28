import 'package:flutter/material.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/background/BackgroundApp.dart';

void mainBackground() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator(backgroundChannel: true);

  $locator.get<BackgroundApp>().run();
}