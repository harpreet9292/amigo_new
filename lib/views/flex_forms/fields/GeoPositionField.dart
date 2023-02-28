import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/GeoPositionFieldModel.dart';

class GeoPositionField extends FlexFieldBase {
  GeoPositionField({required bool editMode}) : super(editMode: editMode);

  @override
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(FlexFieldModel model) {
    final geoposModel = model as GeoPositionFieldModel;
    if (geoposModel.hasNotEmptyValue && geoposModel.canOpenMap) {
      return [
        //Pair(Icons.navigation_outlined, (context, model) {}),
        Pair(Icons.location_on_outlined, (context, model) => geoposModel.openOnMap()),
      ];
    }
    
    return [];
  }
}