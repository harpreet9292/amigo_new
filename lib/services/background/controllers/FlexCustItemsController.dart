import 'package:amigotools/entities/flexes/FlexCustItem.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/FlexCustItemsStorage.dart';
import 'package:amigotools/services/webapi/FlexCustItemsApi.dart';

class FlexCustItemsController extends ControllerBase
{
  final _helper = ControllerHelper<FlexCustItem, FlexCustItemsStorage>();
  final _api = $locator.get<FlexCustItemsApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.CustItemsApiCat,
        (ids) => _api.fetchCustItems(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}