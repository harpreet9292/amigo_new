import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/flexes/FlexEntity.dart';

class FlexEntitiesStorage extends StorageBase<FlexEntity>
{
  Map<String, BriefDbItem>? _cachedItems;

  FlexEntitiesStorage()
  {
    addListener(() => _cachedItems = null);
  }

  @override
  String get tableName => "entities";

  Future<Iterable<FlexEntity>> fetch(
    {int? id, String? ident, List<FlexEntityType>? types, bool? atMenu, bool? atLogin, bool? atLogout}) async
  {
    var raws = await _internalFetch(
      columns: null,
      id: id,
      ident: ident,
      types: types,
      atMenu: atMenu,
      atLogin: atLogin,
      atLogout: atLogout,
    );

    return raws.map((x)
    {
      final map = decodeComplexValues(x, ["fields", "rolesRead", "rolesCreate", "headlines"]);
      return FlexEntity.fromJson(map);
    });
  }

  Future<Iterable<BriefDbItem>> fetchBrief(
    {required bool getPlural,
    String? ident,
    List<FlexEntityType>? types,
    String? hasRoleCreate,
    bool? isFav,
    bool? atMenu,
    bool? atLogin,
    bool? atLogout}) async
  {
    var raws = await _internalFetch(
      columns: ["id", "ident", "name", "plural"],
      ident: ident,
      types: types,
      hasRoleCreate: hasRoleCreate,
      isFav: isFav,
      atMenu: atMenu,
      atLogin: atLogin,
      atLogout: atLogout,
    );

    return raws.map((x) => BriefDbItem(
      id: x["id"] as int,
      ident: x["ident"] as String,
      title: (getPlural && x["plural"] != null ? x["plural"] : x["name"]) as String,
    ));
  }

  BriefDbItem? getCachedBriefItem(String ident)
  {
    return _cachedItems?[ident];
  }

  Future<BriefDbItem?> getCachedBriefItemEnsureFilled(String ident) async
  {
    await ensureFilledCache();
    return _cachedItems![ident];
  }

  Future<void> ensureFilledCache() async
  {
    if (_cachedItems == null)
    {
      final iter = await fetchBrief(getPlural: false);

      _cachedItems = Map.fromIterable(
        iter,
        key: (k) => (k as BriefDbItem).ident!,
        value: (v) => v,
      );
    }
  }

  Future<List<Map<String, Object?>>> _internalFetch(
    {required List<String>? columns,
    int? id,
    String? ident,
    List<FlexEntityType>? types,
    String? hasRoleCreate,
    bool? isFav,
    bool? atMenu,
    bool? atLogin,
    bool? atLogout
    }) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (ident != null)
      where.putIfAbsent("ident = ?", () => ident);

    if (types != null && types.isNotEmpty)
    {
      final vals = valuesForSqlOperatorIn(types.map((x) => enumValueToString(x)));
      where.putIfAbsent("type IN $vals", () => StorageBase.SkipValueMarker);
    }

    if (hasRoleCreate != null)
    {
      final escstr = escapeForSqlOperatorLike(hasRoleCreate);
      where.putIfAbsent("rolesCreate LIKE '%\"$escstr\"%' ESCAPE '\\'", () => StorageBase.SkipValueMarker);
    }

    if (isFav != null)
      where.putIfAbsent("isFav = ?", () => isFav.toNum());

    if (atMenu != null)
      where.putIfAbsent("atMenu = ?", () => atMenu.toNum());

    if (atLogin != null)
      where.putIfAbsent("atLogin = ?", () => atLogin.toNum());

    if (atLogout != null)
      where.putIfAbsent("atLogout = ?", () => atLogout.toNum());

    return await fetchRaw(columns: columns, where: where, orderBy: "name");
  }
}