import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/RoutineTasksStorage.dart';
import 'package:amigotools/entities/routines/Routine.dart';
import 'package:amigotools/entities/routines/RoutineTask.dart';

class RoutineCoreModel extends ChangeNotifier
{
  final _tasksStorage = $locator.get<RoutineTasksStorage>();

  bool _mounted = true;
  List<RoutineTask> _tasks = [];

  final Routine item;

  List<RoutineTask> get tasks => _tasks;

  RoutineCoreModel(this.item)
  {
    _tasksStorage.addListener(loadTasks);
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _mounted = false;
    _tasksStorage.removeListener(loadTasks);
    super.dispose();
  }

  Future loadTasks() async
  {
    final items = await _tasksStorage.fetch(routineId: item.id);

    _tasks = items.toList();

    if (_mounted)
      notifyListeners();
  }

  Set<int> getObjectIds()
  {
    return _tasks
      .map((x) => x.objectId)
      .toSet();
  }

  Set<int> getWorkflowIds()
  {
    return _tasks
      .where((x) => x.workflowId != null)
      .map((x) => x.workflowId!)
      .toSet();
  }
}