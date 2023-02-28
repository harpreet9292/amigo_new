import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/entities/flexes/FlexCustItem.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

class FlexCustItemsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexCustItem>?> fetchCustItems({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexCustItem>(
      await _connector.request(WebApiConfig.CustItemsApiCat, queryIds: ids),
      mapper: (item) => FlexCustItem.fromJson(item),
    );
  }
}