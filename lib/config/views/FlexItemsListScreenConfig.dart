import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class FlexItemsListScreenConfig
{
  static const BarItems = const [
    UiItem(FlexItemsListScreenKeys.Search, "Search", icon: Icons.search, fav: true),
  ];
}

enum FlexItemsListScreenKeys
{
  Search,
}