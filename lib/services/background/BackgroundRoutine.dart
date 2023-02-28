import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/config/services/BackgroundConfig.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/webapi/ServerStateApi.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/entities/rest/AuthStatus.dart';

class BackgroundRoutine extends ChangeNotifier
{
  final _settings = $locator.get<SettingsProvider>();
  final _appState = $locator.get<AppStateBridge>();
  final _stateApi = $locator.get<ServerStateApi>();

  final List<ControllerBase> _controllers = [];

  int? _stamp;
  AuthStatus? _authStatus;

  int? get _webApiStamp => _stamp;
  set _webApiStamp(int? val)
  {
    _stamp = val;
    _settings.set(SettingsKeys.CurrentWebApiStamp, _stamp);

    _appState.dataInitialized = _stamp != null;
  }

  Future<void> init() async
  {
    final val = _settings.get<int>(SettingsKeys.CurrentWebApiStamp);
    _stamp = val != 0 ? val : null;
    _appState.dataInitialized = _stamp != null;

    await _initControllers();

    _appState.addListener(_onAppStateChanged);
    _onAppStateChanged();

    print("AMG-BG: routine initialized");
  }

  Future<bool> requestUpdate() async
  {
    if (!_appState.dataInitialized)
    {
      if (!await _requestAllDataFromServer())
      {
        return false;
      }
    }

    return await _requestServerStateAndUpdate();
  }

  Future<void> _initControllers() async
  {
    for (final ctrlType in BackgroundConfig.controllers)
    {
      final ctrl = ctrlType(); // instantiating

      try
      {
        if (await ctrl.onServiceStart())
        {
          _controllers.add(ctrl);
        }
        else
        {
          print("AMG-BG: ignored $ctrl");
        }
      }
      catch (e)
      {
        print("AMG-BG-EXC in $ctrl.onServiceStart(): $e");
      }
    }
  }

  void _onAppStateChanged() async
  {
    // * do not compare by hashCode because of the bridge (AppState)
    if ((_authStatus != null) != (_appState.authStatus != null))
    {
      _authStatus = _appState.authStatus;

      for (final ctrl in _controllers)
      {
        try
        {
          await ctrl.onLoginChanged(_authStatus != null);
        }
        catch (e)
        {
          print("AMG-BG-EXC in $ctrl.onAuthChanged(): $e");
        }
      }
    }
  }

  Future<bool> _requestAllDataFromServer() async
  {
    if (_appState.isDataSync) return true;

    print("AMG-BG: starting data init");

    try
    {
      _appState.isDataSync = true;
      _appState.dataInitialized = false;

      final state = await _stateApi.getState(stamp: null);

      if (state != null)
      {
        for (final ctrl in _controllers)
        {
          try
          {
            await ctrl.onCleanData();
          }
          catch (e)
          {
            print("AMG-BG-EXC in $ctrl.onCleanData(): $e");
          }
        }

        _webApiStamp = state[WebApiConfig.StampKeyName] as int;
      }
      else
      {
        print("AMG-BG: getState() returned null");
        return false;
      }
    }
    catch (e)
    {
      print("AMG-BG-EXC in _requestAllDataFromServer(): $e");
      return false;
    }
    finally
    {
      _appState.isDataSync = false;
    }

    print("AMG-BG: data initialized");
    return true;
  }

  Future<bool> _requestServerStateAndUpdate() async
  {
    if (_appState.isDataSync) return true;

    if (_webApiStamp == null)
    {
      throw StateError("stamp should be initialized");
    }

    try
    {
      _appState.isDataSync = true;

      final state = await _stateApi.getState(stamp: _webApiStamp);

      if (state != null)
      {
        print("AMG-BG: got state with stamp #${state[WebApiConfig.StampKeyName]}");

        for (final ctrl in _controllers)
        {
          try
          {
            await ctrl.onServerState(state);
          }
          catch (e)
          {
            print("AMG-BG-EXC in $ctrl.onServerState(): $e");
          }
        }

        _webApiStamp = state[WebApiConfig.StampKeyName] as int;
      }
      else
      {
        print("AMG-BG: getState() returned null");
        return false;
      }
    }
    catch (e)
    {
      print("AMG-BG-EXC in _requestServerStateAndUpdate(): $e");
      return false;
    }
    finally
    {
      _appState.isDataSync = false;
    }

    return true;
  }
}