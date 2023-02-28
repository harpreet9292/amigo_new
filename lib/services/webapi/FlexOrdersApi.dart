import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/entities/flexes/FlexOrder.dart';

class FlexOrdersApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexOrder>?> fetchOrders({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexOrder>(
      await _connector.request(WebApiConfig.OrdersApiCat, queryIds: ids),
      mapper: (item) => FlexOrder.fromJson(item),
    );
  }

  Future<bool> changeOrder(
    FlexOrder order,
    {
      int? groupId,
      int? objectId,
      int? userId,
      FlexOrderState? state,
      Pair<String, dynamic>? field,
    }) async
  {
    final data = {};

    if (groupId != null)
      data["groupId"] = groupId;

    if (objectId != null)
      data["objectId"] = objectId;

    if (userId != null)
      data["userId"] = userId;

    if (state != null)
      data["state"] = enumValueToString(state);

    if (field != null)
      data["@" + field.item1] = field.item2;

    if (data.isEmpty)
      throw ArgumentError("At least one field to change should be filled.");

    return await _connector.request(
      "${WebApiConfig.OrderChangeApiPath}/${order.id}",
      postData: data,
    ) != null;
  }
}