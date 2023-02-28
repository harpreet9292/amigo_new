// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkflowActivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkflowActivity _$WorkflowActivityFromJson(Map<String, dynamic> json) {
  return WorkflowActivity(
    id: json['id'] as int,
    type: _$enumDecode(_$WorkflowActivityTypeEnumMap, json['type'],
        unknownValue: WorkflowActivityType.Unknown),
    headline: json['headline'] as String,
    details: json['details'] as String?,
    barcode: json['barcode'] as String?,
  );
}

Map<String, dynamic> _$WorkflowActivityToJson(WorkflowActivity instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$WorkflowActivityTypeEnumMap[instance.type],
    'headline': instance.headline,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('details', instance.details);
  writeNotNull('barcode', instance.barcode);
  return val;
}

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

const _$WorkflowActivityTypeEnumMap = {
  WorkflowActivityType.Unknown: 'Unknown',
  WorkflowActivityType.SingleCheckpoint: 'SingleCheckpoint',
  WorkflowActivityType.Checkpoint: 'Checkpoint',
  WorkflowActivityType.Start: 'Start',
  WorkflowActivityType.Stop: 'Stop',
  WorkflowActivityType.StartStop: 'StartStop',
  WorkflowActivityType.Instructions: 'Instructions',
  WorkflowActivityType.AutoStartStop: 'AutoStartStop',
};
