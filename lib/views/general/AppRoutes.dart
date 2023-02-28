import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/views/flex_forms/FlexItemEditorScreen.dart';
import 'package:amigotools/view_models/general/AppStateModel.dart';
import 'package:amigotools/views/screens/MainScreen.dart';
import 'package:amigotools/views/flex_lists/OrdersListScreen.dart';
import 'package:amigotools/views/flex_lists/GroupsListScreen.dart';
import 'package:amigotools/views/flex_lists/ObjectsListScreen.dart';
import 'package:amigotools/views/screens/ObjectVisitScreen.dart';
import 'package:amigotools/views/account/PinPadScreen.dart';
import 'package:amigotools/views/account/SystemLoginScreen.dart';
import 'package:amigotools/views/screens/WaitingScreen.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitModel.dart';
import 'package:amigotools/views/routines/RoutineTasksScreen.dart';

class AppRoutes {
// #region Route constants

  static const root = "/";
  static const blank = "/_blank";

  static const main = MainScreen.routeName;
  static const routines = RoutineTasksScreen.routeName;
  static const orders = OrdersListScreen.routeName;
  static const groups = GroupsListScreen.routeName;
  static const objects = ObjectsListScreen.routeName;

  static const editoutcome = FlexItemEditorScreen.routeName;
  static const objectvisit = ObjectVisitScreen.routeName;
  static const pinpad = PinPadScreen.routeName;

// #endregion

  static const _availableRootRoutes = const [
    Pair(routines, SettingsKeys.MenuRoutines),
    Pair(orders, SettingsKeys.MenuOrders),
    Pair(groups, SettingsKeys.MenuGroups),
    Pair(objects, SettingsKeys.MenuObjects),
  ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      final widget = _selectWidgetForAppState(context);
      if (widget != null) {
        return widget;
      }

      var routeName = settings.name;

      if (routeName == root) {
        routeName = _selectRouteForRoot();
      }

      return _selectWidgetForRoute(routeName, settings);
    });
  }

  static Widget? _selectWidgetForAppState(BuildContext context) {
    final appstate = context.read<AppStateModel>();

    switch (appstate.generalState) {
      case GeneralState.AppStarting:
      case GeneralState.DataLoading:
        return WaitingScreen();

      case GeneralState.RequestSysLogin:
        return SystemLoginScreen();

      case GeneralState.RequestPin:
        return PinPadScreen();

      case GeneralState.Quiting:
        return WaitingScreen();

      case GeneralState.Normal:
        // nothing
        break;
    }

    return null;
  }

  static String _selectRouteForRoot() {
    final _settings = $locator.get<SettingsProvider>();

    for (final item in _availableRootRoutes) {
      if (_settings.get<bool>(item.item2)) {
        return item.item1;
      }
    }

    return blank;
  }

  static Widget _selectWidgetForRoute(
      String? routeName, RouteSettings settings) {
    switch (routeName) {
      case main:
        return MainScreen();

      case routines:
        return RoutineTasksScreen();

      case orders:
        return OrdersListScreen();

      case groups:
        return GroupsListScreen();

      case objects:
        return ObjectsListScreen();

      case objectvisit:
        final model = settings.arguments as ObjectVisitModel;
        return ObjectVisitScreen(model);

      case editoutcome:
        final itemModel = settings.arguments as FlexItemModelBase;
        return FlexItemEditorScreen(itemModel);

      case pinpad:
        return PinPadScreen();

      case blank:
        return Scaffold(
          appBar: AppBar(title: Container()),
          drawer: MainDrawer(),
          body: Container(),
        );

      default:
        return Scaffold(
          appBar: AppBar(title: Container()),
          drawer: MainDrawer(),
          body: Center(child: Text('No route defined for ${settings.name}')),
        );
    }
  }
}
