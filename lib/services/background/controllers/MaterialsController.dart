import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/entities/rest/Material.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/MaterialsStorage.dart';
import 'package:amigotools/services/webapi/MaterialsApi.dart';

class MaterialsController extends ControllerBase
{
  final _helper = ControllerHelper<Material, MaterialsStorage>();
  final _api = $locator.get<MaterialsApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.MaterialsApiCat,
        (ids) => _api.fetchMaterials(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}