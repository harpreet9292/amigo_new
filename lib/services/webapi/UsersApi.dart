import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/entities/rest/GeoPosition.dart';
import 'package:amigotools/entities/rest/User.dart';

class UsersApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<User>?> fetchUsers({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<User>(
      await _connector.request(WebApiConfig.UsersApiCat, queryIds: ids),
      mapper: (item) => User.fromJson(item),
    );
  }

  Future<bool> sendPosition(GeoPosition pos) async
  {
    return await _connector.request(
      WebApiConfig.UserPositionApiPath,
      postData: pos,
    ) != null;
  }
}