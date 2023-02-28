import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class MaterialsFieldModel extends FlexFieldModel
{
  MaterialsFieldModel(FlexField flexField, dynamic value)
    : super(flexField, value);
  
  List<MaterialModel> _availableMaterials = [];
  List<Pair<MaterialModel, double>> _materialValues = [];

  List<MaterialModel> get availableMaterials => _availableMaterials;
  List<Pair<MaterialModel, double>> get materialValues => _materialValues;

  @override @protected
  void initInternal(dynamic val) async
  {
    super.initInternal(val);

    // TODO: read materials from db
    // TODO: init values
  }
}

class MaterialModel
{
  final int id;
  final String name;

  const MaterialModel(this.id, this.name);
}