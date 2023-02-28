import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

part 'Material.g.dart';

@JsonSerializable()
class Material implements DbEntityBase
{
  final int id;
  final String name;
  final String unit;
  final num rounding;
  final num price;

  const Material({
    required this.id,
    required this.name,
    required this.unit,
    required this.rounding,
    required this.price,
  });

  factory Material.fromJson(Map<String, dynamic> hash) => _$MaterialFromJson(hash);
  Map<String, dynamic> toJson() => _$MaterialToJson(this);
}