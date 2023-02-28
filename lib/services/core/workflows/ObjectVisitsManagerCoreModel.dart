import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/ObjectEventsStorage.dart';
import 'package:amigotools/entities/workflows/ObjectEventExample.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitCoreEntity.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitCoreModel.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';

class ObjectVisitsManagerCoreModel extends ChangeNotifier
{
  final _objectEventsStorage = $locator.get<ObjectEventsStorage>();
  final _objectsStorage = $locator.get<FlexObjectsStorage>();
  final _settings = $locator.get<SettingsProvider>();

  final _startedObjectVisits = <ObjectVisitCoreEntity>[];
  int _lastEventId = 0;
  ObjectVisitCoreEntity? _lastActivatedVisit = null;

  ObjectVisitsManagerCoreModel()
  {
    _objectEventsStorage.addListener(_update);
    _update();
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _objectEventsStorage.removeListener(_update);
    super.dispose();
  }

  Iterable<ObjectVisitCoreEntity> get startedObjectVisits => _startedObjectVisits;

  ObjectVisitCoreModel createModel([int objectId = 0, int? workflowId, int? timeslotId, int? routineTaskId])
  {
    return ObjectVisitCoreModel(objectId, workflowId, timeslotId, routineTaskId);
  }

  ObjectVisitCoreModel? getModelById(int objectVisitId)
  {
    final items = _startedObjectVisits.where((x) => x.id == objectVisitId);

    if (items.isNotEmpty)
    {
      final item = items.first;
      return ObjectVisitCoreModel(item.objectId, item.workflowId, item.timeslotId, item.routineTaskId);
    }

    return null;
  }

  void _update() async
  {
    await _loadNewEvents();
    await _loadObjectInfos();
    await _solveOtherActiveVisits();

    notifyListeners();
  }

  Future _loadNewEvents() async
  {
    final events = await _objectEventsStorage.fetch(
      whereAboveId: _lastEventId,
      types: [ObjectEventType.Started, ObjectEventType.Paused, ObjectEventType.Resumed, ObjectEventType.Stopped],
    );

    for (final event in events)
    {
      if (event.type == ObjectEventType.Started)
      {
        final item = ObjectVisitCoreEntity(
          event.id,
          event.objectId,
          event.workflowId,
          event.timeslotId,
          event.routineTaskId,
        );

        _startedObjectVisits.add(item);

        _lastActivatedVisit = item;
      }
      else
      {
        final items = _startedObjectVisits.where(
          (x) =>
              x.objectId == event.objectId &&
              x.workflowId == event.workflowId &&
              x.timeslotId == event.timeslotId,
        );

        if (items.isEmpty) continue;

        final item = items.first;

        switch (event.type)
        {
          case ObjectEventType.Stopped:
            _startedObjectVisits.remove(item);
            break;
          
          case ObjectEventType.Paused:
            item.paused = true;
            break;
          
          case ObjectEventType.Resumed:
            item.paused = false;
            _lastActivatedVisit = item;
            break;

          default:
        }       
      }

      _lastEventId = event.id;
    }
  }

  Future _loadObjectInfos() async
  {
    final newitems = _startedObjectVisits.where((x) => x.object == null);

    for (final item in newitems)
    {
      final objects = await _objectsStorage.fetchBrief(ids: [item.objectId]);

      if (objects.isNotEmpty)
      {
        item.object = objects.first;
      }
    }
  }

  Future _solveOtherActiveVisits() async
  {
    if (_settings.get<bool>(SettingsKeys.AllowMultipleActiveVisits))
      return;

    final allowedPause = _settings.get<bool>(SettingsKeys.AllowVisitPause);

    for (final visit in _startedObjectVisits)
    {
      if (visit != _lastActivatedVisit && (!visit.paused || !allowedPause))
      {
        final model = getModelById(visit.id);

        if (model != null)
        {
          await model.load();

          if (allowedPause)
          {
            model.pause(manually: false);
          }
          else
          {
            model.stop(manually: false);
          }
        }
      }
    }
  }
}