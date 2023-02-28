import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexObject.dart';

class FlexObjectsStorage extends StorageBase<FlexObject>
{
  @override
  String get tableName => "objects";

  Future<Iterable<FlexObject>> fetch({List<int>? ids}) async
  {
    var rows = await _internalFetch(columns: null, ids: ids);
    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["values", "position", "workflows"]);
      return FlexObject.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief({List<int>? ids, String? entityIdent, List<int>? groupIds, String? search}) async
  {
    var rows = await _internalFetch(
      columns: ["id", "name", "headline", "groupId"],
      ids: ids,
      entityIdent: entityIdent,
      groupIds: groupIds,
      search: search,
    );

    return rows.map(
      (x) => BriefDbItem(
          id: x["id"] as int,
          title: x["name"] as String,
          subtitle: x["headline"] as String?,
          extra: x["groupId"]),
    );
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, List<int>? ids, String? entityIdent, List<int>? groupIds, String? search}) async
  {
    var where = <String, Object?>{};

    if (ids != null && ids.isNotEmpty)
      where.putIfAbsent("id IN ${valuesForSqlOperatorIn(ids)}", () => StorageBase.SkipValueMarker);

    if (entityIdent != null)
      where.putIfAbsent("entityIdent = ?", () => entityIdent);

    if (groupIds != null && groupIds.isNotEmpty)
      where.putIfAbsent("groupId IN ${valuesForSqlOperatorIn(groupIds)}", () => StorageBase.SkipValueMarker);

    if (search != null)
    {
      final escstr = escapeForSqlOperatorLike(search);
      where.putIfAbsent("(name LIKE '%$escstr%' ESCAPE '\\' OR headline LIKE '%$escstr%' ESCAPE '\\' OR id = ?)", () => search);
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "name");
  }
}