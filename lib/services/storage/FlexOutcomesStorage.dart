import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexOutcome.dart';
import 'package:amigotools/utils/types/Func.dart';

class FlexOutcomesStorage extends StorageBase<FlexOutcome>
{
  @override
  String get tableName => "outcomes";

  Future<Iterable<FlexOutcome>> fetch({int? id, FlexOutcomeSysStatus? sysStatus}) async
  {
    var rows = await _internalFetch(columns: null, id: id, sysStatus: sysStatus);
    return rows.map((x)
    {
      final map = decodeComplexValues(x, ["values", "position"]);
      return FlexOutcome.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief({String? entityIdent, int? orderId, Func2<dynamic, Map<String, Object?>, String?>? solveIdent}) async
  {
    var rows = await _internalFetch(
      columns: ["id", "entityIdent", "headline", "time"],
      entityIdent: entityIdent,
      orderId: orderId,
    );

    return rows.map((x) => BriefDbItem(
      id: x["id"] as int,
      ident: solveIdent != null ? solveIdent(x["entityIdent"], x) : x["entityIdent"] as String?,
      title: x["headline"] as String? ?? "",
      subtitle: dateTimeToLocalString(DateTime.parse(x["time"] as String)),
    ));
  }

  Future<bool> changeStatus(FlexOutcome item, FlexOutcomeSysStatus status)
  {
    return updatePartial(id: item.id, values: {"sys_status": enumValueToString(status)});
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns, int? id, String? entityIdent, int? orderId, FlexOutcomeSysStatus? sysStatus}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (entityIdent != null)
      where.putIfAbsent("entityIdent = ?", () => entityIdent);

    if (orderId != null)
      where.putIfAbsent("orderId = ?", () => orderId);

    if (sysStatus != null)
      where.putIfAbsent("sys_status = ?", () => enumValueToString(sysStatus));

    return await fetchRaw(columns: columns, where: where, orderBy: "headline,id");
  }
}