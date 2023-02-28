// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoutineTask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineTask _$RoutineTaskFromJson(Map<String, dynamic> json) {
  return RoutineTask(
    id: json['id'] as int? ?? 0,
    uid: keepString(json['uid']),
    routineId: json['routineId'] as int,
    objectId: json['objectId'] as int,
    workflowId: json['workflowId'] as int?,
    timeslotId: json['timeslotId'] as int?,
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    stopTime: json['stopTime'] == null
        ? null
        : DateTime.parse(json['stopTime'] as String),
    index: json['index'] as int?,
    userId: json['userId'] as int?,
    status: _$enumDecode(_$RoutineTaskStatusEnumMap, json['status'],
        unknownValue: RoutineTaskStatus.Planned),
  );
}

Map<String, dynamic> _$RoutineTaskToJson(RoutineTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'routineId': instance.routineId,
      'objectId': instance.objectId,
      'workflowId': instance.workflowId,
      'timeslotId': instance.timeslotId,
      'startTime': instance.startTime?.toIso8601String(),
      'stopTime': instance.stopTime?.toIso8601String(),
      'index': instance.index,
      'userId': instance.userId,
      'status': _$RoutineTaskStatusEnumMap[instance.status],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$RoutineTaskStatusEnumMap = {
  RoutineTaskStatus.Planned: 'Planned',
  RoutineTaskStatus.Started: 'Started',
  RoutineTaskStatus.Completed: 'Completed',
  RoutineTaskStatus.Paused: 'Paused',
  RoutineTaskStatus.Rejected: 'Rejected',
  RoutineTaskStatus.Unplanned: 'Unplanned',
  RoutineTaskStatus.Standing: 'Standing',
};
