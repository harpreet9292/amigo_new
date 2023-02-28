import 'dart:convert';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:amigotools/services/state/MirrorChangeNotifier.dart';
import 'package:amigotools/entities/abstractions/DbEntityBase.dart';
import 'package:amigotools/services/storage/DatabaseConnector.dart';
import 'package:amigotools/entities/abstractions/EntityBase.dart';

abstract class StorageBase<T extends DbEntityBase> extends MirrorChangeNotifier
{
  static const SkipValueMarker = const [];

  final db = $locator.get<DatabaseConnector>();

  bool _silentMode = false;
  bool _attemptWhileSilent = false;

  String get tableName;

  bool get assignNegativeId => true;

  Future<List<Map<String, Object?>>> fetchRaw({List<String>? columns, Map<String, Object?>? where, String? orderBy}) async
  {
    if (where != null && where.isEmpty)
      where = null;

    return await db.context.query(
      tableName,
      columns: columns,
      where: where?.keys.join(" AND "),
      whereArgs: where?.values.where((x) => !(x is List)).toList(), // skipping fake empty list values, keys are used for IN operator 
      orderBy: orderBy,
    );
  }

  Future<int?> add(T item) async
  {
    int? useid;

    final hash = item.toJson();

    if (hash["id"] == 0 || hash["id"] == null)
    {
      // todo: try INTEGER PRIMARY KEY DESC

      if (assignNegativeId)
      {
        // todo: async is problem here, use https://pub.dev/packages/synchronized ?
        final res = await db.context.rawQuery("SELECT MIN(id) FROM `$tableName`");
        final minid = res.first.values.first as int?;

        useid = minid != null && minid < 0 ? minid - 1 : -1;
        hash["id"] = useid;
      }
      else
      {
        hash.remove("id");
      }
    }
    else
    {
      useid = hash["id"];
    }

    final newid = await db.context.insert(
      tableName,
      encodeComplexValuesAndBool(hash),
    );

    if (newid != 0) // 0 if error
    {
      notifyListenersIfAllowed();
      return useid ?? newid;
    }

    return null;
  }

  Future<bool> update(T item) async
  {
    return await updatePartial(
      id: item.id,
      values: encodeComplexValuesAndBool(item.toJson()),
    );
  }

  Future<bool> updatePartial({required int id, required Map<String, dynamic> values}) async
  {
    final count = await db.context.update(
      tableName,
      encodeComplexValuesAndBool(Map.from(values)),
      where: "id = ?",
      whereArgs: [id],
    );

    if (count > 0)
    {
      notifyListenersIfAllowed();
      return true;
    }

    return false;
  }

  Future<bool> acceptChanges({required List<int>? requestedIdsOrAll, required Iterable<T> receivedItems}) async
  {
    var ok = true;

    if (requestedIdsOrAll == null)
    {
      await deleteAll();

      for (var item in receivedItems)
      {
        try
        {
          if (await add(item) == null)
            ok = false;
        }
        catch (e)
        {
          print("AMG in acceptChanges(): $e");
          ok = false;
        }
      }
    }
    else
    {
      final delIds = requestedIdsOrAll.toSet();

      for (var item in receivedItems)
      {
        delIds.remove(item.id);

        try
        {
          if (!await update(item))
          {
            if (await add(item) == null)
              ok = false;
          }
        }
        catch (e)
        {
          print("AMG in acceptChanges(): $e");
          ok = false;
        }
      }

      if (delIds.isNotEmpty)
        delete(ids: delIds.toList());
    }

    return ok;
  }

  Future<int> delete({int? id, List<int>? ids}) async
  {
    if (ids == null)
    {
      if (id != null)
      {
        ids = [id];
      }
      else
      {
        throw ArgumentError("any id or ids argument should not be null");
      }
    }

    if (ids.isNotEmpty)
    {
      final valIn = ids.join(',');

      final count = await db.context.delete(
        tableName,
        where: "id IN ($valIn)",
      );

      if (count > 0)
      {
        notifyListenersIfAllowed();
      }

      return count;
    }
    else
    {
      return 0;
    }
  }

  Future<int> deleteAll() async
  {
    final count = await db.context.delete(tableName);

    if (count > 0)
    {
      notifyListenersIfAllowed();
    }

    return count;
  }

  void setSilentMode(bool enable)
  {
    if (_silentMode != enable)
    {
      _silentMode = enable;

      if (!_silentMode && _attemptWhileSilent)
      {
        notifyListeners();
      }

      _attemptWhileSilent = false;
    }
  }

  void notifyListenersIfAllowed()
  {
    if (!_silentMode)
    {
      notifyListeners();
    }
    else
    {
      _attemptWhileSilent = true;
    }
  }

  Map<String, dynamic> decodeComplexValues(Map<String, dynamic> map, List<String> keys)
  {
    Map<String, dynamic>? newmap;

    for (var key in keys)
    {
      final val = map[key];

      if (val is String)
      {
        if (newmap == null)
        {
          newmap = Map<String, dynamic>.from(map);
        }

        newmap[key] = jsonDecode(val);
      }
    }

    return newmap ?? map;
  }

  static Map<String, dynamic> encodeComplexValuesAndBool(Map<String, dynamic> map)
  {
    for (var key in map.keys)
    {
      final val = map[key];
      
      if (val is List || val is Map || val is EntityBase)
      {
        map[key] = jsonEncode(val);
      }
      else if (val is bool)
      {
        map[key] = val.toNum();
      }
    }

    return map;
  }
}