import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class OrdersViewConfig
{
  static const ScreenTitle = "Orders";

  static const ItemViewBarItems = const [
    UiItem(OrdersViewKeys.TakeOrder, "Take order", icon: Icons.assignment_outlined),
    UiItem(OrdersViewKeys.RefuseOrder, "Refuse order", icon: Icons.cancel_presentation_outlined),
    UiItem(OrdersViewKeys.CloseOrder, "Close order", icon: Icons.do_disturb_on_outlined),
    UiItem(OrdersViewKeys.NewOutcome, "New outcome", icon: Icons.add_outlined),
    UiItem(OrdersViewKeys.EditOutcome, "Edit outcome", icon: Icons.edit_outlined),
  ];
}

enum OrdersViewKeys
{
  TakeOrder,
  RefuseOrder,
  CloseOrder,
  NewOutcome,
  EditOutcome,
}