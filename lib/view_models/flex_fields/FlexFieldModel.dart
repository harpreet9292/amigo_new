import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/config/views/FlexItemEditorScreenConfig.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';

class FlexFieldModel extends ChangeNotifier
{
  final FlexField _flexField;

  dynamic _value;
  String _friendlyValue = "";
  String? _errorMessage;
  bool _allowErrorMessage = false;

  FlexFieldModel(FlexField flexField, dynamic value)
      : _flexField = flexField
  {
    _initProperties();
    initInternal(value);
    _validateValue();
    prepareFriendlyValueAndNotifyListenersInternal();
  }

  late final FlexFieldWidgetModel widget;
  late final FlexFieldInputTypeModel inputType;

  String get ident => _flexField.ident;
  String get label => _flexField.label;
  bool get required => _flexField.required;
  String? get hint => _flexField.hint;
  double? get min => _flexField.min;
  double? get max => _flexField.max;
  bool get enabled => !_flexField.readonly;

  dynamic get value => _value;
  set value(dynamic val)
  {
    if (_value != val)
    {
      _value = val;
      _validateValue();
      prepareFriendlyValueAndNotifyListenersInternal();
    }
  }

  String get friendlyValue => _friendlyValue;

  bool get hasNotEmptyValue => _value != null && (!(_value is String) || _value.isNotEmpty);

  bool get isValidValue => _errorMessage == null;

  String? get displayErrorMessage => _allowErrorMessage ? _errorMessage : null;

  bool get allowErrorMessage => _allowErrorMessage;
  set allowErrorMessage(bool val)
  {
    if (_allowErrorMessage != val)
    {
      _allowErrorMessage = val;
      notifyListeners();
    }
  }

  void onBoundToItemModel(FlexItemModelBase itemModel, bool editMode) {}

  @protected
  void initInternal(dynamic value)
  {
    _value = value ?? _flexField.initial;
  }

  @protected
  void prepareFriendlyValueAndNotifyListenersInternal() async
  {
    _friendlyValue = hasNotEmptyValue ? _value.toString() : "";
    notifyListeners();
  }

  void _validateValue()
  {
    if (!hasNotEmptyValue)
    {
      _errorMessage = required ? "" : null;
    }
    else if (widget == FlexFieldWidgetModel.Checkbox && required)
    {
      final bolval = _value as bool;
      _errorMessage = !bolval ? "" : null;
    }
    else if (inputType == FlexFieldInputTypeModel.Number)
    {
      if (_value == null)
      {
        _errorMessage = "123..";
      }
      else if (_value is num)
      {
        final numval = _value as num;

        if ((min != null && numval < min!) || (max != null && numval > max!))
        {
          _errorMessage = "$min - $max";
        }
        else
        {
          _errorMessage = null;
        }
      }
      else
      {
        // todo: log
      }
    }
    else if (min != null && _value!.toString().length < min!)
    {
      _errorMessage = "Min ${min!.toInt()}";
    }
    else if (max != null && _value!.toString().length.toDouble() > max!)
    {
      _errorMessage = "Max ${max!.toInt()}";
    }
    else
    {
      _errorMessage = null;
    }
  }

  void _initProperties()
  {
    var locInputType = FlexFieldInputTypeModel.Default;

    switch (_flexField.type)
    {
      case FlexFieldType.Unknown:
        widget = FlexFieldWidgetModel.Undefined;
        // TODO: to logs
        break;

      case FlexFieldType.String:
        widget = FlexFieldWidgetModel.Input;
        if (max != null && max! >= FlexItemEditorScreenConfig.MinimumMaxValueForMultipleInputText)
          locInputType = FlexFieldInputTypeModel.MultilineText;
        else if (_flexField.inputType == FlexFieldInputType.address)
          locInputType = FlexFieldInputTypeModel.Address;
        else if (_flexField.inputType == FlexFieldInputType.region)
          locInputType = FlexFieldInputTypeModel.Region;
        else if (_flexField.inputType == FlexFieldInputType.postcode)
          locInputType = FlexFieldInputTypeModel.Postcode;
        else if (_flexField.inputType == FlexFieldInputType.phone || _flexField.inputType == FlexFieldInputType.tel)
          locInputType = FlexFieldInputTypeModel.Telephone;
        break;

      case FlexFieldType.Number:
        widget = FlexFieldWidgetModel.Input;
        locInputType = FlexFieldInputTypeModel.Number;
        break;

      case FlexFieldType.Selection:
        widget = FlexFieldWidgetModel.Dropdown;
        if (_flexField.multiple)
          locInputType = FlexFieldInputTypeModel.MultipleChoice;
        break;

      case FlexFieldType.Checkbox:
        widget = FlexFieldWidgetModel.Checkbox;
        break;

      case FlexFieldType.DateTime:
        widget = FlexFieldWidgetModel.DateTime;
        
        var typeStr = enumValueToString(_flexField.inputType)?.toLowerCase();

        locInputType = FlexFieldInputTypeModel.values.firstWhere(
          (x) => enumValueToString(x)!.toLowerCase() == typeStr,
          orElse: () => FlexFieldInputTypeModel.Default);
        break;

      case FlexFieldType.Label:
        widget = FlexFieldWidgetModel.Label;
        break;

      case FlexFieldType.Category:
      case FlexFieldType.FieldSet:
        widget = label.isNotEmpty ? FlexFieldWidgetModel.Divider : FlexFieldWidgetModel.Undefined;
        break;

      case FlexFieldType.Collection:
        widget = FlexFieldWidgetModel.ItemSelector;
        //if (_flexField.multiple)
        //  locInputType = FlexFieldInputTypeModel.MultipleChoice;
        break;

      case FlexFieldType.User:
        widget = FlexFieldWidgetModel.Dropdown;
        //if (_flexField.multiple)
        //  locInputType = FlexFieldInputTypeModel.MultipleChoice;
        break;

      case FlexFieldType.Images:
        widget = FlexFieldWidgetModel.Images;
        break;

      case FlexFieldType.Materials:
        widget = FlexFieldWidgetModel.Materials;
        break;

      case FlexFieldType.PlaceId:
        widget = FlexFieldWidgetModel.PlaceId;
        if (_flexField.multiple)
          locInputType = FlexFieldInputTypeModel.MultipleChoice;
        break;

      case FlexFieldType.Object:
        widget = FlexFieldWidgetModel.ItemSelector;
        break;

      case FlexFieldType.Group:
        widget = FlexFieldWidgetModel.ItemSelector;
        break;

      case FlexFieldType.GeoPosition:
        widget = FlexFieldWidgetModel.GeoPosition;
        break;
    }

    inputType = locInputType;
  }
}

enum FlexFieldWidgetModel
{
  Undefined,
  Input,
  Dropdown,
  Checkbox,
  DateTime,
  Label,
  Divider,

  ItemSelector,
  Images,
  Materials,
  PlaceId,
  GeoPosition,
}

enum FlexFieldInputTypeModel
{
  Default,
  MultilineText,
  Number,
  Time,
  Date,
  MultipleChoice,

  Address,
  Region, // does not have a button but used for Address
  Postcode, // does not have a button but used for Address
  Telephone,
}

class FlexFieldDropdownItemModel
{
  final Object key;
  final String? headline1;
  final String? headline2;
  final bool inactive;

  const FlexFieldDropdownItemModel(this.key, {this.headline1, this.headline2, this.inactive = false});
}