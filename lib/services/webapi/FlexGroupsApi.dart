import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/entities/flexes/FlexGroup.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

class FlexGroupsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexGroup>?> fetchGroups({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexGroup>(
      await _connector.request(WebApiConfig.GroupsApiCat, queryIds: ids),
      mapper: (item) => FlexGroup.fromJson(item),
    );
  }
}