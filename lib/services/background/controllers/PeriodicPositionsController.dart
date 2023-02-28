import 'dart:async';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/geopos/GeoLocationProvider.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/webapi/UsersApi.dart';

class PeriodicPositionsController extends ControllerBase
{
  final _state = $locator.get<AppStateBridge>();
  final _settings = $locator.get<SettingsProvider>();
  final _location = $locator.get<GeoLocationProvider>();
  final _api = $locator.get<UsersApi>();

  int? _periodicGeoPosMinutes;
  Timer? _timer;

  @override
  Future<bool> onServiceStart() async
  {
    _init();
    _settings.addListener(_init);
    return true;
  }

  void _init()
  {
    var mins = _settings.get<int>(SettingsKeys.PeriodicGeoPosMinutes);

    if (_periodicGeoPosMinutes != mins)
    {
      _periodicGeoPosMinutes = mins;

      if (_timer != null)
      {
        _timer!.cancel();
      }

      if (_periodicGeoPosMinutes != 0)
      {
        _timer = Timer.periodic(Duration(minutes: _periodicGeoPosMinutes!), _onTimer);
        _onTimer(_timer!);
      }
    }
  }

  void _onTimer(Timer timer) async
  {
    if (_state.authStatus != null)
    {
      final pos = await _location.getPosition();

      if (pos != null)
      {
        if (await _api.sendPosition(pos))
        {
          print("AMG-BG: sent periodic position");
        }
        else
        {
          print("AMG-BG: could not send periodic position");
        }
      }
      else
      {
        print("AMG-BG: could not get periodic position");
      }
    }
  }
}