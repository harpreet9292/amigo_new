import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/entities/workflows/ObjectEventExample.dart';
import 'package:amigotools/entities/flexes/FlexObject.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/services/storage/ObjectEventsStorage.dart';
import 'package:amigotools/services/core/workflows/WorkflowCoreModel.dart';
import 'package:amigotools/services/core/workflows/TimeslotCoreModel.dart';
import 'package:amigotools/entities/workflows/WorkflowActivity.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';

class ObjectVisitCoreModel extends ChangeNotifier
{
// #region Private fields

  final _objectsStorage = $locator.get<FlexObjectsStorage>();
  final _objectEventsStorage = $locator.get<ObjectEventsStorage>();
  final _settings = $locator.get<SettingsProvider>();

  bool _optAllowVisitPause = true;

  int? _objectVisitId;

  final int _objectId;
  final int? _workflowId;
  final int? _timeslotId;
  final int? _routineTaskId;

  FlexObject? _object;
  WorkflowCoreModel? _workflow;
  TimeslotCoreModel? _timeslot;

  DateTime? _startTime;
  DateTime? _stopTime;
  DateTime? _pauseTime;
  DateTime? _lastResumeTime;
  Duration _durationBeforeLastPause = Duration.zero;

  Set<int> _completedActivities = {};

// #endregion

// #region Initializers and Disposers

  ObjectVisitCoreModel(this._objectId, this._workflowId, this._timeslotId, this._routineTaskId)
  {
    _objectsStorage.addListener(load);
    _settings.addListener(_initSettings);

    _initSettings();
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _objectsStorage.removeListener(load);
    _settings.removeListener(_initSettings);
    super.dispose();

    _object = null;
    _workflow = null;
  }

  Future load() async
  {
    await _loadObject();
    await _loadObjectEvents();

    notifyListeners();
  }

  Future _loadObject() async
  {
    final objects = await _objectsStorage.fetch(ids: [_objectId]);

    if (objects.isNotEmpty)
    {
      _object = objects.first;

      if (_object!.workflows != null && _workflowId != null)
      {
        final workflow = objects.first.workflows!.firstWhere((x) => x.id == _workflowId);
        _workflow = WorkflowCoreModel(workflow);

        final timeslot = _timeslotId != null ? _workflow!.getTimeslotById(_timeslotId!) : null;
        _timeslot = timeslot != null ? TimeslotCoreModel(timeslot) : null;

        return;
      }
    }

    _object = null;
    _workflow = null;
  }

  Future _loadObjectEvents() async
  {
    _reset();

    final events = await _objectEventsStorage.fetch(workflowId: _workflowId, timeslotId: _timeslotId);

    for (final event in events)
    {
      switch (event.type)
      {
        case ObjectEventType.Undefined:
          // nothing
          break;

        case ObjectEventType.Started:
          _reset();
          _objectVisitId = event.id;
          _startTime = event.time;
          _lastResumeTime = _startTime;
          break;

        case ObjectEventType.Stopped:
          _reset();

          // use code below for load stopped visit for a task of a round? AND REMOVE _reset() above

          // _stopTime = event.time;
          // _pauseTime = null;

          // if (_lastResumeTime != null)
          // {
          //   _durationBeforeLastPause += _stopTime!.difference(_lastResumeTime!);
          //   _lastResumeTime = null;
          // }
          break;

        case ObjectEventType.Paused:
          _pauseTime = event.time;
          _durationBeforeLastPause += _pauseTime!.difference(_lastResumeTime!);
          _lastResumeTime = null;
          break;

        case ObjectEventType.Resumed:
          _pauseTime = null;
          _lastResumeTime = event.time;
          break;

        case ObjectEventType.Checkpoint:
          _completedActivities.add(event.activityId!);
          break;

        case ObjectEventType.SingleCheckpoint:
          _reset();

          // use code below for load stopped visit for a task of a round?

          // _objectVisitId = event.id;
          // _completedActivities.add(event.activityId!);

          // _stopTime = DateTime.now();
          // _pauseTime = null;
          // _lastResumeTime = null;
          break;
      }
    }
  }

  void _initSettings()
  {
    final newval = _settings.get<bool>(SettingsKeys.AllowVisitPause);

    if (_optAllowVisitPause != newval)
    {
      _optAllowVisitPause = newval;
      notifyListeners();
    }
  }

// #endregion

// #region Public Properties

  int? get id => _objectVisitId;

  FlexObject get object => _object!;
  WorkflowCoreModel get workflow => _workflow!;
  TimeslotCoreModel? get timeslot => _timeslot;

  DateTime? get startTime => _startTime;
  DateTime? get stopTime => _stopTime;
  DateTime? get pauseTime => _pauseTime;
  DateTime? get lastResumeTime => _lastResumeTime;

  Duration get duration
  {
    return _durationBeforeLastPause + (_lastResumeTime != null ? DateTime.now().difference(_lastResumeTime!) : Duration.zero);
  }

  bool get hasStart => _workflow != null && _workflow!.hasStart;
  bool get canStart => isAlive && (_startTime == null || _stopTime != null) && hasStart;
  bool get canStop => isAlive && _startTime != null && _stopTime == null;
  bool get canPause => canStop && _lastResumeTime != null && _optAllowVisitPause;
  bool get canResume => canStop && _lastResumeTime == null;

  bool get isAlive => _object != null && _workflow != null;
  bool get isOpened => canStop;
  bool get isActive => canPause;
  bool get isFinished => _stopTime != null;

// #endregion

// #region Public methods

  bool start({required bool manually, int? activityId, bool autoOnly = false})
  {
    if (canStart)
    {
      _reset();

      _startTime = DateTime.now();
      _lastResumeTime = _startTime;

      final items = workflow.fetchStartsOrStops(starts: true, autoOnly: autoOnly);
      if (items.isEmpty) return false;

      if (activityId == null)
      {
        activityId = items.first.id;
      }
      else
      {
        if (!items.any((x) => x.id == activityId))
          throw ArgumentError();
      }

      _saveObjectEvent(activityId: activityId, type: ObjectEventType.Started, manually: manually);

      notifyListeners();
      return true;
    }

    return false;
  }

  bool stop({required bool manually, int? activityId, bool autoOnly = false})
  {
    if (canStop)
    {
      _stopTime = DateTime.now();
      _pauseTime = null;

      if (_lastResumeTime != null)
      {
        _durationBeforeLastPause += _stopTime!.difference(_lastResumeTime!);
        _lastResumeTime = null;
      }

      final items = workflow.fetchStartsOrStops(starts: false, autoOnly: autoOnly);
      if (items.isEmpty) return false;

      if (activityId == null)
      {
        activityId = items.first.id;
      }
      else
      {
        if (!items.any((x) => x.id == activityId))
          throw ArgumentError();
      }

      _saveObjectEvent(activityId: activityId, type: ObjectEventType.Stopped, manually: manually);

      notifyListeners();
      return true;
    }

    return false;
  }

  bool pause({required bool manually})
  {
    if (canPause)
    {
      final event = _saveObjectEvent(type: ObjectEventType.Paused, activityId: null, manually: manually);

      _pauseTime = event.time;
      _durationBeforeLastPause += _pauseTime!.difference(_lastResumeTime!);
      _lastResumeTime = null;

      notifyListeners();
      return true;
    }

    return false;
  }

  bool resume({required bool manually})
  {
    if (canResume)
    {
      final event = _saveObjectEvent(type: ObjectEventType.Resumed, activityId: null, manually: manually);

      _pauseTime = null;
      _lastResumeTime = event.time;

      notifyListeners();
      return true;
    }

    return false;
  }

  bool isActivityCompleted(int activityId)
  {
    return _completedActivities.contains(activityId);
  }

  bool isFullyCompleted()
  {
    return !workflow.fetchCheckpoints().any((x) => !isActivityCompleted(x.id));
  }

  bool markActivityCompleted(int activityId, {required bool manually, bool silent = false})
  {
    if (!_completedActivities.contains(activityId))
    {
      final items = workflow.fetchCheckpoints(includeSingles: true).where((x) => x.id == activityId);

      if (items.isEmpty)
        ArgumentError("activityId should be id of Checkpoint or SingleCheckpoint");

      final item = items.first;

      if (item.type == WorkflowActivityType.SingleCheckpoint)
      {
        _completedActivities.add(activityId);

        _saveObjectEvent(activityId: activityId, type: ObjectEventType.SingleCheckpoint, manually: manually);

        _stopTime = DateTime.now();
        _pauseTime = null;
        _lastResumeTime = null;

        if (!silent)
          notifyListeners();

        return true;
      }

      if (!isOpened && !start(manually: false))
        return false;

      if (!isActive && !resume(manually: false))
        return false;

      _completedActivities.add(activityId);

      _saveObjectEvent(activityId: activityId, type: ObjectEventType.Checkpoint, manually: manually);

      if (workflow.hasAutoStartStop && isFullyCompleted())
      {
        stop(manually: false);
      }
      else
      {
        if (!silent)
          notifyListeners();
      }

      return true;
    }

    return false;
  }

// #endregion

// #region Private methods

  void _reset()
  {
    _objectVisitId = null;
    _startTime = null;
    _stopTime = null;
    _pauseTime = null;
    _lastResumeTime = null;
    _durationBeforeLastPause = Duration.zero;
    _completedActivities.clear();
  }

  ObjectEventExample _saveObjectEvent({required ObjectEventType type, required int? activityId, required bool manually})
  {
    final event = ObjectEventExample(
      objectId: _objectId,
      workflowId: _workflowId,
      timeslotId: _timeslotId,
      activityId: activityId,
      routineTaskId: _routineTaskId,
      type: type,
      time: DateTime.now(),
      manually: manually,
    );

    _objectEventsStorage.add(event).then((value)
    {
      if (type == ObjectEventType.Started)
      {
        _objectVisitId = value;
        notifyListeners();
      }
    });

    return event;
  }

// #endregion
}