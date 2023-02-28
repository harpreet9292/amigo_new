import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/entities/flexes/FlexObject.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

class FlexObjectsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexObject>?> fetchObjects({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexObject>(
      await _connector.request(WebApiConfig.ObjectsApiCat, queryIds: ids),
      mapper: (item) => FlexObject.fromJson(item),
    );
  }
}