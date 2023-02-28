import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/PlaceIdFieldModel.dart';

class PlaceIdField extends FlexFieldBase {
  PlaceIdField({required bool editMode}) : super(editMode: editMode);

  @override
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(FlexFieldModel model) =>
    model.hasNotEmptyValue && editMode ? [Pair(Icons.close, (context, model) => (model as PlaceIdFieldModel).clear())] : [];

  @override
  void onClick(BuildContext context, FlexFieldModel model)
    => (model as PlaceIdFieldModel).userRequest();
}