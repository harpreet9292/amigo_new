// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexCustItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexCustItem _$FlexCustItemFromJson(Map<String, dynamic> json) {
  return FlexCustItem(
    id: json['id'] as int,
    entityIdent: json['entityIdent'] as String,
    groupId: json['groupId'] as int?,
    values: json['values'] as Map<String, dynamic>,
    headline: json['headline'] as String?,
    objectId: json['objectId'] as int?,
    outcomeId: json['outcomeId'] as int?,
  );
}

Map<String, dynamic> _$FlexCustItemToJson(FlexCustItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityIdent': instance.entityIdent,
      'groupId': instance.groupId,
      'values': instance.values,
      'headline': instance.headline,
      'objectId': instance.objectId,
      'outcomeId': instance.outcomeId,
    };
