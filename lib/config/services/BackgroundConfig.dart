import 'dart:collection';

import 'package:amigotools/services/background/controllers/CommandsController.dart';
import 'package:amigotools/services/background/controllers/EventsController.dart';
import 'package:amigotools/services/background/controllers/FlexCustItemsController.dart';
import 'package:amigotools/services/background/controllers/FlexOutcomesController.dart';
import 'package:amigotools/services/background/controllers/MaterialsController.dart';
import 'package:amigotools/services/background/controllers/RoutineTasksController.dart';
import 'package:amigotools/services/background/controllers/RoutinesController.dart';
import 'package:amigotools/services/background/controllers/SettingsController.dart';
import 'package:amigotools/services/background/controllers/FlexEntitiesController.dart';
import 'package:amigotools/services/background/controllers/FlexGroupsController.dart';
import 'package:amigotools/services/background/controllers/FlexObjectsController.dart';
import 'package:amigotools/services/background/controllers/FlexOrdersController.dart';
import 'package:amigotools/services/background/controllers/UsersController.dart';
import 'package:amigotools/services/background/controllers/SysTasksController.dart';

abstract class BackgroundConfig
{
  static const ActionEventName = "action";

  static const PeriodicRequestServerUpdateSec = 10;
  static const PingUiChannelSec = 2;
  static const CheckBackgroundSec = 7;

  static final controllers = UnmodifiableListView([
    () => CommandsController(),
    () => SettingsController(),
    () => FlexEntitiesController(),
    () => FlexGroupsController(),
    () => FlexObjectsController(),
    () => FlexOrdersController(),
    () => FlexOutcomesController(),
    () => FlexCustItemsController(),
    () => UsersController(),
    () => MaterialsController(),
    () => RoutinesController(),
    () => RoutineTasksController(),
    () => SysTasksController(),
    () => EventsController(),
    //() => PeriodicPositionsController(),
  ]);
}

abstract class BackgroundActions
{
  static const UiPing = "UiPing";
  static const UiPong = "UiPong";
  static const ForceServerState = "ForceServerState";
  static const StopBackground = "StopBackground";
  static const ReloadSettings = "ReloadSettings";
}