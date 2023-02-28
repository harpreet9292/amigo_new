import 'package:json_annotation/json_annotation.dart';

import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/entities/abstractions/EntityBase.dart';

part 'AuthStatus.g.dart';

@JsonSerializable()
class AuthStatus implements EntityBase
{
  final int id;
  final String name;
  final String role;
  @JsonKey(fromJson: jsonDecodeValueToBool)
  final bool patrol;
  final List<int> groups;
  final String sessionKey;

  const AuthStatus({
    required this.id,
    required this.name,
    required this.role,
    required this.patrol,
    required this.groups,
    required this.sessionKey,
  });

  factory AuthStatus.fromJson(Map<String, dynamic> hash) => _$AuthStatusFromJson(hash);
  Map<String, dynamic> toJson() => _$AuthStatusToJson(this);
}