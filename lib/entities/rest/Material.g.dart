// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Material _$MaterialFromJson(Map<String, dynamic> json) {
  return Material(
    id: json['id'] as int,
    name: json['name'] as String,
    unit: json['unit'] as String,
    rounding: json['rounding'] as num,
    price: json['price'] as num,
  );
}

Map<String, dynamic> _$MaterialToJson(Material instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'rounding': instance.rounding,
      'price': instance.price,
    };
