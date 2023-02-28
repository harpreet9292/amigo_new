import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

part 'SysTask.g.dart';

@JsonSerializable()
class SysTask implements DbEntityBase
{
  final int id;
  final String type;
  @JsonKey(toJson: jsonEncode, fromJson: jsonDecode)
  final dynamic body;
  final int attempts;

  @JsonKey(unknownEnumValue: SysTaskPrio.Normal)
  final SysTaskPrio prio;

  const SysTask({
    required this.id,
    required this.type,
    required this.body,
    this.attempts = 0,
    this.prio = SysTaskPrio.Normal,
  });

  factory SysTask.fromJson(Map<String, dynamic> hash) => _$SysTaskFromJson(hash);
  Map<String, dynamic> toJson() => _$SysTaskToJson(this);
}

enum SysTaskPrio
{
  High,     // requested by user, changing statuses of orders
  Normal,   // sending outcomes, updating of orders
  Low,      // sending positions, background items updating
  LowLong,  // sending attachments
}