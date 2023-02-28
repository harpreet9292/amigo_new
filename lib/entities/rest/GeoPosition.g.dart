// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GeoPosition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) {
  return GeoPosition(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    accur: (json['accur'] as num?)?.toDouble(),
    speed: (json['speed'] as num?)?.toDouble(),
    addr: json['addr'] as String?,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) {
  final val = <String, dynamic>{
    'lat': instance.lat,
    'lng': instance.lng,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('accur', instance.accur);
  writeNotNull('speed', instance.speed);
  writeNotNull('addr', instance.addr);
  writeNotNull('time', dateTimeToIsoDateTime(instance.time));
  return val;
}
