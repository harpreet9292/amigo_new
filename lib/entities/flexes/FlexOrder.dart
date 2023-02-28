import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';

part 'FlexOrder.g.dart';

@JsonSerializable()
class FlexOrder implements FlexItemBase
{
  // FlexItemBase

  final int id;
  final String entityIdent;
  final int? groupId;
  final Map<String, dynamic> values;
  final String? headline;

  // Specific

  final int? objectId;
  final int? userId;

  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime time;

  @JsonKey(unknownEnumValue: FlexOrderState.Unknown)
  final FlexOrderState state;

  FlexOrder({
    required this.id,
    required this.entityIdent,
    this.groupId,
    required this.values,
    this.headline,
    this.objectId,
    this.userId,
    required this.time,
    required this.state,
  });

  factory FlexOrder.fromJson(Map<String, dynamic> hash) => _$FlexOrderFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexOrderToJson(this);
}

enum FlexOrderState
{
  Unknown,
  Active,
  Closed,
  Canceled,
}