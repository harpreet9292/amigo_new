import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/services/core/routines/RoutineCoreModel.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/view_models/routines/RoutineTasksListModel.dart';

class RoutineModel extends ChangeNotifier
{
// #region Private

  final RoutineCoreModel _coreModel;
  RoutineTasksListModel? _tasksListModel;

// #endregion

// #region Public properties

  int get id => _coreModel.item.id;

  String get name => _coreModel.item.name;

  String? get date =>
      _coreModel.item.startTime != null
      ? dateTimeToLocalString(_coreModel.item.startTime!, dateOnly: true)
      : null;

  String? get timePeriod
  {
    if (_coreModel.item.startTime != null)
    {
      final starttime = dateTimeToLocalString(_coreModel.item.startTime!, timeOnly: true);
      final endtime = dateTimeToLocalString(_coreModel.item.endTime!, timeOnly: true);

      return "$starttime - $endtime";
    }

    return null;
  }

  String get progress
  {
    final total = _coreModel.tasks.length;
    final completed = _coreModel.tasks.where((x) => x.status == RoutineTaskStatus.Completed).length;
    return "$completed/$total";
  }

  RoutineTasksListModel get tasksListModel
  {
    if (_tasksListModel == null)
    {
      _tasksListModel = RoutineTasksListModel(_coreModel);
    }

    return _tasksListModel!;
  }

// #endregion

// #region Constructors and initializers

  RoutineModel(this._coreModel)
  {
    _coreModel.addListener(notifyListeners);
  }

  @override @mustCallSuper
  void dispose()
  {
    // ? _tasksListModel?.dispose();
    _coreModel.removeListener(notifyListeners);
    super.dispose();
  }

// #endregion
}