import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/rest/User.dart';

class UsersStorage extends StorageBase<User>
{
  @override
  String get tableName => "users";

  Future<Iterable<User>> fetch({int? id, String? role, bool? patrol}) async
  {
    var rows = await _internalFetch(columns: null, id: id, role: role, patrol: patrol);
    return rows.map((x) => User.fromJson(x));
  }

  Future<List<Map<String, Object?>>> _internalFetch({required List<String>? columns, int? id, String? role, bool? patrol}) async
  {
    var where = <String, Object?>{};

    if (id != null)
      where.putIfAbsent("id = ?", () => id);

    if (role != null)
      where.putIfAbsent("role = ?", () => role);

    if (patrol != null)
      where.putIfAbsent("patrol = ?", () => patrol.toNum());

    return await fetchRaw(columns: columns, where: where, orderBy: "name");
  }
}