import 'package:amigotools/entities/routines/Routine.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';

class RoutinesStorage extends StorageBase<Routine>
{
  @override
  String get tableName => "routines";

  Future<Iterable<Routine>> fetch({int? id}) async
  {
    var rows = await _internalFetch(columns: null, id: id);
    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["users"]);
      return Routine.fromJson(map);
    });
  }

  Future<List<Map<String, Object?>>> _internalFetch({required List<String>? columns, int? id}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    return await fetchRaw(columns: columns, where: where, orderBy: "name,id");
  }
}