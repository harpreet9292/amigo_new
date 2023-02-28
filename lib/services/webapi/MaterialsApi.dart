import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/entities/rest/Material.dart';

class MaterialsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<Material>?> fetchMaterials({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<Material>(
      await _connector.request(WebApiConfig.MaterialsApiCat, queryIds: ids),
      mapper: (item) => Material.fromJson(item),
    );
  }
}