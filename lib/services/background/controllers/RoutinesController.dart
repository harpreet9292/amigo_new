import 'package:amigotools/entities/routines/Routine.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/background/helpers/ControllerHelper.dart';
import 'package:amigotools/services/storage/RoutinesStorage.dart';
import 'package:amigotools/services/webapi/RoutinesApi.dart';

class RoutinesController extends ControllerBase
{
  final _helper = ControllerHelper<Routine, RoutinesStorage>();
  final _api = $locator.get<RoutinesApi>();

  @override
  Future<bool> onServiceStart() => _helper.init(
        WebApiConfig.RoutinesApiCat,
        (ids) => _api.fetchRoutines(ids: ids),
      );

  @override
  Future<bool> onCleanData() => _helper.onCleanData();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) =>
      _helper.onServerState(state);
}