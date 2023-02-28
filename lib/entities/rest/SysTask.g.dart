// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SysTask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SysTask _$SysTaskFromJson(Map<String, dynamic> json) {
  return SysTask(
    id: json['id'] as int,
    type: json['type'] as String,
    body: jsonDecode(json['body'] as String),
    attempts: json['attempts'] as int,
    prio: _$enumDecode(_$SysTaskPrioEnumMap, json['prio'],
        unknownValue: SysTaskPrio.Normal),
  );
}

Map<String, dynamic> _$SysTaskToJson(SysTask instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'body': jsonEncode(instance.body),
      'attempts': instance.attempts,
      'prio': _$SysTaskPrioEnumMap[instance.prio],
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

const _$SysTaskPrioEnumMap = {
  SysTaskPrio.High: 'High',
  SysTaskPrio.Normal: 'Normal',
  SysTaskPrio.Low: 'Low',
  SysTaskPrio.LowLong: 'LowLong',
};
