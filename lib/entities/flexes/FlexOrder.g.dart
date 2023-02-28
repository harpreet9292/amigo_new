// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexOrder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexOrder _$FlexOrderFromJson(Map<String, dynamic> json) {
  return FlexOrder(
    id: json['id'] as int,
    entityIdent: json['entityIdent'] as String,
    groupId: json['groupId'] as int?,
    values: json['values'] as Map<String, dynamic>,
    headline: json['headline'] as String?,
    objectId: json['objectId'] as int?,
    userId: json['userId'] as int?,
    time: DateTime.parse(json['time'] as String),
    state: _$enumDecode(_$FlexOrderStateEnumMap, json['state'],
        unknownValue: FlexOrderState.Unknown),
  );
}

Map<String, dynamic> _$FlexOrderToJson(FlexOrder instance) => <String, dynamic>{
      'id': instance.id,
      'entityIdent': instance.entityIdent,
      'groupId': instance.groupId,
      'values': instance.values,
      'headline': instance.headline,
      'objectId': instance.objectId,
      'userId': instance.userId,
      'time': dateTimeToIsoDateTime(instance.time),
      'state': _$FlexOrderStateEnumMap[instance.state],
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

const _$FlexOrderStateEnumMap = {
  FlexOrderState.Unknown: 'Unknown',
  FlexOrderState.Active: 'Active',
  FlexOrderState.Closed: 'Closed',
  FlexOrderState.Canceled: 'Canceled',
};
