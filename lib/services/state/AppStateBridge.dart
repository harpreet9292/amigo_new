import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/webapi/ApiConnectorState.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/entities/rest/AuthStatus.dart';

class AppStateBridge extends ChangeNotifier implements ApiConnectorState
{
  final _settings = $locator.get<SettingsProvider>();
  final _service = FlutterBackgroundService();
  late final StreamSubscription<Map<String, dynamic>?> _listener;

  Map<String, dynamic> _values = {};

  final bool backgroundChannel;

  AppStateBridge({required this.backgroundChannel})
  {
    _listener = _service.onDataReceived.listen(_onMessageReceived);

    if (backgroundChannel)
    {
      _initFromSettings();
    }
    else
    {
      _service.isServiceRunning().then((res)
      {
        if (res)
        {
          _service.sendData({"get_appstate": true});
        }
      });
    }
  }

  @override
  void dispose()
  {
    _listener.cancel();
    super.dispose();
  }

  void _initFromSettings()
  {
    sysKey = _settings.get<String?>(SettingsKeys.SystemKey);
    consumerIdent = _settings.get<String?>(SettingsKeys.ConsumerIdent);
  }

  void _onMessageReceived(Map<String, dynamic>? msg)
  {
    if (msg == null) return;

    if (msg.containsKey("appstate"))
    {
      _values = msg["appstate"];
      notifyListeners();
    }
    else if (msg.containsKey("get_appstate"))
    {
      _service.sendData({"appstate": _values});
    }
  }

  bool get backgroundStarted => _values["bgStart"] ?? false;
  set backgroundStarted(bool val) => _set("bgStart", val);

  bool get dataInitialized => _values["dataInit"] ?? false;
  set dataInitialized(bool val) => _set("dataInit", val);

  @override
  String? get consumerIdent => _values["consIdent"];
  @override
  set consumerIdent(String? val) => _set("consIdent", val, SettingsKeys.ConsumerIdent);

  @override
  String? get sysKey => _values["sysKey"];
  @override
  set sysKey(String? val) => _set("sysKey", val, SettingsKeys.SystemKey);

  @override
  AuthStatus? get authStatus => _values["authStatus"] != null ? AuthStatus.fromJson(_values["authStatus"]) : null;
  @override
  set authStatus(AuthStatus? val) => _set("authStatus", val?.toJson());

  @override
  String? get pinMd5 => _values["pinMd5"];
  @override
  set pinMd5(String? val) => _set("pinMd5", val);

  DateTime? get loginTime => _values["loginTime"] != null ? DateTime.parse(_values["loginTime"]) : null;
  set loginTime(DateTime? val) => _set("loginTime", dateTimeToIsoDateTime(val));

  bool get isDataSync => _values["isDataSync"] ?? false;
  set isDataSync(bool val) => _set("isDataSync", val);

  int? get currentRoutine => _values["currRoutine"];
  set currentRoutine(int? id) => _set("currRoutine", id, SettingsKeys.CurrentRoutine);

  void _set(String key, dynamic val, [SettingsKeys? skey])
  {
    if (_values[key] != val)
    {
      _values[key] = val;
      _service.sendData({"appstate": _values});
      notifyListeners();

      if (skey != null)
      {
        _settings.set(skey, val);
      }
    }
  }
}