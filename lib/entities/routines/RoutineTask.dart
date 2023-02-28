import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

part 'RoutineTask.g.dart';

@JsonSerializable()
class RoutineTask implements DbEntityBase
{
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(fromJson: keepString)
  final String uid;
  final int routineId;

  final int objectId;
  final int? workflowId;
  final int? timeslotId;

  final DateTime? startTime;
  final DateTime? stopTime;
  final int? index;
  final int? userId;

  @JsonKey(unknownEnumValue: RoutineTaskStatus.Planned)
  final RoutineTaskStatus status;

  const RoutineTask({
    this.id = 0,
    required this.uid,
    required this.routineId,
    required this.objectId,
    this.workflowId,
    this.timeslotId,
    this.startTime,
    this.stopTime,
    this.index,
    this.userId,
    required this.status,
  });

  factory RoutineTask.fromJson(Map<String, dynamic> hash) => _$RoutineTaskFromJson(hash);
  Map<String, dynamic> toJson() => _$RoutineTaskToJson(this);
}

enum RoutineTaskStatus
{
  Planned,
  Started,
  Completed,
  Paused,
  Rejected,
  Unplanned,
  Standing,
}