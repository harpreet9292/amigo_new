import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitsManagerCoreModel.dart';
import 'package:amigotools/utils/types/ViewModelStatus.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitCoreModel.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/entities/workflows/WorkflowActivity.dart';
import 'package:amigotools/services/core/workflows/TimeslotCoreModel.dart';
import 'package:amigotools/services/core/workflows/WorkflowCoreModel.dart';

class ObjectVisitModel extends ChangeNotifier
{
// #region Private fields

  final _manager = $locator.get<ObjectVisitsManagerCoreModel>();

  late final ObjectVisitCoreModel _coreModel;

  bool _mounted = true;
  ViewModelStatus _status = ViewModelStatus.Init;

  BriefDbItem? _objectInfo;
  BriefDbItem? _workflowInfo;
  BriefDbItem? _timeslotInfo;
  List<WorkflowActivityItemModel> _activities = [];

// #endregion

// #region Constructors and dispose

  ObjectVisitModel.create({required int objectId, int? workflowId, int? timeslotId, int? routineTaskId})
  {
    _coreModel = _manager.createModel(objectId, workflowId, timeslotId, routineTaskId);

    _coreModel.addListener(forceReload);
    _coreModel.load();
  }

  ObjectVisitModel.load(int objectVisitId)
  {
    final model = _manager.getModelById(objectVisitId);

    if (model != null)
    {
      _coreModel = model;

      _coreModel.addListener(forceReload);
      _coreModel.load();
    }
    else
    {
      _coreModel = _manager.createModel();
      _status = ViewModelStatus.Gone;
    }
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _coreModel.dispose();
    super.dispose();

    _mounted = false;
    _status = ViewModelStatus.Gone;
  }

// #endregion

// #region Public properties

  ViewModelStatus get status => _status;

  int? get itemId => _coreModel.id;

  BriefDbItem get objectInfo => _objectInfo!;
  BriefDbItem get workflowInfo => _workflowInfo!;
  BriefDbItem? get timeslotInfo => _timeslotInfo;

  ObjectVisitStateModel get workflowState
  {
    if (_coreModel.startTime == null)
      return ObjectVisitStateModel.NotStarted;
    else if (_coreModel.stopTime != null)
      return ObjectVisitStateModel.Finished;
    else if (_coreModel.lastResumeTime == null)
      return ObjectVisitStateModel.Paused;
    else if (resumeTime != null)
      return ObjectVisitStateModel.Resumed;
    else
      return ObjectVisitStateModel.Started;
  }

  DateTime? get startTime => _coreModel.startTime;
  DateTime? get stopTime => _coreModel.stopTime;
  Duration get duration => _coreModel.duration;
  DateTime? get pauseTime => _coreModel.pauseTime;
  DateTime? get resumeTime => _coreModel.lastResumeTime != _coreModel.startTime ? _coreModel.lastResumeTime : null;

  ObjectVisitValueStyleModel get startTimeStyle
  {
    if (_coreModel.startTime == null)
    {
      return ObjectVisitValueStyleModel.Hidden;
    }
    else if (_coreModel.timeslot != null
      && _coreModel.timeslot!.howIsDateTime(_coreModel.startTime!) == TimeslotTimeRelationCoreModel.Early)
    {
      return ObjectVisitValueStyleModel.Problem;
    }

    return ObjectVisitValueStyleModel.Normal;
  }

  ObjectVisitValueStyleModel get stopTimeStyle
  {
    if (_coreModel.stopTime == null)
    {
      return ObjectVisitValueStyleModel.Hidden;
    }
    else if (_coreModel.timeslot != null
      && _coreModel.timeslot!.howIsDateTime(_coreModel.stopTime!) == TimeslotTimeRelationCoreModel.Late)
    {
      return ObjectVisitValueStyleModel.Problem;
    }

    return ObjectVisitValueStyleModel.Normal;
  }
  
  ObjectVisitValueStyleModel get durationStyle
  {
    if (_coreModel.duration == Duration.zero)
    {
      return ObjectVisitValueStyleModel.Hidden;
    }
    else if (_coreModel.workflow.howIsDuration(_coreModel.duration) != WorkflowDurationRelationCoreModel.Normal)
    {
      return ObjectVisitValueStyleModel.Warning;
    }

    return ObjectVisitValueStyleModel.Normal;
  }

  bool get canStart => _coreModel.canStart;
  bool get canStop => _coreModel.canStop;
  bool get canPause => _coreModel.canPause;
  bool get canResume => _coreModel.canResume;

  List<WorkflowActivityItemModel> get activities => _activities;

// #endregion

// #region Public methods

  void forceReload()
  {
    _status = ViewModelStatus.Init;
    _updateAndNotify();
  }

  void start() => _coreModel.start(manually: true);
  void stop() => _coreModel.stop(manually: true);
  void pause() => _coreModel.pause(manually: true);
  void resume() => _coreModel.resume(manually: true);

  void markActivityCompleted(WorkflowActivityItemModel activity)
  {
    if (!_coreModel.isFinished && _coreModel.markActivityCompleted(activity.id, manually: true, silent: true))
    {
      _updateAndNotify();
    }
  }

// #endregion

// #region Private methods

  void _updateAndNotify()
  {
    if (!_mounted) return;

    if (!_coreModel.isAlive)
    {
      _status = ViewModelStatus.Gone;
      notifyListeners();
      return;
    }

    if (_status == ViewModelStatus.Init)
    {
      _objectInfo = BriefDbItem(
        id: _coreModel.object.id,
        title: _coreModel.object.name,
        subtitle: _coreModel.object.headline,
        extra: _coreModel.object.groupId,
      );

      String? duration;

      if (_coreModel.workflow.item.durationMin != null && _coreModel.workflow.item.durationMax != null)
      {
        duration = "${_coreModel.workflow.item.durationMin} - ${_coreModel.workflow.item.durationMax}";
      }
      else if (_coreModel.workflow.item.durationMin != null)
      {
        duration = "> ${_coreModel.workflow.item.durationMin!}";
      }
      else if (_coreModel.workflow.item.durationMax != null)
      {
        duration = "0 - ${_coreModel.workflow.item.durationMax!}";
      }

      _workflowInfo = BriefDbItem(
        id: _coreModel.workflow.item.id,
        title: _coreModel.workflow.item.name,
        subtitle: duration,
      );

      _timeslotInfo = _coreModel.timeslot != null
          ? BriefDbItem(
              id: _coreModel.timeslot!.item.id,
              title: "${_coreModel.timeslot!.getTimePeriodAsString()} [${_coreModel.timeslot!.getDaysAsString()}]",
            )
          : null;
    }

    _activities = _coreModel.workflow.fetchCheckpoints(includeSingles: true, includeInformations: true)
        .map((x) => WorkflowActivityItemModel(
            id: x.id,
            title: x.headline,
            subtitle: x.details,
            single: x.type == WorkflowActivityType.SingleCheckpoint,
            instructions: x.type == WorkflowActivityType.Instructions,
            completed: _coreModel.isActivityCompleted(x.id)))
        .toList();
  
    if (_mounted)
    {
      _status = ViewModelStatus.Ready;
      notifyListeners();
    }
  }

// #endregion
}

class WorkflowActivityItemModel
{
  final int id;
  final String title;
  final String? subtitle;
  final bool single;
  final bool instructions;
  final bool completed;

  const WorkflowActivityItemModel(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.single,
      required this.instructions,
      required this.completed});
}

enum ObjectVisitStateModel
{
  NotStarted,
  Started,
  Paused,
  Resumed,
  Finished,
}

enum ObjectVisitValueStyleModel
{
  Hidden,
  Normal,
  Warning,
  Problem,
}