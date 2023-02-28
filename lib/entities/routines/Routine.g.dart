// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<String, dynamic> json) {
  return Routine(
    id: json['id'] as int,
    name: json['name'] as String,
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
    groupId: json['groupId'] as int?,
    access: _$enumDecode(_$RoutineAccessTypeEnumMap, json['access'],
        unknownValue: RoutineAccessType.ByGroup),
    users: (json['users'] as List<dynamic>?)?.map((e) => e as int).toList(),
    notes: json['notes'] as String?,
  );
}

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'groupId': instance.groupId,
      'access': _$RoutineAccessTypeEnumMap[instance.access],
      'users': instance.users,
      'notes': instance.notes,
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

const _$RoutineAccessTypeEnumMap = {
  RoutineAccessType.ByGroup: 'ByGroup',
  RoutineAccessType.ByAllow: 'ByAllow',
  RoutineAccessType.ByDisallow: 'ByDisallow',
};
