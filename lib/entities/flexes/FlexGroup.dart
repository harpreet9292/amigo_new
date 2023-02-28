import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/FlexItemBase.dart';

part 'FlexGroup.g.dart';

@JsonSerializable()
class FlexGroup implements FlexItemBase
{
  // FlexItemBase

  final int id;
  final String entityIdent;
  final int? groupId;
  final Map<String, dynamic> values;
  final String? headline;

  // Specific

  final String name;

  FlexGroup({
    required this.id,
    required this.entityIdent,
    this.groupId,
    required this.values,
    this.headline,
    required this.name,
  });

  factory FlexGroup.fromJson(Map<String, dynamic> hash) => _$FlexGroupFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexGroupToJson(this);
}