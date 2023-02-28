import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/storage/RoutineTasksStorage.dart';
import 'package:amigotools/services/webapi/RoutinesApi.dart';

class RoutineTasksController extends ControllerBase
{
  final _storage = $locator.get<RoutineTasksStorage>();
  final _api = $locator.get<RoutinesApi>();

  Future<bool> onCleanData() async => await _updateFromServer(uids: null);

  Future<bool> onServerState(Map<String, dynamic> state) async
  {
    if (state.containsKey(WebApiConfig.RoutineTasksApiCat))
    {
      final uids = (state[WebApiConfig.RoutineTasksApiCat] as List?)?.cast<String>();
      return await _updateFromServer(uids: uids);
    }

    return true;
  }

  Future<bool> _updateFromServer({required List<String>? uids}) async
  {
    final items = await _api.fetchRoutineTasks(uids: uids);

    if (items != null)
    {
      _storage.setSilentMode(true);
      await _acceptChanges(requestedUidsOrAll: uids, receivedItems: items);
      _storage.setSilentMode(false);

      return true;
    }

    return false;
  }

  Future _acceptChanges({required List<String>? requestedUidsOrAll, required Iterable<RoutineTask> receivedItems}) async
  {
    var ok = true;

    if (requestedUidsOrAll == null)
    {
      await _storage.deleteAll();

      for (var item in receivedItems)
      {
        try
        {
          if (await _storage.add(item) == null)
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
      final delIds = requestedUidsOrAll.toSet();

      for (var item in receivedItems)
      {
        delIds.remove(item.uid);

        try
        {
          if (!await _storage.update(item))
          {
            if (await _storage.add(item) == null)
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
        _storage.deleteByUids(uids: delIds.toList());
    }

    return ok;
  }
}