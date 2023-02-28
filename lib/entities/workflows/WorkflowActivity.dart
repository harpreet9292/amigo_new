import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/EntityBase.dart';

part 'WorkflowActivity.g.dart';

@JsonSerializable(includeIfNull: false)
class WorkflowActivity implements EntityBase
{
  final int id;

  @JsonKey(unknownEnumValue: WorkflowActivityType.Unknown)
  final WorkflowActivityType type;

  final String headline;
  final String? details;
  final String? barcode;

  const WorkflowActivity({
    required this.id,
    required this.type,
    required this.headline,
    this.details,
    this.barcode,
  });

  factory WorkflowActivity.fromJson(Map<String, dynamic> hash) => _$WorkflowActivityFromJson(hash);
  Map<String, dynamic> toJson() => _$WorkflowActivityToJson(this);
}

enum WorkflowActivityType
{
  Unknown,
  SingleCheckpoint,
  Checkpoint,
  Start,
  Stop,
  StartStop,
  Instructions,
  AutoStartStop,
}