// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlexObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexObject _$FlexObjectFromJson(Map<String, dynamic> json) {
  return FlexObject(
    id: json['id'] as int,
    entityIdent: json['entityIdent'] as String,
    groupId: json['groupId'] as int?,
    values: json['values'] as Map<String, dynamic>,
    headline: json['headline'] as String?,
    name: json['name'] as String,
    position: json['position'] == null
        ? null
        : GeoPosition.fromJson(json['position'] as Map<String, dynamic>),
    workflows: (json['workflows'] as List<dynamic>?)
        ?.map((e) => Workflow.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$FlexObjectToJson(FlexObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityIdent': instance.entityIdent,
      'groupId': instance.groupId,
      'values': instance.values,
      'headline': instance.headline,
      'name': instance.name,
      'position': instance.position,
      'workflows': instance.workflows,
    };
