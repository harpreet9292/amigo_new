import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/EntityBase.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

part 'GeoPosition.g.dart';

@JsonSerializable(includeIfNull: false)
class GeoPosition implements EntityBase
{
  final double lat;
  final double lng;
  final double? accur;
  final double? speed;
  final String? addr;

  @JsonKey(toJson: dateTimeToIsoDateTime)
  final DateTime? time;

  const GeoPosition({
    required this.lat,
    required this.lng,
    this.accur,
    this.speed,
    this.addr,
    this.time,
  });

  factory GeoPosition.fromJson(Map<String, dynamic> hash) => _$GeoPositionFromJson(hash);
  Map<String, dynamic> toJson() => _$GeoPositionToJson(this);
}