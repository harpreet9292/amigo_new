import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/services/webapi/SettingsApi.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

class CommandsController extends ControllerBase
{
  final _api = $locator.get<SettingsApi>();
  final _settings = $locator.get<SettingsProvider>();
  final _appState = $locator.get<AppStateBridge>();
  final _connector = $locator.get<ApiConnector>();

  @override
  Future<bool> onServerState(Map<String, dynamic> state) async
  {
    if (state.containsKey(WebApiConfig.CommandsApiCat))
    {
      final cmds = state[WebApiConfig.CommandsApiCat] as List<MapEntry<String, dynamic>>;
      return await _processCommands(cmds);
    }

    return true;
  }

  Future<bool> _processCommands(List<MapEntry<String, dynamic>> cmds) async
  {
    for (final cmd in cmds)
    {
      try
      {
        final command = enumValueFromString<WebApiCommands?>(WebApiCommands.values, cmd.key);
        if (command != null)
        {
          switch (command)
          {
            case WebApiCommands.Message:
              _cmdMessage(cmd.value as String, alert: false);
              break;
            case WebApiCommands.Alert:
              _cmdMessage(cmd.value as String, alert: true);
              break;
            case WebApiCommands.Logout:
              _cmdLogout(quit: false);
              break;
            case WebApiCommands.Quit:
              _cmdLogout(quit: true);
              break;
            case WebApiCommands.SysLogout:
              // TODO: Handle this case.
              break;
            case WebApiCommands.InformUpgrade:
              // TODO: Handle this case.
              break;
            case WebApiCommands.RequireUpgrade:
              // TODO: Handle this case.
              break;
            case WebApiCommands.ReinitData:
              // TODO: Handle this case.
              break;
            case WebApiCommands.ClearData:
              // TODO: Handle this case.
              break;
          }
        }
        else
        {
          // todo: logs
        }
      }
      catch (e)
      {
        // todo: logs
      }
    }

    // todo
    return true;
  }

  void _cmdMessage(String text, {required bool alert})
  {
    // todo
  }

  void _cmdLogout({required bool quit})
  {
    _connector.logout();

    // todo: quit
  }
}