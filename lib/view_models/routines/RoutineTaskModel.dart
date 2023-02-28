import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitsManagerCoreModel.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitModel.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/entities/flexes/FlexObject.dart';
import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/entities/workflows/Workflow.dart';
import 'package:amigotools/entities/workflows/WorkflowTimeslot.dart';
import 'package:amigotools/services/webapi/RoutinesApi.dart';

class RoutineTaskModel extends ChangeNotifier
{
// #region Private

  final _api = $locator.get<RoutinesApi>();
  final _visitsManager = $locator.get<ObjectVisitsManagerCoreModel>();

  final RoutineTask _item;
  final FlexObject _object;

  Workflow? _workflow;
  WorkflowTimeslot? _timeslot;

// #endregion

// #region Public properties

  int get objectId => _object.id;

  String get object => _object.name;

  String? get workflow => _workflow?.name;

  String? get period
  {
    if (_timeslot != null)
    {
      final start = dateTimeToLocalString(_timeslot!.startTime, timeOnly: true);
      final end = dateTimeToLocalString(_timeslot!.endTime, timeOnly: true);
    
      return "$start - $end";
    }

    return null;
  }

  RoutineTaskGroupTypeModel get groupType
  {
    final now = DateTime.now();

    if (_item.status == RoutineTaskStatus.Rejected)
      return RoutineTaskGroupTypeModel.Rejected;
    if (_item.status == RoutineTaskStatus.Started || _item.status == RoutineTaskStatus.Paused)
      return RoutineTaskGroupTypeModel.Started;
    else if (_item.stopTime != null && _item.stopTime!.difference(now) < Duration.zero)
      return RoutineTaskGroupTypeModel.Delay;
    else if (_item.startTime != null && _item.startTime!.difference(now) > Duration.zero)
      return RoutineTaskGroupTypeModel.Later;
    else
      return RoutineTaskGroupTypeModel.Now;
  }

  bool get isRejected => _item.status == RoutineTaskStatus.Rejected;

// #endregion

  RoutineTaskModel(this._item, this._object)
  {
    _setWorkflow();
    _setTimeslot();
  }

  void pauseObjectVisit()
  {
    // todo
  }

  void setRejectStatus(bool rejected)
  {
    // todo
    _api.changeRoutineTask(_item, status: RoutineTaskStatus.Rejected);
  }

  ObjectVisitModel getObjectVisitModel()
  {
    return ObjectVisitModel.create(
      objectId: _object.id,
      workflowId: _workflow?.id,
      timeslotId: _timeslot?.id,
      routineTaskId: _item.id,
    );
  }

  void _setWorkflow()
  {
    if (_object.workflows != null && _item.workflowId != null)
    {
      final workflows = _object.workflows!.where((x) => x.id == _item.workflowId);

      if (workflows.isNotEmpty)
      {
        _workflow = workflows.first;
      }
    }
  }

  void _setTimeslot()
  {
    if (_workflow != null && _item.timeslotId != null)
    {
      final timeslots = _workflow!.timeslots!.where((x) => x.id == _item.timeslotId);

      if (timeslots.isNotEmpty)
      {
        _timeslot = timeslots.first;
      }
    }
  }
}

enum RoutineTaskGroupTypeModel
{
  Started,
  Delay,
  Now,
  Later,
  Rejected,
}