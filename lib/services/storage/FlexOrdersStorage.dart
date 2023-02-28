import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexOrder.dart';
import 'package:amigotools/utils/types/Func.dart';

class FlexOrdersStorage extends StorageBase<FlexOrder>
{
  @override
  String get tableName => "orders";

  Future<Iterable<FlexOrder>> fetch({int? id}) async
  {
    var rows = await _internalFetch(columns: null, id: id);

    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["values"]);
      return FlexOrder.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief(
    {String? entityIdent, FlexOrderState? state, List<int>? groupIds, String? search, Func1<dynamic, String?>? solveIdent}) async
  {
    var rows = await _internalFetch(
      columns: ["id", "entityIdent", "time", "headline", "userId"],
      entityIdent: entityIdent,
      state: state,
      groupIds: groupIds,
      search: search,
    );
    
    return rows.map((x) => BriefDbItem(
      id: x["id"] as int,
      ident: solveIdent != null ? solveIdent(x["entityIdent"]) : x["entityIdent"] as String?,
      title: dateTimeToLocalString(DateTime.parse(x["time"] as String)),
      subtitle: x["headline"] as String?,
      extra: x["userId"] as int?),
    );
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, int? id, String? entityIdent, FlexOrderState? state, List<int>? groupIds, String? search}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (entityIdent != null)
      where.putIfAbsent("entityIdent = ?", () => entityIdent);

    if (state != null)
      where.putIfAbsent("state = ?", () => enumValueToString(state));

    if (groupIds != null && groupIds.isNotEmpty)
      where.putIfAbsent("(groupId IS NULL OR groupId IN ${valuesForSqlOperatorIn(groupIds)})", () => StorageBase.SkipValueMarker);

    if (search != null)
    {
      final escstr = escapeForSqlOperatorLike(search);
      where.putIfAbsent("(headline LIKE '%$escstr%' ESCAPE '\\' OR id = ?)", () => search);
    }

    return await fetchRaw(columns: columns, where: where, orderBy: "id");
  }
}