import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

class RoutineTasksStorage extends StorageBase<RoutineTask>
{
  @override
  String get tableName => "routine_tasks";

  Future<Iterable<RoutineTask>> fetch({int? id, String? uid, int? routineId, RoutineTaskStatus? status, String? search}) async
  {
    var rows = await _internalFetch(
      columns: null,
      id: id,
      uid: uid,
      routineId: routineId,
      status: status,
      search: search,
    );
    return rows.map((x) => RoutineTask.fromJson(x));
  }

  @override
  Future<bool> update(RoutineTask item) async
  {
    final values = StorageBase.encodeComplexValuesAndBool(item.toJson());

    final count = await db.context.update(
      tableName,
      StorageBase.encodeComplexValuesAndBool(Map.from(values)),
      where: "uid = ?",
      whereArgs: [item.uid],
    );

    if (count > 0)
    {
      notifyListenersIfAllowed();
      return true;
    }

    return false;
  }

  Future<int> deleteByUids({required List<String> uids}) async
  {
    final valIn = uids.map((x) => "'$x'").join(',');

    final count = await db.context.delete(
      tableName,
      where: "uid IN ($valIn)",
    );

    if (count > 0)
    {
      notifyListenersIfAllowed();
    }

    return count;
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, int? id, String? uid, int? routineId, RoutineTaskStatus? status, String? search}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (uid != null)
      where.putIfAbsent("uid = ?", () => uid);

    if (routineId != null)
      where.putIfAbsent("routineId = ?", () => routineId);

    if (status != null)
      where.putIfAbsent("status = ?", () => enumValueToString(status));

    if (search != null)
    {
      final escstr = escapeForSqlOperatorLike(search);
      where.putIfAbsent(
        "(objectId IN (SELECT id FROM objects WHERE name LIKE '%$escstr%' ESCAPE '\\') OR id = ? OR objectId = ?)",
        () => search,
      );
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "id"); // todo: index,startTime,stopTime,id
  }
}