import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexCustItem.dart';

class FlexCustItemsStorage extends StorageBase<FlexCustItem>
{
  @override
  String get tableName => "custitems";

  Future<Iterable<FlexCustItem>> fetch({int? id}) async
  {
    var rows = await _internalFetch(columns: null, ids: id != null ? [id] : null);

    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["values"]);
      return FlexCustItem.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief(
      {List<int>? ids,
      String? entityIdent,
      int? groupId,
      int? objectId,
      int? outcomeId,
      String? search}) async
  {
    var rows = await _internalFetch(
      columns: ["id", "headline"],
      ids: ids,
      entityIdent: entityIdent,
      groupId: groupId,
      objectId: objectId,
      outcomeId: outcomeId,
      search: search,
    );

    return rows.map((x) => BriefDbItem(id: x["id"] as int, title: x["headline"] as String? ?? "#${x["id"]}"));
  }

  Future<List<Map<String, Object?>>> _internalFetch(
      {required List<String>? columns,
      List<int>? ids,
      String? entityIdent,
      int? groupId,
      int? objectId,
      int? outcomeId,
      String? search}) async
  {
    var where = <String, Object?>{};

    if (ids != null && ids.isNotEmpty)
      where.putIfAbsent("id IN ${valuesForSqlOperatorIn(ids)}", () => StorageBase.SkipValueMarker);

    if (entityIdent != null)
      where.putIfAbsent("entityIdent = ?", () => entityIdent);

    if (groupId != null)
      where.putIfAbsent("groupId = ?", () => groupId);

    if (objectId != null)
      where.putIfAbsent("objectId = ?", () => objectId);

    if (outcomeId != null)
      where.putIfAbsent("outcomeId = ?", () => outcomeId);

    if (search != null)
    {
      final escstr = escapeForSqlOperatorLike(search);
      where.putIfAbsent("(headline LIKE '%$escstr%' ESCAPE '\\' OR id = ?)", () => search);
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "headline,id");
  }
}