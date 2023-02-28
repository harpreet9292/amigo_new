// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ObjectEventExample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectEventExample _$ObjectEventFromJson(Map<String, dynamic> json) {
  return ObjectEventExample(
    id: json['id'] as int,
    objectId: json['objectId'] as int,
    workflowId: json['workflowId'] as int?,
    timeslotId: json['timeslotId'] as int?,
    activityId: json['activityId'] as int?,
    routineTaskId: json['routineTaskId'] as int?,
    type: _$enumDecode(_$ObjectEventTypeEnumMap, json['type'],
        unknownValue: ObjectEventType.Undefined),
    time: DateTime.parse(json['time'] as String),
    manually: jsonDecodeValueToBool(json['manually']),
    sysStatus: _$enumDecode(_$ObjectEventStatusEnumMap, json['sys_status'],
        unknownValue: ObjectEventStatus.Created),
  );
}

Map<String, dynamic> _$ObjectEventToJson(ObjectEventExample instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objectId': instance.objectId,
      'workflowId': instance.workflowId,
      'timeslotId': instance.timeslotId,
      'activityId': instance.activityId,
      'routineTaskId': instance.routineTaskId,
      'type': _$ObjectEventTypeEnumMap[instance.type],
      'time': dateTimeToIsoDateTime(instance.time),
      'manually': instance.manually,
      'sys_status': _$ObjectEventStatusEnumMap[instance.sysStatus],
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

const _$ObjectEventTypeEnumMap = {
  ObjectEventType.Undefined: 'Undefined',
  ObjectEventType.Started: 'Started',
  ObjectEventType.Stopped: 'Stopped',
  ObjectEventType.Paused: 'Paused',
  ObjectEventType.Resumed: 'Resumed',
  ObjectEventType.Checkpoint: 'Checkpoint',
  ObjectEventType.SingleCheckpoint: 'SingleCheckpoint',
};

const _$ObjectEventStatusEnumMap = {
  ObjectEventStatus.Created: 'Created',
  ObjectEventStatus.Sent: 'Sent',
  ObjectEventStatus.Received: 'Received',
};
