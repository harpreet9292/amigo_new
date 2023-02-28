import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/background/BackgroundDispatcher.dart';
import 'package:amigotools/services/state/InfoProvider.dart';

class AppStateModel extends ChangeNotifier
{
  final _state = $locator.get<AppStateBridge>();
  final _background = $locator.get<BackgroundDispatcher>();
  final _connector = $locator.get<ApiConnector>();
  final _info = $locator.get<InfoProvider>();

  bool quiting = false;

  AppStateModel()
  {
    _state.addListener(notifyListeners);
  }

  GeneralState get generalState
  {
    if (quiting)
    {
      return GeneralState.Quiting;
    }
    else if (!_state.backgroundStarted)
    {
      return GeneralState.AppStarting;
    }
    else if (_state.sysKey == null || _state.consumerIdent == null)
    {
      return GeneralState.RequestSysLogin;
    }
    else if (_state.authStatus == null)
    {
      return GeneralState.RequestPin;
    }
    else if (!_state.dataInitialized)
    {
      return GeneralState.DataLoading;
    }
    else if (_state.authStatus != null)
    {
      return GeneralState.Normal;
    }

    return GeneralState.AppStarting;
  }

  String get appName => _info.appName;

  String get appVersion => _info.appVersion;

  String get loginTime => _state.loginTime != null ? DateFormat(DateFormat.HOUR_MINUTE).format(_state.loginTime!) : "";

  String get loginUserName => _state.authStatus?.name ?? "";

  bool get dataInitializating => !_state.dataInitialized && _state.isDataSync;

  void quitApp()
  {
    _background.stopService();

    quiting = true;
    notifyListeners();

    _connector.logout()
      .then((value) => exit(0))
      .timeout(Duration(seconds: 3));
  }
}

enum GeneralState
{
  AppStarting,
  RequestSysLogin,
  RequestPin,
  DataLoading,
  Normal,
  Quiting,
}