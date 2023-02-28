import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/nfc/NfcProvider.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class PlaceIdFieldModel extends FlexFieldModel
{
  final _provider = $locator.get<NfcProvider>();
  final FlexField _flexField;

  List<String> _multiValues = [];
  bool _enabled = true;

  @override
  bool get enabled => _enabled && !_flexField.readonly;

  PlaceIdFieldModel(FlexField flexField, dynamic value)
    : _flexField = flexField, super(flexField, value);

  @override
  void dispose()
  {
    _provider.removeHandler(_tagHandler);
    super.dispose();
  }

  @override @protected
  void initInternal(dynamic val) async
  {
    super.initInternal(val);

   _fillMultiValuesWithParsedValue();

    if (Platform.isAndroid)
    {
      _activate();
    }
  }

  List<String> get multiValues => _multiValues;

  void clear()
  {
    _multiValues = [];
    value = null;
  }

  void userRequest()
  {
    if (Platform.isIOS)
    {
      _deactivate();
      _activate();
    }
  }

  void _activate() async
  {
    if (!_flexField.readonly && await _provider.isServiceAvailable)
    {
      _provider.addHandler(_tagHandler);
    }
    else
    {
      _enabled = false;
      notifyListeners();
    }
  }

  void _deactivate()
  {
    _provider.removeHandler(_tagHandler);
  }

  void _fillMultiValuesWithParsedValue()
  {
    _multiValues = hasNotEmptyValue ? (value as String).split(';') : [];
  }

  bool _tagHandler(NfcProviderReadResult result, String? tagid)
  {
    try
    {
      if (result == NfcProviderReadResult.Ok && enabled)
      {
        if (inputType == FlexFieldInputTypeModel.MultipleChoice)
        {
          if (!_multiValues.contains(tagid))
          {
            _multiValues.add(tagid!);
            value = _multiValues.join(';'); // notifies listeners
          }
          else
          {
            return false;
          }
        }
        else
        {
          value = tagid;
        }

        return true;
      }
      
      return false;
    }
    finally
    {
      if (Platform.isIOS)
      {
        _deactivate();
      }
    }
  }
}