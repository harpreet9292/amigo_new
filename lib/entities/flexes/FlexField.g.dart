// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexField.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexField _$FlexFieldFromJson(Map<String, dynamic> json) {
  return FlexField(
    type: _$enumDecode(_$FlexFieldTypeEnumMap, json['type'],
        unknownValue: FlexFieldType.Unknown),
    ident: json['ident'] as String,
    label: json['label'] as String,
    required: jsonDecodeValueToBool(json['required']),
    readonly: jsonDecodeValueToBool(json['readonly']),
    hint: json['hint'] as String?,
    initial: json['initial'],
    inputType: _$enumDecodeNullable(
        _$FlexFieldInputTypeEnumMap, json['inputType'],
        unknownValue: FlexFieldInputType.text),
    min: (json['min'] as num?)?.toDouble(),
    max: (json['max'] as num?)?.toDouble(),
    multiple: jsonDecodeValueToBool(json['multiple']),
    values:
        (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
    param: json['param'] as String?,
    storable: jsonDecodeValueToBool(json['storable']),
  );
}

Map<String, dynamic> _$FlexFieldToJson(FlexField instance) {
  final val = <String, dynamic>{
    'type': _$FlexFieldTypeEnumMap[instance.type],
    'ident': instance.ident,
    'label': instance.label,
    'required': instance.required,
    'readonly': instance.readonly,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hint', instance.hint);
  writeNotNull('initial', instance.initial);
  writeNotNull('inputType', _$FlexFieldInputTypeEnumMap[instance.inputType]);
  writeNotNull('min', instance.min);
  writeNotNull('max', instance.max);
  val['multiple'] = instance.multiple;
  writeNotNull('param', instance.param);
  writeNotNull('values', instance.values);
  val['storable'] = instance.storable;
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

const _$FlexFieldTypeEnumMap = {
  FlexFieldType.Unknown: 'Unknown',
  FlexFieldType.String: 'String',
  FlexFieldType.Number: 'Number',
  FlexFieldType.Selection: 'Selection',
  FlexFieldType.Checkbox: 'Checkbox',
  FlexFieldType.DateTime: 'DateTime',
  FlexFieldType.Collection: 'Collection',
  FlexFieldType.User: 'User',
  FlexFieldType.Images: 'Images',
  FlexFieldType.Materials: 'Materials',
  FlexFieldType.PlaceId: 'PlaceId',
  FlexFieldType.GeoPosition: 'GeoPosition',
  FlexFieldType.Object: 'Object',
  FlexFieldType.Group: 'Group',
  FlexFieldType.Category: 'Category',
  FlexFieldType.FieldSet: 'FieldSet',
  FlexFieldType.Label: 'Label',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$FlexFieldInputTypeEnumMap = {
  FlexFieldInputType.text: 'text',
  FlexFieldInputType.password: 'password',
  FlexFieldInputType.number: 'number',
  FlexFieldInputType.datetime: 'datetime',
  FlexFieldInputType.time: 'time',
  FlexFieldInputType.date: 'date',
  FlexFieldInputType.email: 'email',
  FlexFieldInputType.tel: 'tel',
  FlexFieldInputType.url: 'url',
  FlexFieldInputType.address: 'address',
  FlexFieldInputType.region: 'region',
  FlexFieldInputType.postcode: 'postcode',
  FlexFieldInputType.phone: 'phone',
};
