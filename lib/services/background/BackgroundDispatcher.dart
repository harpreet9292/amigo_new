import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:restart_app/restart_app.dart';

import 'package:amigotools/config/services/BackgroundConfig.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';

class BackgroundDispatcher extends ChangeNotifier
{
  final _channel = FlutterBackgroundService();
  final _settings = $locator.get<SettingsProvider>();

  late final StreamSubscription<Map<String, dynamic>?> _listener;

  late Timer _checkerTimer;

  BackgroundDispatcher()
  {
    _listener = _channel.onDataReceived.listen(_onChannelEventReceived);
    _scheduleBackgroundCheckerTimer();
  }

  @override
  void dispose()
  {
    _checkerTimer.cancel();
    _listener.cancel();
    super.dispose();
  }

  void _onChannelEventReceived(Map<String, dynamic>? event)
  {
    if (event == null) return;

    switch (event[BackgroundConfig.ActionEventName])
    {
      case BackgroundActions.UiPing:
        _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.UiPong});
        break;

      case BackgroundActions.ReloadSettings:
        _settings.reload();
        break;
    }
  }

  void _scheduleBackgroundCheckerTimer()
  {
    // it's possible mainly in logout period (see UiPing)

    _checkerTimer = Timer.periodic(Duration(seconds: BackgroundConfig.CheckBackgroundSec), (timer) async
    {
      if (!(await _channel.isServiceRunning()))
      {
        Restart.restartApp();
      }
    });
  }

  void stopService() => _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.StopBackground});

  void forceRequestServerState() => _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.ForceServerState});

  void reloadSettingsInBackground() => _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.ReloadSettings});
}