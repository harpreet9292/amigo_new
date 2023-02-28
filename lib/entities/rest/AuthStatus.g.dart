// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthStatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthStatus _$AuthStatusFromJson(Map<String, dynamic> json) {
  return AuthStatus(
    id: json['id'] as int,
    name: json['name'] as String,
    role: json['role'] as String,
    patrol: jsonDecodeValueToBool(json['patrol']),
    groups: (json['groups'] as List<dynamic>).map((e) => e as int).toList(),
    sessionKey: json['sessionKey'] as String,
  );
}

Map<String, dynamic> _$AuthStatusToJson(AuthStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'patrol': instance.patrol,
      'groups': instance.groups,
      'sessionKey': instance.sessionKey,
    };
