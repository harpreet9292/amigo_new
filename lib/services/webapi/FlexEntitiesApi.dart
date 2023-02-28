import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/entities/flexes/FlexEntity.dart';

class FlexEntitiesApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexEntity>?> fetchEntities({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexEntity>(
      await _connector.request(WebApiConfig.EntitiesApiCat, queryIds: ids),
      mapper: (item) => FlexEntity.fromJson(item),
    );
  }
}