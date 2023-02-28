import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/entities/rest/GeoPosition.dart';
import 'package:amigotools/entities/workflows/Workflow.dart';

part 'FlexObject.g.dart';

@JsonSerializable()
class FlexObject implements FlexItemBase
{
  // FlexItemBase

  final int id;
  final String entityIdent;
  final int? groupId;
  final Map<String, dynamic> values;
  final String? headline;

  // Specific

  final String name;
  final GeoPosition? position;
  final List<Workflow>? workflows;

  FlexObject({
    required this.id,
    required this.entityIdent,
    this.groupId,
    required this.values,
    this.headline,
    required this.name,
    this.position,
    this.workflows,
  });

  factory FlexObject.fromJson(Map<String, dynamic> hash) => _$FlexObjectFromJson(hash);
  Map<String, dynamic> toJson() => _$FlexObjectToJson(this);
}