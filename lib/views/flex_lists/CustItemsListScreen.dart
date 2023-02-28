import 'package:flutter/material.dart';

import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/view_models/flex_lists/CustItemsListModel.dart';
import 'package:amigotools/views/flex_lists/DbItemsListBase.dart';
import 'package:amigotools/view_models/flex_forms/CustItemModel.dart';
import 'package:amigotools/views/flex_forms/FlexItemViewerScreen.dart';

class CustItemsListScreen extends DbItemsListBase<CustItemsListModel> {
  static const routeName = "/custitems";

  final String? entityIdent;

  const CustItemsListScreen({required this.entityIdent, selectionMode = false})
    : super(selectionMode: selectionMode);

  CustItemsListModel createListModel() => CustItemsListModel(entityIdent: entityIdent);

  Widget getDetailsScreen(int id) => FlexItemViewerScreen(CustItemModel.open(id));

  MainDrawerKeys? get selectedItemKey => null;
}
