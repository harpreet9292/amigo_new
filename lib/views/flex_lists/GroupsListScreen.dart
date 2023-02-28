import 'package:flutter/material.dart';

import 'package:amigotools/views/flex_lists/DbItemsListBase.dart';
import 'package:amigotools/view_models/flex_lists/GroupsListModel.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/view_models/flex_forms/GroupModel.dart';
import 'package:amigotools/views/flex_forms/FlexItemViewerScreen.dart';

class GroupsListScreen extends DbItemsListBase<GroupsListModel> {
  static const routeName = "/groups";

  const GroupsListScreen({selectionMode = false})
    : super(selectionMode: selectionMode);

  GroupsListModel createListModel() => GroupsListModel();

  Widget getDetailsScreen(int id)
    => FlexItemViewerScreen(GroupModel.open(id));

  MainDrawerKeys? get selectedItemKey => MainDrawerKeys.GroupsScreen;
}
