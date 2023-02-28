import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/FlexItemBase.dart';

part 'FlexCustItem.g.dart';

@JsonSerializable()
class FlexCustItem implements FlexItemBase
{
  // FlexItemBase

  final int id;
  final String entityIdent;
  final int? groupId;
  final Map<String, dynamic> values;
  final String? headline;

  // Specific

  final int? objectId;
  final int? outcomeId;

  FlexCustItem({
    required this.id,
    required this.entityIdent,
    this.groupId,
    required this.values,
    this.headline,
    this.objectId,
    this.outcomeId,
  });

  factory FlexCustItem.fromJson(Map<String, dynamic> hash) => _$FlexCustItemFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexCustItemToJson(this);
}