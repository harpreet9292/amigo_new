import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class ObjectsViewConfig {
  static const ItemViewBarItems = const [
    UiItem(ObjectsViewKeys.Workflows, "Workflows", icon: Icons.work_outline),
    UiItem(ObjectsViewKeys.NewOutcome, "New outcome", icon: Icons.add_outlined),
  ];
}

enum ObjectsViewKeys {
  Workflows,
  NewOutcome,
}
