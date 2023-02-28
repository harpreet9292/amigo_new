import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/BackgroundApp.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/webapi/SettingsApi.dart';

class SettingsController extends ControllerBase
{
  final _api = $locator.get<SettingsApi>();
  final _settings = $locator.get<SettingsProvider>();
  final _bgapp = $locator.get<BackgroundApp>();

  @override
  Future<bool> onCleanData() async => await _updateFromServer(keys: null);

  @override
  Future<bool> onServerState(Map<String, dynamic> state) async
  {
    if (state.containsKey(WebApiConfig.SettingsApiCat))
    {
      final keys = state[WebApiConfig.SettingsApiCat] as List<String>?;
      return await _updateFromServer(keys: keys);
    }

    return true;
  }

  Future<bool> _updateFromServer({required List<String>? keys}) async
  {
    final items = await _api.fetchSettings(keys: keys);

    if (items != null && items.isNotEmpty)
    {
      _settings.setSilentMode(true);

      for (var key in items.keys)
      {
        _settings.setRaw(key, items[key]);
      }

      _settings.setSilentMode(false);

      _bgapp.reloadSettingsInUi();

      return true;
    }

    return false;
  }
}