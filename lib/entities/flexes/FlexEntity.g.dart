// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexEntity _$FlexEntityFromJson(Map<String, dynamic> json) {
  return FlexEntity(
    id: json['id'] as int,
    ident: json['ident'] as String,
    type: _$enumDecode(_$FlexEntityTypeEnumMap, json['type'],
        unknownValue: FlexEntityType.Unknown),
    name: json['name'] as String,
    plural: json['plural'] as String?,
    fields: (json['fields'] as List<dynamic>)
        .map((e) => FlexField.fromJson(e as Map<String, dynamic>))
        .toList(),
    rolesRead: (json['rolesRead'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    rolesCreate: (json['rolesCreate'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    headlines: (json['headlines'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    isFav: jsonDecodeValueToBool(json['isFav']),
    atMenu: jsonDecodeValueToBool(json['atMenu']),
    atStart: jsonDecodeValueToBool(json['atStart']),
    atFinish: jsonDecodeValueToBool(json['atFinish']),
    required: jsonDecodeValueToBool(json['required']),
  );
}

Map<String, dynamic> _$FlexEntityToJson(FlexEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ident': instance.ident,
      'type': _$FlexEntityTypeEnumMap[instance.type],
      'name': instance.name,
      'plural': instance.plural,
      'fields': instance.fields,
      'rolesRead': instance.rolesRead,
      'rolesCreate': instance.rolesCreate,
      'headlines': instance.headlines,
      'isFav': instance.isFav,
      'atMenu': instance.atMenu,
      'atStart': instance.atStart,
      'atFinish': instance.atFinish,
      'required': instance.required,
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

const _$FlexEntityTypeEnumMap = {
  FlexEntityType.Unknown: 'Unknown',
  FlexEntityType.Object: 'Object',
  FlexEntityType.Group: 'Group',
  FlexEntityType.Outcome: 'Outcome',
  FlexEntityType.Order: 'Order',
  FlexEntityType.Collection: 'Collection',
};
