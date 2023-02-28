import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/storage/FlexOrdersStorage.dart';
import 'package:amigotools/entities/flexes/FlexOrder.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/utils/types/ViewModelItem.dart';

class OrdersListModel extends DbItemsListModelBase<FlexOrdersStorage>
{
  final _entitiesStorage = $locator.get<FlexEntitiesStorage>();
  final _appState = $locator.get<AppStateBridge>();
  final _settings = $locator.get<SettingsProvider>();

  final FlexOrderState? state;

  OrdersListModel({this.state})
  {
    _settings.addListener(notifyListeners);
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _settings.removeListener(notifyListeners);
    super.dispose();
  }

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    await _entitiesStorage.ensureFilledCache();

    return await itemsStorage.fetchBrief(
      state: state,
      groupIds: allowedGroupIds,
      search: searchString.isNotEmpty ? searchString : null,
      solveIdent: (ident) => ident is String ? _entitiesStorage.getCachedBriefItem(ident)?.title : null,
    );
  }

  Iterable<ViewModelItem> getItemsForGroupType(OrderGroupType groupType)
  {
    final userid = _appState.authStatus!.id;

    Iterable<BriefDbItem> out;

    switch (groupType)
    {
      case OrderGroupType.Assigned:
        out = items.where((x) => x.extra == userid);
        break;

      case OrderGroupType.Available:
        out = items.where((x) => x.extra == null);
        break;

      case OrderGroupType.Others:
        final allowOthers = _settings.get<bool>(SettingsKeys.ShowOrdersOfOthers);
        
        if (allowOthers)
        {
          out = items.where((x) => x.extra != null && x.extra != userid);
        }
        else
        {
          out = [];
        }
        break;
    }
  
    return out.map((x) => ViewModelItem(
          key: x.id,
          title: "${x.ident} #${x.id}",
          subtitle1: x.subtitle,
          subtitle2: x.title,
        ));
  }
}

enum OrderGroupType
{
  Assigned,
  Available,
  Others,
}