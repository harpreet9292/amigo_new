import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/BackgroundConfig.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/background/BackgroundRoutine.dart';

class BackgroundApp
{
  final _channel = FlutterBackgroundService();
  final _appState = $locator.get<AppStateBridge>();
  final _settings = $locator.get<SettingsProvider>();
  final _routine = BackgroundRoutine();

  Timer? _uiPingTimer;
  bool _uiPong = false;
  bool _isLoggedIn = false;

  void run() async
  {
    _channel.onDataReceived.listen(_onChannelEventReceived);
    _appState.addListener(_onAppStateChanged);

    _channel.setForegroundMode(true);

    _onStart();
  }

  void _onStart() async
  {
    print("AMG-BG: starting...");

    _updateNotificationInfo();

    await _routine.init();

    _onAppStateChanged();

    _scheduleDataUpdateTimer();

    _scheduleUiPingTimer(enable: true);

    print("AMG-BG: started");

    _appState.backgroundStarted = true;
  }

  void _onChannelEventReceived(Map<String, dynamic>? event)
  {
    if (event == null) return;

    switch (event[BackgroundConfig.ActionEventName])
    {
      case BackgroundActions.UiPong:
        _uiPong = true;
        break;

      case BackgroundActions.StopBackground:
        _channel.stopBackgroundService();
        break;

      case BackgroundActions.ForceServerState:
        if (_isLoggedIn)
          _routine.requestUpdate();
        break;

      case BackgroundActions.ReloadSettings:
        _settings.reload();
        break;
    }
  }

  void reloadSettingsInUi() => _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.ReloadSettings});

  void _onAppStateChanged()
  {
    final newLoginState = _appState.authStatus != null;

    if (_isLoggedIn != newLoginState)
    {
      _isLoggedIn = newLoginState;

      if (_isLoggedIn)
      {
        _appState.loginTime = DateTime.now();
      }
      else
      {
        _appState.loginTime = null;
      }

      _onUserLoginStateChanged();
    }

    _updateNotificationInfo();
  }

  void _onUserLoginStateChanged()
  {
    if (_isLoggedIn)
    {
      print("AMG-BG: user login");

      _routine.requestUpdate();
      _scheduleUiPingTimer(enable: false);
    }
    else
    {
      print("AMG-BG: user logout");
      _scheduleUiPingTimer(enable: true);
    }
  }

  void _scheduleDataUpdateTimer()
  {
    Timer.periodic(Duration(seconds: BackgroundConfig.PeriodicRequestServerUpdateSec), (timer) async
    {
      if (!(await _channel.isServiceRunning()))
        timer.cancel();

      if (_isLoggedIn)
        await _routine.requestUpdate();
    });
  }

  void _scheduleUiPingTimer({required bool enable})
  {
    final nowEnabled = _uiPingTimer != null;

    if (nowEnabled != enable)
    {
      if (enable)
      {
        _uiPong = true;

        // too small duration (<=1sec) may be cause of unexpected stop of background
        _uiPingTimer = Timer.periodic(Duration(seconds: BackgroundConfig.PingUiChannelSec), (timer) async
        {
          if (!(await _channel.isServiceRunning()))
            timer.cancel();

          if (!_uiPong)
          {
            timer.cancel();
            _channel.stopBackgroundService();
            return;
          }

          _uiPong = false;
          _channel.sendData({BackgroundConfig.ActionEventName: BackgroundActions.UiPing});
        });
      }
      else
      {
        _uiPingTimer!.cancel();
        _uiPingTimer = null;
      }
    }
  }

  void _updateNotificationInfo()
  {
    var title = GeneralConfig.DefaultAppName;
   
    final consumer = _settings.get<String>(SettingsKeys.ConsumerName);
    if (consumer.isNotEmpty)
    {
      title += " ($consumer)";
    }

    var subtitle = _isLoggedIn ? "Logged in" : "Logged out";
    if (_appState.isDataSync)
    {
      subtitle += " (communicating...)";
    }

    _channel.setNotificationInfo(
      title: title,
      content: subtitle,
    );
  }
}