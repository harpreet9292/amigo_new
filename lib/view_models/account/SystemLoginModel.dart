import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/state/InfoProvider.dart';
import 'package:amigotools/services/webapi/AuthApi.dart';

class SystemLoginModel extends ChangeNotifier
{
  final _api = $locator.get<AuthApi>();
  final _appState = $locator.get<AppStateBridge>();
  final _info = $locator.get<InfoProvider>();

  bool _mounted = true;
  bool _communicating = false;
  bool _loginError = false;

  bool get communicating => _communicating;
  bool get loginError => _loginError;

  int get remainingAttempts => 5; // todo

  void login({required String ident, required String pass}) async
  {
    _communicating = true;
    _loginError = false;
    notifyListeners();

    try
    {
      final res = await _api.sysLogin(
        ident: ident,
        pass: pass,
        devid: _info.uuid,
        devname: _info.deviceName,
      );

      if (res != null)
      {
        _appState.consumerIdent = ident;
        _appState.sysKey = res;
      }
      else
      {
        _loginError = true;
      }
    }
    finally
    {
      _communicating = false;
      
      if (_mounted)
        notifyListeners();
    }
  }
}