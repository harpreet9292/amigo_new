import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitsManagerCoreModel.dart';

class ObjectVisitsListModel extends ChangeNotifier
{
  final _manager = $locator.get<ObjectVisitsManagerCoreModel>();
  
  bool _mounted = true;
  bool _busy = false;
  bool _loaded = false;
  List<BriefDbItem> _items = [];

  ObjectVisitsListModel()
  {
    _manager.addListener(forceReloadItems);
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _manager.removeListener(forceReloadItems);

    super.dispose();
    _mounted = false;
  }

  bool get isBusy => _busy;

  bool get isLoaded
  {
    _loadAsync();
    return _loaded;
  }

  bool get isEmpty
  {
    _loadAsync();
    return _items.isEmpty;
  }

  List<BriefDbItem> get items 
  {
    _loadAsync();
    return _items;
  }

  void forceReloadItems()
  {
    _loaded = false;
    _loadAsync();
  }

  void _loadAsync() async
  {
    if (!_loaded && !_busy)
    {
      _busy = true;

      try
      {
        _items = _manager.startedObjectVisits.map(
          (x) => BriefDbItem(
              id: x.id,
              title: x.object?.title ?? "#${x.objectId}",
              subtitle: x.paused ? "Paused" : "Active"),
        ).toList();

        _loaded = true;
      }
      finally
      {
        _busy = false;
        
        if (_loaded && _mounted)
        {
          // hotfix. otherwise notifyListeners will be called in build method of a widget
          await Future.delayed(Duration(seconds: 0));

          notifyListeners();
        }
      }
    }
  }
}