import 'dart:async';

import 'package:amigotools/entities/workflows/ObjectEventExample.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/storage/ObjectEventsStorage.dart';
import 'package:amigotools/services/storage/RoutineTasksStorage.dart';
import 'package:amigotools/services/webapi/EventsApi.dart';

class EventsController extends ControllerBase
{
  final _storage = $locator.get<ObjectEventsStorage>();
  final _api = $locator.get<EventsApi>();
  final _tasksStorage = $locator.get<RoutineTasksStorage>();

  @override
  Future<bool> onLoginChanged(bool isLogin) async
  {
    if (isLogin)
    {
      _storage.addListener(_onStorageChanged);

      _onStorageChanged();
    }
    else
    {
      _storage.removeListener(_onStorageChanged);
    }

    return true;
  }

  void _onStorageChanged() async
  {
    final events = await _storage.fetch(statuses: [ObjectEventStatus.Created]);

    for (final event in events)
    {
      String? uid;

      if (event.routineTaskId != null)
      {
        final tasks = await _tasksStorage.fetch(id: event.routineTaskId);

        if (tasks.isNotEmpty)
          uid = tasks.first.uid;
      }

      if (await _api.sendObjectEvent(event, uid: uid))
      {
        if (!await _storage.changeStatus(event, ObjectEventStatus.Sent))
        {
          // todo
        }
      }
      else
      {
        // todo
      }
    }
  }
}