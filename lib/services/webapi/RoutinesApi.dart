import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/entities/routines/Routine.dart';
import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

class RoutinesApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<Routine>?> fetchRoutines({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<Routine>(
      await _connector.request(WebApiConfig.RoutinesApiCat, queryIds: ids),
      mapper: (item) => Routine.fromJson(item),
    );
  }

  Future<Iterable<RoutineTask>?> fetchRoutineTasks({List<String>? uids}) async
  {
    return jsonDecodeAndMapList<RoutineTask>(
      await _connector.request(WebApiConfig.RoutineTasksApiCat, queryParams: {"uids": uids}),
      mapper: (item) => RoutineTask.fromJson(item),
    );
  }

  Future<bool> changeRoutineTask(
    RoutineTask task,
    {
      int? userId,
      RoutineTaskStatus? status,
    }) async
  {
    final data = {};

    if (userId != null)
      data["userId"] = userId;

    if (status != null)
      data["state"] = enumValueToString(status);

    if (data.isEmpty)
      throw ArgumentError("At least one field to change should be filled.");

    return await _connector.request(
      "${WebApiConfig.RoutineTasksApiCat}/${task.uid}",
      postData: data,
    ) != null;
  }
}