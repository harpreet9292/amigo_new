import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/entities/abstractions/EntityBase.dart';

part 'FlexField.g.dart';

@JsonSerializable(includeIfNull: false)
class FlexField implements EntityBase {
  // General

  @JsonKey(unknownEnumValue: FlexFieldType.Unknown)
  final FlexFieldType type;

  final String ident;
  final String label;
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool required;
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool readonly;
  final String? hint;
  final dynamic initial;

  // Specific

  @JsonKey(unknownEnumValue: FlexFieldInputType.text)
  final FlexFieldInputType? inputType;

  final double? min;
  final double? max;
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool multiple;
  final String? param;
  final List<String>? values;

  // Security

  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool storable;

  const FlexField({
    required this.type,
    required this.ident,
    required this.label,
    this.required = false,
    this.readonly = false,
    this.hint,
    this.initial,
    this.inputType,
    this.min,
    this.max,
    this.multiple = false,
    this.values,
    this.param,
    this.storable = true,
  });

  factory FlexField.fromJson(Map<String, dynamic> hash) =>
      _$FlexFieldFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexFieldToJson(this);
}

enum FlexFieldType {
  Unknown,

  String,
  Number,
  Selection,
  Checkbox,
  DateTime,

  Collection,
  User,
  Images,
  Materials,
  PlaceId,
  GeoPosition,

  Object,
  Group,

  Category,
  FieldSet,
  Label,
}

enum FlexFieldInputType {
  text,
  password,
  number,
  datetime,
  time,
  date,
  email,
  tel, // TODO: phone?
  url,

  address,
  region,
  postcode,
  phone,
}
