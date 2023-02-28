import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/rest/Material.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';

class MaterialsStorage extends StorageBase<Material>
{
  @override
  String get tableName => "materials";

  Future<Iterable<Material>> fetch({int? id}) async
  {
    var rows = await _internalFetch(columns: null, id: id);
    return rows.map((x) => Material.fromJson(x));
  }

  Future<Iterable<BriefDbItem>> fetchBrief() async
  {
    var rows = await _internalFetch(
      columns: ["id", "name"],
    );

    return rows.map(
      (x) => BriefDbItem(
        id: x["id"] as int,
        title: x["name"] as String,
      ),
    );
  }

  Future<List<Map<String, Object?>>> _internalFetch({required List<String>? columns, int? id}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    return await fetchRaw(columns: columns, where: where, orderBy: "name");
  }
}