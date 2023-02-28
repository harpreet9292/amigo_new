import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/EntityBase.dart';
import 'package:amigotools/entities/workflows/WorkflowActivity.dart';
import 'package:amigotools/entities/workflows/WorkflowTimeslot.dart';

part 'Workflow.g.dart';

@JsonSerializable(includeIfNull: false)
class Workflow implements EntityBase
{
  final int id;
  final String name;
  final int? durationMin;
  final int? durationMax;

  final List<WorkflowActivity> activities;
  final List<WorkflowTimeslot>? timeslots;

  const Workflow({
    required this.id,
    required this.name,
    this.durationMin,
    this.durationMax,
    required this.activities,
    required this.timeslots,
  });

  factory Workflow.fromJson(Map<String, dynamic> hash) => _$WorkflowFromJson(hash);
  Map<String, dynamic> toJson() => _$WorkflowToJson(this);
}