import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/entities/routines/Routine.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/core/routines/RoutineCoreModel.dart';
import 'package:amigotools/services/storage/RoutinesStorage.dart';

class RoutinesManagerCoreModel extends ChangeNotifier
{
  final _routinesStorage = $locator.get<RoutinesStorage>();
  final _appState = $locator.get<AppStateBridge>();

  bool _mounted = true;
  List<RoutineCoreModel> _routines = [];
  RoutineCoreModel? _currentRoutine;

  List<RoutineCoreModel> get routines => _routines;

  RoutineCoreModel? get currentRoutine => _currentRoutine;

  RoutinesManagerCoreModel()
  {
    _routinesStorage.addListener(_loadAsync);
    _appState.addListener(_onStateChanged);

    _loadAsync();
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _mounted = false;

    _routines.forEach((x) => x.dispose());

    _routinesStorage.removeListener(_loadAsync);
    _appState.removeListener(_onStateChanged);

    super.dispose();
  }

  void setCurrentRoutine(int? id)
  {
    if (_currentRoutine?.item.id != id && _mounted)
    {
      if (id != null)
      {
        for (final routine in _routines)
        {
          if (routine.item.id == id)
          {
            _currentRoutine = routine;
            _appState.currentRoutine = id;

            _currentRoutine!.loadTasks();

            notifyListeners();
            return;
          }
        }
      }

      _currentRoutine = null;
      _appState.currentRoutine = null;

      notifyListeners();
    }
  }

  void _loadAsync() async
  {
    _routines.forEach((x) => x.dispose());

    final appStateCurrentRoutineId = _appState.currentRoutine;
    _currentRoutine = null;

    final items = await _routinesStorage.fetch();

    _routines = items
      .where((x) => _isRoutineAllowedForCurrentUser(x))
      .map((x)
      {
        final model = RoutineCoreModel(x);

        if (x.id == appStateCurrentRoutineId)
        {
          _currentRoutine = model;
          _currentRoutine!.loadTasks();
        }

        return model;
      })
      .toList();

    if (_mounted)
      notifyListeners();
  }

  void _onStateChanged()
  {
    if (_appState.currentRoutine != _currentRoutine?.item.id)
    {
      setCurrentRoutine(_appState.currentRoutine);
    }
  }

  bool _isRoutineAllowedForCurrentUser(Routine routine)
  {
    if (_appState.authStatus == null)
      return false;

    switch (routine.access)
    {
      case RoutineAccessType.ByGroup:
        return routine.groupId == null || _appState.authStatus!.groups.contains(routine.groupId);

      case RoutineAccessType.ByAllow:
        return routine.users != null && routine.users!.contains(_appState.authStatus!.id);

      case RoutineAccessType.ByDisallow:
        return routine.users == null || !routine.users!.contains(_appState.authStatus!.id);
    }
  }
}