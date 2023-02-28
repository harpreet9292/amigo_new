import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/StringFieldModel.dart';

class ViewField extends FlexFieldBase {
  ViewField() : super(editMode: false);

  @override
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(
      FlexFieldModel model) sync* {
    if (model.hasNotEmptyValue) {
      switch (model.inputType) {
        case FlexFieldInputTypeModel.Address:
          yield Pair(Icons.house_outlined,
              (_, model) => (model as StringFieldModel).performAction());
          break;

        case FlexFieldInputTypeModel.Telephone:
          yield Pair(Icons.phone_outlined,
              (_, model) => (model as StringFieldModel).performAction());
          break;

        default:
      }
    }
  }
}
