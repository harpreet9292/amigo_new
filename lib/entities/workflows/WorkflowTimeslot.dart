import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/EntityBase.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

part 'WorkflowTimeslot.g.dart';

@JsonSerializable(includeIfNull: false)
class WorkflowTimeslot implements EntityBase
{
  final int id;
  final String days;

  @JsonKey(toJson: dateTimeToIsoTime, fromJson: parseIsoTime)
  final DateTime startTime;
  @JsonKey(toJson: dateTimeToIsoTime, fromJson: parseIsoTime)
  final DateTime endTime;
  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime? startDate;
  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime? endDate;

  const WorkflowTimeslot({
    required this.id,
    required this.days,
    required this.startTime,
    required this.endTime,
    this.startDate,
    this.endDate,
  });

  factory WorkflowTimeslot.fromJson(Map<String, dynamic> hash) => _$WorkflowTimeslotFromJson(hash);
  Map<String, dynamic> toJson() => _$WorkflowTimeslotToJson(this);
}