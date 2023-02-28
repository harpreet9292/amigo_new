// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexGroup _$FlexGroupFromJson(Map<String, dynamic> json) {
  return FlexGroup(
    id: json['id'] as int,
    entityIdent: json['entityIdent'] as String,
    groupId: json['groupId'] as int?,
    values: json['values'] as Map<String, dynamic>,
    headline: json['headline'] as String?,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$FlexGroupToJson(FlexGroup instance) => <String, dynamic>{
      'id': instance.id,
      'entityIdent': instance.entityIdent,
      'groupId': instance.groupId,
      'values': instance.values,
      'headline': instance.headline,
      'name': instance.name,
    };
