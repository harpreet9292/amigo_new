import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class DropdownFieldModel extends FlexFieldModel
{
  final FlexField _flexField;

  List<FlexFieldDropdownItemModel> _choices = List.unmodifiable([]);
  List<String> _multiValues = [];

  DropdownFieldModel(FlexField flexField, dynamic value)
    : _flexField = flexField, super(flexField, value);

  @override @protected
  void initInternal(dynamic val) async
  {
    super.initInternal(val);

    _fillMultiValuesWithParsedValue();

    if (_flexField.values != null)
    {
      // removing dups in set with saved order
      final set = LinkedHashSet<String>.from(_flexField.values!.map((x) => x.trim()));
      final list = set.map((x) => FlexFieldDropdownItemModel(x)).toList();

      for (final mval in multiValues)
      {
        if (!set.contains(mval))
        {
          list.add(FlexFieldDropdownItemModel(value.trim(), inactive: true));
        }
      }

      _choices = List.unmodifiable(list);
    }

    notifyListeners(); // because of async and _selectedVals changed
  }

  List<FlexFieldDropdownItemModel> get choices => _choices;

  List<String> get multiValues => _multiValues;

  set multiValues(List<String> vals)
  {
    _multiValues = vals;
    value = vals.join('\n'); // notifies listeners
  }

  void _fillMultiValuesWithParsedValue()
  {
    _multiValues = hasNotEmptyValue ? value.toString().split('\n') : [];
  }
}