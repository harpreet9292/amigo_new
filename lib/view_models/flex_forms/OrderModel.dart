import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/entities/flexes/FlexOrder.dart';
import 'package:amigotools/services/webapi/FlexOrdersApi.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/background/BackgroundDispatcher.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/services/storage/FlexOrdersStorage.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/OutcomeModel.dart';
import 'package:amigotools/services/storage/FlexOutcomesStorage.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';

import 'FlexItemModelBase.dart';

class OrderModel extends FlexItemModelBase<FlexOrdersStorage>
{
  final _state = $locator.get<AppStateBridge>();
  final _settings = $locator.get<SettingsProvider>();
  final _api = $locator.get<FlexOrdersApi>();
  final _dispatcher = $locator.get<BackgroundDispatcher>();
  final _outcomesStorage = $locator.get<FlexOutcomesStorage>();

  BriefDbItem? _relatedOutcome;

  OrderModel.open(int itemId)
    : super.open(itemId, edit: false)
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
  Future<FlexItemBase?> fetchItemInternal(int id) async
  {
    final items = await itemsStorage.fetch(id: id);
    final order =  items.isNotEmpty ? items.first : null;

    final outcomes = await _outcomesStorage.fetchBrief(orderId: id);
    _relatedOutcome = outcomes.isNotEmpty ? outcomes.first : null;

    return order;
  }

  @override @protected
  dynamic getValueInternal(String fieldIdent)
  {
    switch (fieldIdent)
    {
      case "\$object":
        return (flexItemInternal as FlexOrder).objectId;

      case "\$assigned":
        return (flexItemInternal as FlexOrder).userId;

      case "\$\$state":
        return enumValueToString((flexItemInternal as FlexOrder).state);

      default:
        return super.getValueInternal(fieldIdent);
    }
  }

  bool get isAssignedToUs => flexItemInternal != null && (flexItemInternal as FlexOrder).userId == _state.authStatus!.id;

  bool get canTakeOrder => flexItemInternal != null && (flexItemInternal as FlexOrder).userId == null;
  bool get canRefuseOrder => isAssignedToUs && _relatedOutcome == null && _settings.get<bool>(SettingsKeys.AllowRefuseOrder);
  bool get canCloseOrder => isAssignedToUs && _relatedOutcome == null && _settings.get<bool>(SettingsKeys.AllowCloseOrder);
  bool get canCreateOutcome => isAssignedToUs && _relatedOutcome == null && _settings.get<bool>(SettingsKeys.AllowOutcomeOfOrder);
  bool get canEditOutcome => isAssignedToUs && _relatedOutcome != null;

  Future<void> takeOrder() async
  {
    final order = flexItemInternal as FlexOrder;

    if (await _api.changeOrder(order, userId: _state.authStatus!.id))
      _dispatcher.forceRequestServerState();
  }

  Future<void> refuseOrder() async
  {
    final order = flexItemInternal as FlexOrder;

    if (await _api.changeOrder(order, userId: 0))
      _dispatcher.forceRequestServerState();
  }

  Future<void> closeOrder() async
  {
    final order = flexItemInternal as FlexOrder;
  
    if (await _api.changeOrder(order, state: FlexOrderState.Closed))
      _dispatcher.forceRequestServerState();
  }

  OutcomeModel? createOutcome()
  {
    if (_relatedOutcome != null) return null;

    final fieldVals = Map<String, dynamic>.fromIterable(
      fields.where((x) => x.hasNotEmptyValue),
      key: (x) => (x as FlexFieldModel).ident,
      value: (x) => (x as FlexFieldModel).value,
    );

    fieldVals["\$order"] = itemId;

    return OutcomeModel.create(entityIdent, initialVals: fieldVals);
  }

  OutcomeModel? getOutcomeToEdit()
  {
    return _relatedOutcome != null ? OutcomeModel.open(_relatedOutcome!.id, edit: true) : null;
  }
}