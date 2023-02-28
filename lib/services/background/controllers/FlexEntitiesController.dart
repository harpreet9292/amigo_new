import 'package:amigotools/entities/flexes/FlexEntity.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/services/webapi/FlexEntitiesApi.dart';

class FlexEntitiesController extends ControllerBase
{
  final _helper = ControllerHelper<FlexEntity, FlexEntitiesStorage>();
  final _api = $locator.get<FlexEntitiesApi>();

  // todo: manage saved outcomes and other according to deleted/changed entities

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.EntitiesApiCat,
        (ids) => _api.fetchEntities(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}