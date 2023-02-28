import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

abstract class MainScreenConfig
{
  static const ScreenTitle = "Main";

  static const Tabs = const [
    UiItem(MainScreenKeys.RoundsTab, "Rounds"),
    UiItem(MainScreenKeys.OrdersTab, "Orders"),
    UiItem(MainScreenKeys.CurrentVisitTab, "Current"),
  ];

  static const BarItems = const [
    UiItem(MainScreenKeys.Chat, "Chat", icon: Icons.chat, fav: true),
    UiItem(MainScreenKeys.NewOutcome, "New outcame", icon: Icons.create),
    UiItem(MainScreenKeys.ScanBarcode, "Scan barcode", icon: Icons.scanner),
    UiItem(MainScreenKeys.TakePhoto, "Take photo", icon: Icons.photo_camera),
  ];
}

enum MainScreenKeys
{
  RoundsTab,
  OrdersTab,
  CurrentVisitTab,

  Chat,
  NewOutcome,
  ScanBarcode,
  TakePhoto,
}