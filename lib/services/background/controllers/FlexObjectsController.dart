import 'package:amigotools/entities/flexes/FlexObject.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/services/webapi/FlexObjectsApi.dart';

class FlexObjectsController extends ControllerBase
{
  final _helper = ControllerHelper<FlexObject, FlexObjectsStorage>();
  final _api = $locator.get<FlexObjectsApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.ObjectsApiCat,
        (ids) => _api.fetchObjects(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}