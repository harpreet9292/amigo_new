import 'package:flutter/material.dart';

import 'package:amigotools/views/flex_lists/DbItemsListBase.dart';
import 'package:amigotools/view_models/flex_lists/ObjectsListModel.dart';
import 'package:amigotools/views/flex_forms/ObjectViewerScreen.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/view_models/flex_forms/ObjectModel.dart';

class ObjectsListScreen extends DbItemsListBase<ObjectsListModel> {
  static const routeName = "/objects";

  final int? groupId;

  const ObjectsListScreen({selectionMode = false, this.groupId})
      : super(selectionMode: selectionMode);

  ObjectsListModel createListModel() => ObjectsListModel(groupId: groupId);

  Widget getDetailsScreen(int id) => ObjectViewerScreen(ObjectModel.open(id));

  MainDrawerKeys? get selectedItemKey => MainDrawerKeys.ObjectsScreen;
}
