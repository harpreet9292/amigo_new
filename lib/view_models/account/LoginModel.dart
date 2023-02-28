import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

class LoginModel extends ChangeNotifier
{
  final _connector = $locator.get<ApiConnector>();
  final _appState = $locator.get<AppStateBridge>();

  bool _mounted = true;
  bool _communicating = false;
  bool _loginError = false;

  LoginModel()
  {
    _connector.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _connector.removeListener(notifyListeners);
    super.dispose();
    _mounted = false;
  }

  bool get communicating => _communicating;
  bool get loginError => _loginError;

  bool get loginOk => _appState.authStatus != null;

  int get remainingAttempts => 5; // todo

  void loginWithPin(String pin) async
  {
    _communicating = true;
    _loginError = false;
    notifyListeners();

    try
    {
      if (!await _connector.login(pin))
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

  void logout()
  {
    _connector.logout();
  }
}