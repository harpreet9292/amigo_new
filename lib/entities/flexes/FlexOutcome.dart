import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/entities/rest/GeoPosition.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

part 'FlexOutcome.g.dart';

@JsonSerializable()
class FlexOutcome implements FlexItemBase
{
  // FlexItemBase

  final int id;
  final String entityIdent;
  final int? groupId;
  final Map<String, dynamic> values;
  final String? headline;

  // Specific

  final int? objectId;
  final int? orderId;
  final GeoPosition? position;

  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime time;

  @JsonKey(name: "sys_status", unknownEnumValue: FlexOutcomeSysStatus.Completed)
  final FlexOutcomeSysStatus sysStatus;

  FlexOutcome({
    required this.id,
    required this.entityIdent,
    this.groupId,
    required this.values,
    this.headline,
    this.objectId,
    this.orderId,
    this.position,
    required this.time,
    required this.sysStatus,
  });

  factory FlexOutcome.fromJson(Map<String, dynamic> hash) => _$FlexOutcomeFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexOutcomeToJson(this);
}

enum FlexOutcomeSysStatus
{
  Draft,
  Completed,
  SendingAttachments,
  Sent,
}