import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/types/ViewModelStatus.dart';
import 'package:amigotools/services/core/routines/RoutineCoreModel.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/entities/routines/RoutineTask.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/view_models/routines/RoutineTaskModel.dart';

class RoutineTasksListModel extends ChangeNotifier
{
// #region Private

  final _objectsStrorage = $locator.get<FlexObjectsStorage>();
  final RoutineCoreModel _coreModel;

  ViewModelStatus _status = ViewModelStatus.Init;
  List<RoutineTaskModel> _items = [];
  String _searchString = "";

// #endregion

// #region Public properties

  ViewModelStatus  get status
  {
    _loadAsync();
    return _status;
  }

  List<RoutineTaskModel> get items 
  {
    _loadAsync();
    return _items;
  }

  String get searchString => _searchString;
  set searchString(String str)
  {
    if (searchString != str)
    {
      _searchString = str;
      forceReloadItems();
    }
  }

// #endregion

// #region Constructors and initializers

  RoutineTasksListModel(this._coreModel)
  {
    _coreModel.addListener(forceReloadItems);
    _objectsStrorage.addListener(forceReloadItems);
  }

  @override @mustCallSuper
  void dispose()
  {
    _status = ViewModelStatus.Gone;

    _coreModel.removeListener(forceReloadItems);
    _objectsStrorage.removeListener(forceReloadItems);
    super.dispose();
  }

  void forceReloadItems()
  {
    _status = ViewModelStatus.Init;
    _loadAsync();
  }

// #endregion

// #region Public methods

  List<BriefDbItem> getAvailableGroups() =>
    RoutineTaskGroupTypeModel.values
      .map((x) => BriefDbItem(id: x.index, title: enumValueToString(x)!))
      .toList();

  Iterable<RoutineTaskModel> getItemsForGroup(BriefDbItem group)
  {
    final type = RoutineTaskGroupTypeModel.values[group.id];
    return items.where((x) => x.groupType == type);
  }

// #endregion

// #region Private

  void _loadAsync() async
  {
    if (_status != ViewModelStatus.Busy && _status != ViewModelStatus.Ready && _status != ViewModelStatus.Empty)
    {
      _status = ViewModelStatus.Busy;

      try
      {
        final tasks = _coreModel.tasks.where((x) => x.status != RoutineTaskStatus.Completed);

        final ids = _coreModel.getObjectIds().toList();
        final objects = await _objectsStrorage.fetch(ids: ids);
        final hash = Map.fromIterable(objects, key: (k) => k.id, value: (v) => v);

        var models = tasks
          .where((x) => hash.containsKey(x.objectId))
          .map((x) => RoutineTaskModel(x, hash[x.objectId]));

        if (_searchString.isNotEmpty)
        {
          final search = _searchString.toLowerCase();

          models = models.where((x) =>
            x.objectId.toString() == search ||
            x.object.toLowerCase().contains(search) ||
            (x.workflow != null && x.workflow!.toLowerCase().contains(search)) ||
            (x.period != null && x.period!.toLowerCase().contains(search))
          );
        }

        _items = models.toList();

        _status = _items.isNotEmpty ? ViewModelStatus.Ready : ViewModelStatus.Empty;
      }
      catch (e)
      {
        _status = ViewModelStatus.Error;
      }
      finally
      {
        if (_status != ViewModelStatus.Gone)
          notifyListeners();
      }
    }
  }

// #endregion
}