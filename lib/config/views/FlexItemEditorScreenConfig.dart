import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class FlexItemEditorScreenConfig
{
  static const BarItems = const [
    UiItem(FlexItemEditorScreenKeys.Send, "Send", icon: Icons.send, fav: true),
    UiItem(FlexItemEditorScreenKeys.Delete, "Delete", icon: Icons.delete),
  ];

  static const MaterialsEditorBarItems = const [
    UiItem(FlexItemEditorScreenKeys.NewMaterial, "New", icon: Icons.add, fav: true),
  ];

  static const MinimumMaxValueForMultipleInputText = 200;
}

enum FlexItemEditorScreenKeys
{
  Send,
  Delete,
  NewMaterial,
}