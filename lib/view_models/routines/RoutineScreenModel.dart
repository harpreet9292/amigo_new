import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/core/routines/RoutinesManagerCoreModel.dart';
import 'package:amigotools/view_models/routines/RoutineModel.dart';
import 'package:amigotools/view_models/routines/RoutinesListModel.dart';

class RoutineScreenModel extends ChangeNotifier
{
// #region Private

  final _manager = $locator.get<RoutinesManagerCoreModel>();

  bool _mounted = true;
  RoutineModel? _currentRoutine;

// #endregion

// #region Public properties

  final RoutinesListModel routinesList = RoutinesListModel();

  RoutineModel? get currentRoutine
  {
    if (_currentRoutine == null)
    {
      _currentRoutine = _manager.currentRoutine != null
          ? RoutineModel(_manager.currentRoutine!)
          : null;
    }
    
    return _currentRoutine;
  }

// #endregion

// #region Constructors and initializers

  RoutineScreenModel()
  {
    _manager.addListener(_onCoreModelChanged);
  }

  @override @mustCallSuper
  void dispose()
  {
    _mounted = false;

    routinesList.dispose();
    _currentRoutine?.dispose();

    _manager.removeListener(_onCoreModelChanged);

    super.dispose();
  }

// #endregion

  void setCurrentRoutine(int routineId)
  {
    if (routineId != _currentRoutine?.id)
    {
      _currentRoutine?.dispose();
      _currentRoutine = null;

      _manager.setCurrentRoutine(routineId);
    }
  }

  void _onCoreModelChanged()
  {
    if (_currentRoutine?.id != _manager.currentRoutine?.item.id)
    {
      _currentRoutine?.dispose();
      _currentRoutine = null;

      if (_mounted)
        notifyListeners();
    }
  }
}