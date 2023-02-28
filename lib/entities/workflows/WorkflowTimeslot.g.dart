// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkflowTimeslot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkflowTimeslot _$WorkflowTimeslotFromJson(Map<String, dynamic> json) {
  return WorkflowTimeslot(
    id: json['id'] as int,
    days: json['days'] as String,
    startTime: parseIsoTime(json['startTime'] as String),
    endTime: parseIsoTime(json['endTime'] as String),
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
  );
}

Map<String, dynamic> _$WorkflowTimeslotToJson(WorkflowTimeslot instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'days': instance.days,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('startTime', dateTimeToIsoTime(instance.startTime));
  writeNotNull('endTime', dateTimeToIsoTime(instance.endTime));
  writeNotNull('startDate', dateTimeToIsoDateTime(instance.startDate));
  writeNotNull('endDate', dateTimeToIsoDateTime(instance.endDate));
  return val;
}
