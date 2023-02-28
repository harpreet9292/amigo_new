import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexGroup.dart';

class FlexGroupsStorage extends StorageBase<FlexGroup>
{
  @override
  String get tableName => "groups";

  Future<Iterable<FlexGroup>> fetch({int? id}) async
  {
    var rows = await _internalFetch(columns: null, ids: id != null ? [id] : null);

    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["values"]);
      return FlexGroup.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief({List<int>? ids, String? entityIdent, int? groupId, String? search}) async
  {
    var rows = await _internalFetch(
      columns: ["id", "name", "headline"],
      ids: ids,
      entityIdent: entityIdent,
      groupId: groupId,
      search: search,
    );

    return rows.map((x) => BriefDbItem(id: x["id"] as int, title: x["name"] as String, subtitle: x["headline"] as String?));
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, List<int>? ids, String? entityIdent, int? groupId, String? search}) async
  {
    var where = <String, Object?>{};

    if (ids != null && ids.isNotEmpty)
      where.putIfAbsent("id IN ${valuesForSqlOperatorIn(ids)}", () => StorageBase.SkipValueMarker);

    if (entityIdent != null)
      where.putIfAbsent("entityIdent = ?", () => entityIdent);

    if (groupId != null)
      where.putIfAbsent("groupId = ?", () => groupId);

    if (search != null)
    {
      final escstr = escapeForSqlOperatorLike(search);
      where.putIfAbsent("(name LIKE '%$escstr%' ESCAPE '\\' OR headline LIKE '%$escstr%' ESCAPE '\\' OR id = ?)", () => search);
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "name");
  }
}