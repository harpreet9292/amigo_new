// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexOutcome.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexOutcome _$FlexOutcomeFromJson(Map<String, dynamic> json) {
  return FlexOutcome(
    id: json['id'] as int,
    entityIdent: json['entityIdent'] as String,
    groupId: json['groupId'] as int?,
    values: json['values'] as Map<String, dynamic>,
    headline: json['headline'] as String?,
    objectId: json['objectId'] as int?,
    orderId: json['orderId'] as int?,
    position: json['position'] == null
        ? null
        : GeoPosition.fromJson(json['position'] as Map<String, dynamic>),
    time: DateTime.parse(json['time'] as String),
    sysStatus: _$enumDecode(_$FlexOutcomeSysStatusEnumMap, json['sys_status'],
        unknownValue: FlexOutcomeSysStatus.Completed),
  );
}

Map<String, dynamic> _$FlexOutcomeToJson(FlexOutcome instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityIdent': instance.entityIdent,
      'groupId': instance.groupId,
      'values': instance.values,
      'headline': instance.headline,
      'objectId': instance.objectId,
      'orderId': instance.orderId,
      'position': instance.position,
      'time': dateTimeToIsoDateTime(instance.time),
      'sys_status': _$FlexOutcomeSysStatusEnumMap[instance.sysStatus],
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

const _$FlexOutcomeSysStatusEnumMap = {
  FlexOutcomeSysStatus.Draft: 'Draft',
  FlexOutcomeSysStatus.Completed: 'Completed',
  FlexOutcomeSysStatus.SendingAttachments: 'SendingAttachments',
  FlexOutcomeSysStatus.Sent: 'Sent',
};
