import 'package:amigotools/entities/workflows/ObjectEventExample.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

class ObjectEventsStorage extends StorageBase<ObjectEventExample>
{
  @override
  String get tableName => "object_events";

  @override
  bool get assignNegativeId => false;

  Future<Iterable<ObjectEventExample>> fetch(
      {int? id,
      int? whereAboveId,
      int? objectId,
      int? workflowId,
      int? timeslotId,
      int? routineTaskId,
      List<ObjectEventType>? types,
      List<ObjectEventStatus>? statuses}) async
  {
    var raws = await _internalFetch(
        columns: null,
        id: id,
        whereAboveId: whereAboveId,
        objectId: objectId,
        workflowId: workflowId,
        timeslotId: timeslotId,
        routineTaskId: routineTaskId,
        types: types,
        statuses: statuses);

    return raws.map((x) => ObjectEventExample.fromJson(x));
  }

  Future<bool> changeStatus(ObjectEventExample event, ObjectEventStatus status)
  {
    return updatePartial(id: event.id, values: {"sys_status": enumValueToString(status)});
  }

  Future<List<Map<String, Object?>>> _internalFetch(
      {required List<String>? columns,
      int? id,
      int? whereAboveId,
      int? objectId,
      int? workflowId,
      int? timeslotId,
      int? routineTaskId,
      List<ObjectEventType>? types,
      List<ObjectEventStatus>? statuses}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (whereAboveId != null)
      where.putIfAbsent("id > ?", () => whereAboveId);

    if (objectId != null)
      where.putIfAbsent("objectId = ?", () => objectId);

    if (workflowId != null)
      where.putIfAbsent("workflowId = ?", () => workflowId);

    if (timeslotId != null)
      where.putIfAbsent("timeslotId = ?", () => timeslotId);

    if (routineTaskId != null)
      where.putIfAbsent("routineTaskId = ?", () => routineTaskId);

    if (types != null && types.isNotEmpty)
    {
      final vals = valuesForSqlOperatorIn(types.map((x) => enumValueToString(x)));
      where.putIfAbsent("type IN $vals", () => StorageBase.SkipValueMarker);
    }

    if (statuses != null && statuses.isNotEmpty)
    {
      final vals = valuesForSqlOperatorIn(statuses.map((x) => enumValueToString(x)));
      where.putIfAbsent("sys_status IN $vals", () => StorageBase.SkipValueMarker);
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "id");
  }
}