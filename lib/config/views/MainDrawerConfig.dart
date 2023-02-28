import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

abstract class MainDrawerConfig {
  static const Items = const <UiItem<MainDrawerKeys>>[
    UiItem(MainDrawerKeys.ProcessHeadline, "Process", subitems: const [
      //UiItem(MainDrawerKeys.MainScreen, "Main", icon: Icons.grid_view_outlined),
      UiItem(MainDrawerKeys.RoutinesScreen, "Tasks", icon: Icons.checklist_outlined),
      UiItem(MainDrawerKeys.OrdersScreen, "Orders", icon: Icons.ballot_outlined),
      //UiItem(MainDrawerKeys.StartScreen, "Start", icon: Icons.flag_outlined),
      //UiItem(MainDrawerKeys.EquipmentScreen, "Equipment", icon: Icons.construction_outlined),
    ]),
    UiItem(MainDrawerKeys.VisitsHeadline, "Object visits", subitems: null),
    UiItem(MainDrawerKeys.ReferencesHeadline, "References", subitems: const [
      UiItem(MainDrawerKeys.GroupsScreen, "Groups", icon: Icons.grid_view),
      UiItem(MainDrawerKeys.ObjectsScreen, "Objects",
          icon: Icons.apps_outlined),
    ]),
    UiItem(MainDrawerKeys.OutcomesHeadline, "Outcomes", subitems: null),
    UiItem(MainDrawerKeys.RestHeadline, "Rest", subitems: const [
      //UiItem(MainDrawerKeys.SettingsScreen, "Settings", icon: Icons.settings_outlined),
      UiItem(MainDrawerKeys.AboutScreen, "About us",
          icon: Icons.folder_shared_outlined),
      UiItem(MainDrawerKeys.Logout, "Logout", icon: Icons.logout_outlined),
      UiItem(MainDrawerKeys.Quit, "Quit", icon: Icons.exit_to_app_outlined),
    ]),
  ];

  static const NewOutcomeButton =
      UiItem(MainDrawerKeys.NewOutcomeButton, "New outcome", icon: Icons.add);
}

enum MainDrawerKeys {
  ProcessHeadline,
  MainScreen,
  RoutinesScreen,
  OrdersScreen,
  EquipmentScreen,

  VisitsHeadline,

  ReferencesHeadline,
  GroupsScreen,
  ObjectsScreen,

  OutcomesHeadline,

  RestHeadline,
  SettingsScreen,
  AboutScreen,
  Logout,
  Quit,

  NewOutcomeButton,
}
