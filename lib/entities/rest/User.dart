import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

part 'User.g.dart';

@JsonSerializable()
class User implements DbEntityBase
{
  final int id;
  final String name;
  final String role;

  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool patrol;

  const User({
    required this.id,
    required this.name,
    required this.role,
    required this.patrol,
  });

  factory User.fromJson(Map<String, dynamic> hash) => _$UserFromJson(hash);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}