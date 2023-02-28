import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/types/ViewModelStatus.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/core/routines/RoutinesManagerCoreModel.dart';
import 'package:amigotools/view_models/routines/RoutineModel.dart';

class RoutinesListModel extends ChangeNotifier
{
// #region Private

  final _manager = $locator.get<RoutinesManagerCoreModel>();

  ViewModelStatus _status = ViewModelStatus.Init;
  List<RoutineModel> _items = [];

// #endregion

// #region Public properties

  ViewModelStatus  get status
  {
    _loadAsync();
    return _status;
  }

  List<RoutineModel> get items 
  {
    _loadAsync();
    return _items;
  }

// #endregion

// #region Constructors and initializers

  RoutinesListModel()
  {
    _manager.addListener(forceReloadItems);
  }

  @override @mustCallSuper
  void dispose()
  {
    _status = ViewModelStatus.Gone;

    _manager.removeListener(forceReloadItems);
    super.dispose();
  }

  void forceReloadItems()
  {
    _status = ViewModelStatus.Init;
    _loadAsync();
  }

// #endregion

  void _loadAsync() async
  {
    if (_status != ViewModelStatus.Busy && _status != ViewModelStatus.Ready && _status != ViewModelStatus.Empty)
    {
      _status = ViewModelStatus.Busy;

      try
      {
        final items = _manager.routines.map((x) => RoutineModel(x));
        _items = items.toList();

        _status = _items.isNotEmpty ? ViewModelStatus.Ready : ViewModelStatus.Empty;
      }
      catch (e)
      {
        _status = ViewModelStatus.Error;
      }
      finally
      {
        if (_status != ViewModelStatus.Gone)
        {
          // hotfix. otherwise notifyListeners will be called in build method of a widget
          await Future.delayed(Duration(seconds: 0));

          notifyListeners();
        }
      }
    }
  }
}