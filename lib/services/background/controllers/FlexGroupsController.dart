import 'package:amigotools/entities/flexes/FlexGroup.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/FlexGroupsStorage.dart';
import 'package:amigotools/services/webapi/FlexGroupsApi.dart';

class FlexGroupsController extends ControllerBase
{
  final _helper = ControllerHelper<FlexGroup, FlexGroupsStorage>();
  final _api = $locator.get<FlexGroupsApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.GroupsApiCat,
        (ids) => _api.fetchGroups(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}