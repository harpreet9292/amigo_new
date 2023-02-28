import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/UsersStorage.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/view_models/flex_fields/DropdownFieldModel.dart';

class UserFieldModel extends DropdownFieldModel
{
  final _storage = $locator.get<UsersStorage>();
  final FlexField _flexField;

  List<FlexFieldDropdownItemModel> _choices = [];
  String _friendlyValue = "";

  UserFieldModel(FlexField flexField, dynamic value)
    : _flexField = flexField, super(flexField, value);

  @override
  List<FlexFieldDropdownItemModel> get choices => _choices;

  @override
  String get friendlyValue => _friendlyValue;

  @override @protected
  void prepareFriendlyValueAndNotifyListenersInternal()
  {
    if (hasNotEmptyValue)
    {
      for (final choice in _choices)
      {
        if (choice.key == value)
        {
          _friendlyValue = choice.headline1 ?? "#${choice.key}";
          
          notifyListeners();
          return;
        }
      }
    }

    _friendlyValue = "";

    notifyListeners();
  }

  @override
  void onBoundToItemModel(FlexItemModelBase itemModel, bool editMode) async
  {
    final id = !editMode && value is int ? value : null;
    final role = editMode && _flexField.param != null && _flexField.param!.isNotEmpty ? _flexField.param : null;

    _choices = (await _storage.fetch(id: id, role: role))
      .map((x) => FlexFieldDropdownItemModel(x.id, headline1: x.name))
      .toList();

    prepareFriendlyValueAndNotifyListenersInternal();
  }
}