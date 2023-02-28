import 'package:amigotools/entities/rest/User.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/UsersStorage.dart';
import 'package:amigotools/services/webapi/UsersApi.dart';

class UsersController extends ControllerBase
{
  final _helper = ControllerHelper<User, UsersStorage>();
  final _api = $locator.get<UsersApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.UsersApiCat,
        (ids) => _api.fetchUsers(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}