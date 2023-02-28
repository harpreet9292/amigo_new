import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class DateTimeFieldModel extends FlexFieldModel
{
  final FlexField _flexField;

  DateTimeFieldModel(FlexField flexField, dynamic value)
    : _flexField = flexField, super(flexField, value);
  
  @override @protected
  void initInternal(dynamic val) async
  {
    if (val != null)
    {
      super.initInternal(val);
    }
    else if (_flexField.initial != null)
    {
      final shiftMin = int.tryParse(_flexField.initial!);
      if (shiftMin != null)
      {
        final dt = DateTime.now().add(Duration(minutes: shiftMin));

        switch (inputType)
        {
          case FlexFieldInputTypeModel.Date:
            this.value = dateTimeToIsoDate(dt); // date, time, datetime
            break;

          case FlexFieldInputTypeModel.Time:
            this.value = dateTimeToIsoTime(dt); // date, time, datetime
            break;

          default:
            this.value = dateTimeToIsoDateTime(dt); // date, time, datetime
            break;
        }
      }
    }
  }
}