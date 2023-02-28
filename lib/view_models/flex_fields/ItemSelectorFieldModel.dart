import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/FlexGroupsStorage.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/view_models/flex_forms/GroupModel.dart';
import 'package:amigotools/view_models/flex_forms/ObjectModel.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/services/storage/FlexCustItemsStorage.dart';
import 'package:amigotools/view_models/flex_forms/CustItemModel.dart';

class ItemSelectorFieldModel extends FlexFieldModel
{
  final FlexField _flexField;

  String _friendlyValue = "";
  ItemSelectorFieldModel? _dependencyFieldModel;
  dynamic _dependencyFieldModelLastValue;

  late final ItemSelectorFieldTypeModel itemType;

  ItemSelectorFieldModel(FlexField flexField, dynamic value)
    : _flexField = flexField, super(flexField, value);

  String? get relatedEntityIdent => _flexField.param;

  dynamic get dependencyFieldValue => _dependencyFieldModel?.value;

  @override
  String get friendlyValue => _friendlyValue;

  @override @protected
  void initInternal(dynamic val)
  {
    super.initInternal(val);

    switch (_flexField.type)
    {
      case FlexFieldType.Object:
        itemType = ItemSelectorFieldTypeModel.Object;
        break;

      case FlexFieldType.Group:
        itemType = ItemSelectorFieldTypeModel.Group;
        break;

      case FlexFieldType.Collection:
        itemType = ItemSelectorFieldTypeModel.CustItem;
        break;

      default:
        throw UnimplementedError();
    }
  }

  @override @protected
  void prepareFriendlyValueAndNotifyListenersInternal() async
  {
    if (hasNotEmptyValue)
    {
      switch (itemType)
      {
        case ItemSelectorFieldTypeModel.Object:
          final objectsStorage = $locator.get<FlexObjectsStorage>();
          final items = await objectsStorage.fetchBrief(ids: [value as int]);
          _friendlyValue = items.isNotEmpty ? items.first.title : "";
          break;

        case ItemSelectorFieldTypeModel.Group:
          final groupsStorage = $locator.get<FlexGroupsStorage>();
          final items = await groupsStorage.fetchBrief(ids: [value as int]);
          _friendlyValue = items.isNotEmpty ? items.first.title : "";
          break;

        case ItemSelectorFieldTypeModel.CustItem:
          final custitemsStorage = $locator.get<FlexCustItemsStorage>();
          final items = await custitemsStorage.fetchBrief(ids: [int.parse(value)]); // value is string because form xml
          _friendlyValue = items.isNotEmpty ? items.first.title : "";
          break;

        default:
          throw UnimplementedError();
      }
    }
    else
    {
      _friendlyValue = "";
    }

    notifyListeners();
  }

  @override
  void onBoundToItemModel(FlexItemModelBase itemModel, bool editMode)
  {
    if (itemModel.editMode && itemType == ItemSelectorFieldTypeModel.Object)
    {
      if (_dependencyFieldModel != null)
        _dependencyFieldModel!.removeListener(_onDependencyFieldChanged);

      for (var field in itemModel.fields)
      {
        if (field is ItemSelectorFieldModel && field.itemType == ItemSelectorFieldTypeModel.Group)
        {
          field.addListener(_onDependencyFieldChanged);
          _dependencyFieldModel = field;
          _dependencyFieldModelLastValue = field.value;
          return;
        }
      }
    }
  }

  Future<FlexItemModelBase?> getSelectedFlexItemModel() async
  {
    if (value == null) return null;

    switch (itemType)
    {
      case ItemSelectorFieldTypeModel.Object:
        return ObjectModel.open(value);

      case ItemSelectorFieldTypeModel.Group:
        return GroupModel.open(value);

      case ItemSelectorFieldTypeModel.CustItem:
        return CustItemModel.open(int.parse(value)); // value is string because form xml

      default:
        throw UnimplementedError();
    }
  }

  void _onDependencyFieldChanged()
  {
    if (_dependencyFieldModelLastValue != _dependencyFieldModel!.value)
    {
      value = null;
    }
  }
}

enum ItemSelectorFieldTypeModel
{
  Group,
  Object,
  CustItem,
}