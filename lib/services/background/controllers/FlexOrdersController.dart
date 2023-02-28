import 'package:amigotools/entities/flexes/FlexOrder.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/FlexOrdersStorage.dart';
import 'package:amigotools/services/webapi/FlexOrdersApi.dart';

class FlexOrdersController extends ControllerBase
{
  final _helper = ControllerHelper<FlexOrder, FlexOrdersStorage>();
  final _api = $locator.get<FlexOrdersApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.OrdersApiCat,
        (ids) => _api.fetchOrders(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}