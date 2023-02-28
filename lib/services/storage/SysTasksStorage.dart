import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/rest/SysTask.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

class SysTasksStorage extends StorageBase<SysTask>
{
  @override
  String get tableName => "sys_tasks";

  @override
  bool get assignNegativeId => false;

  Future<Iterable<SysTask>> fetch({int? id, String? type, SysTaskPrio? prio}) async
  {
    var raws = await _internalFetch(columns: null, id: id, type: type, prio: prio);
    return raws.map((x) => SysTask.fromJson(x));
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, int? id, String? type, SysTaskPrio? prio}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (type != null)
      where.putIfAbsent("type = ?", () => type);

    if (prio != null)
      where.putIfAbsent("prio = ?", () => enumValueToString(prio));

    return await fetchRaw(columns: columns, where: where, orderBy: "id");
  }
}