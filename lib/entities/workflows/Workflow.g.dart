// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workflow _$WorkflowFromJson(Map<String, dynamic> json) {
  return Workflow(
    id: json['id'] as int,
    name: json['name'] as String,
    durationMin: json['durationMin'] as int?,
    durationMax: json['durationMax'] as int?,
    activities: (json['activities'] as List<dynamic>)
        .map((e) => WorkflowActivity.fromJson(e as Map<String, dynamic>))
        .toList(),
    timeslots: (json['timeslots'] as List<dynamic>?)
        ?.map((e) => WorkflowTimeslot.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$WorkflowToJson(Workflow instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('durationMin', instance.durationMin);
  writeNotNull('durationMax', instance.durationMax);
  val['activities'] = instance.activities;
  writeNotNull('timeslots', instance.timeslots);
  return val;
}
