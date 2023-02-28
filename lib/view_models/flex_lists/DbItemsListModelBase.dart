import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';

abstract class DbItemsListModelBase<TStorage extends StorageBase> extends ChangeNotifier
{
  final _appState = $locator.get<AppStateBridge>();

  String? _authUserRole;
  List<int>? _allowedGroupIds;
  bool _mounted = true;
  bool _busy = false;
  bool _loaded = false;
  List<BriefDbItem> _items = [];
  String _searchString = "";

  @protected
  final itemsStorage = $locator.get<TStorage>();

  DbItemsListModelBase()
  {
    itemsStorage.addListener(forceReloadItems);
    _appState.addListener(_onStateChanged);
    _onStateChanged();
  }

  @mustCallSuper
  @override
  void dispose()
  {
    itemsStorage.removeListener(forceReloadItems);
    _appState.removeListener(_onStateChanged);

    super.dispose();
    _mounted = false;
  }

  @protected
  String? get authUserRole => _authUserRole;

  @protected
  List<int> get allowedGroupIds => _allowedGroupIds ?? [0];

  String get title => "";

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

  String get searchString => _searchString;
  set searchString(String str)
  {
    if (searchString != str)
    {
      _searchString = str;
      forceReloadItems();
    }
  }

  void forceReloadItems()
  {
    _loaded = false;
    _loadAsync();
  }

  @protected // abstract
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal();

  void _onStateChanged()
  {
    if (_authUserRole != _appState.authStatus?.role
      || _allowedGroupIds != _appState.authStatus?.groups)
    {
      _authUserRole = _appState.authStatus?.role;
      _allowedGroupIds = _appState.authStatus?.groups;
      notifyListeners();
    }
  }

  void _loadAsync() async
  {
    if (!_loaded && !_busy)
    {
      _busy = true;

      try
      {
        final items = await fetchBriefItemsInternal();
        _items = items.toList();

        _loaded = true;
      }
      finally
      {
        _busy = false;
        
        if (_loaded && _mounted)
          notifyListeners();
      }
    }
  }
}