import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/DbEntityBase.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

part 'ObjectEvent.g.dart';

@JsonSerializable()
class ObjectEventExample implements DbEntityBase
{
  final int id;

  final int objectId;
  final int? workflowId;
  final int? timeslotId;
  final int? activityId;
  final int? routineTaskId;

  @JsonKey(unknownEnumValue: ObjectEventType.Undefined)
  final ObjectEventType type;

  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime time;

  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool manually;

  @JsonKey(name: "sys_status", unknownEnumValue: ObjectEventStatus.Created)
  final ObjectEventStatus sysStatus;

  ObjectEventExample({
    this.id = 0,
    required this.objectId,
    this.workflowId,
    this.timeslotId,
    this.activityId,
    this.routineTaskId,
    required this.type,
    required this.time,
    required this.manually,
    this.sysStatus = ObjectEventStatus.Created,
  });

  factory ObjectEventExample.fromJson(Map<String, dynamic> hash) => _$ObjectEventFromJson(hash);
  Map<String, dynamic> toJson() => _$ObjectEventToJson(this);
}

enum ObjectEventType
{
  Undefined,
  Started,
  Stopped,
  Paused,
  Resumed,
  Checkpoint,
  SingleCheckpoint,
}

enum ObjectEventStatus
{
  Created,
  Sent,
  Received,
}