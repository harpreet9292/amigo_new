import 'package:json_annotation/json_annotation.dart';
import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

part 'Routine.g.dart';

@JsonSerializable()
class Routine implements DbEntityBase
{
  final int id;
  final String name;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? groupId;

  @JsonKey(unknownEnumValue: RoutineAccessType.ByGroup)
  final RoutineAccessType access;

  final List<int>? users;
  final String? notes;

  const Routine({
    required this.id,
    required this.name,
    this.startTime,
    this.endTime,
    this.groupId,
    required this.access,
    this.users,
    this.notes,
  });

  factory Routine.fromJson(Map<String, dynamic> hash) => _$RoutineFromJson(hash);
  Map<String, dynamic> toJson() => _$RoutineToJson(this);
}

enum RoutineAccessType
{
  ByGroup,
  ByAllow,
  ByDisallow,
}