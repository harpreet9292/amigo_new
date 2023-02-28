import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/DbEntityBase.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

part 'FlexEntity.g.dart';

@JsonSerializable()
class FlexEntity implements DbEntityBase
{
  // General
  
  final int id;
  final String ident;

  @JsonKey(unknownEnumValue: FlexEntityType.Unknown)
  final FlexEntityType type;

  final String name;
  final String? plural;
  final List<FlexField> fields;

  // Permissions

  @JsonKey(defaultValue: [])
  final List<String> rolesRead;
  @JsonKey(defaultValue: [])
  final List<String> rolesCreate;

  // Behaviour

  @JsonKey(defaultValue: [])
  final List<String> headlines; // todo: identifiers of fields

  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool isFav;             // show as favorite button or separated menu item
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool atMenu;            // show in menu (to create outcomes or to list objects/groups/orders)
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool atStart;           // show in list when user logged in
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool atFinish;          // show in list when user logged out
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool required;          // required to fill and send by user when atLogin and atLogout

  const FlexEntity({
    required this.id,
    required this.ident,
    required this.type,
    required this.name,
    this.plural,
    required this.fields,
    this.rolesRead = const [],
    this.rolesCreate = const [],
    this.headlines = const [],
    this.isFav = false,
    this.atMenu = true,
    this.atStart = false,
    this.atFinish = false,
    this.required = false,
  });

  factory FlexEntity.fromJson(Map<String, dynamic> hash) => _$FlexEntityFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexEntityToJson(this);
}

enum FlexEntityType
{
  Unknown,

  Object,
  Group,
  Outcome,
  Order,
  Collection,
}