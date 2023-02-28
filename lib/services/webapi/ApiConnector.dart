import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:path/path.dart' as path;

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/webapi/ApiConnectorState.dart';
import 'package:amigotools/entities/rest/AuthStatus.dart';
import 'package:amigotools/utils/data/CryptoHelper.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/state/InfoProvider.dart';

class ApiConnector extends ChangeNotifier
{
  late final http.Client _client;
  final ApiConnectorState _state;
  final _settings = $locator.get<SettingsProvider>();
  final _info = $locator.get<InfoProvider>();

  String? _useIdent;
  Uri? _baseUri;

  ApiConnector(ApiConnectorState state, {http.Client? client})
    : _state = state
  {
    if (client == null)
    {
      final httpClient = HttpClient()..connectionTimeout = Duration(seconds: WebApiConfig.TimeoutSec);
      _client = IOClient(httpClient);
    }
    else
    {
      _client = client;
    }

    _settings.addListener(_onSettingsChange);
  }

  @override
  void dispose()
  {
    _settings.removeListener(_onSettingsChange);
    super.dispose();
  }

  bool get isAuthenticated => _state.authStatus != null;

  Uri get baseUri
  {
    if (_baseUri == null)
    {
      var baseUrl = _settings.get<String>(SettingsKeys.MainApiUrlTpl);
      final ident = _useIdent ?? _state.consumerIdent;

      if (ident != null)
        baseUrl = baseUrl.replaceAll("[ident]", ident);

      _baseUri = Uri.parse(baseUrl);
    }

    return _baseUri!;
  }

  void useIdentOrFromSettings(String? ident)
  {
    _useIdent = ident;
    _baseUri = null;
  }

  Future<bool> login(String pin) async
  {
    if (isAuthenticated)
    {
      // relogin even if same pin
      await logout(silent: true);
    }

    _state.pinMd5 = generateMd5(pin);

    return await _loginRequest();
  }

  Future<void> logout({bool silent = false}) async
  {
    if (!isAuthenticated)
    {
      _state.pinMd5 = null;
      return;
    }

    await request(WebApiConfig.LogoutApiPath, authIfLost: false);

    _state.pinMd5 = null;
    _state.authStatus = null;

    if (!silent)
      notifyListeners();
  }

  Future<String?> request(String urlPath,
    {List<int>? queryIds, Map<String, dynamic>? queryParams, dynamic postData, bool authIfLost = true}) async
  {
    final query = queryParams != null ? queryParams : <String, dynamic>{};

    if (_state.authStatus != null)
    {
      query["s"] = _state.authStatus!.sessionKey;
    }

    if (queryIds != null)
    {
      query["ids"] = queryIds.join(',');
    }

    final uri = _createUri(urlPath, query);

    final http.Response resp;

    try
    {
      if (postData == null)
      {
        print("AMG-API: get $uri");
        resp = await _client.get(uri);
      }
      else
      {
        if (!(postData is String))
        {
          postData = jsonEncode(postData);
        }

        print("AMG-API: post $uri");
        resp = await _client.post(uri, body: postData, headers: {"Content-Type": "application/json"});
      }

      if (resp.statusCode == HttpStatus.ok)
      {
        print("AMG-API: OK for $urlPath with content ${resp.body.length} bytes");
        return resp.body;
      }
      else if (resp.statusCode == HttpStatus.unauthorized)
      {
        if (authIfLost && await _loginRequest())
        {
          print("AMG-API: one more request for $urlPath");

          // the second attempt
          return await request(urlPath, queryIds: queryIds, postData: postData, authIfLost: false);
        }
      }
      else
      {
        // todo
      	print('Failed to do request ${uri.origin}, status code = ${resp.statusCode}');
      }
    }
    on SocketException catch (e)
    {
      print (e);
    }

    return null;
  }

  Future<bool> upload(String urlPath, {required File file, bool authIfLost = true}) async
  {
    if (_state.authStatus == null) return false;

    final query = <String, dynamic>{};

    if (_state.authStatus != null)
    {
      query["s"] = _state.authStatus!.sessionKey;
    }

    final uri = _createUri(urlPath, query);

    print("AMG-API: upload to $uri");

    var request = new http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile(
        'file',
        file.openRead(),
        await file.length(),
        filename: path.basename(file.path),
    ));

    final resp = await request.send();

    if (resp.statusCode == HttpStatus.ok)
    {
      return true;
    }
    else if (resp.statusCode == HttpStatus.unauthorized)
    {
      if (authIfLost && await _loginRequest())
      {
        // the second attempt
        return await upload(urlPath, file: file, authIfLost: false);
      }
    }
    else
    {
      // todo
      print('Failed to do request ${uri.origin}, status code = ${resp.statusCode}');
    }

    return false;
  }

  Uri _createUri(String urlPath, Map<String, dynamic> params)
  {
    return Uri(
        scheme: baseUri.scheme,
        host: baseUri.authority,
        path: path.join(baseUri.path, urlPath),
        queryParameters: params,
      );
  }

  Future<bool> _loginRequest() async
  {
    if (_state.pinMd5 == null) return false;

    print("AMG-API: login with PIN ${_state.pinMd5}");

    final query = <String, dynamic>{
      "pin": _state.pinMd5,
      "syskey": _state.sysKey,
      "devid": _info.uuid,
      "devname": _info.deviceName,
      "osver": _info.osVersion,
      "appver": _info.appVersion,
      "api": WebApiConfig.ApiVersion.toString(),
    };

    final uri = _createUri(
      WebApiConfig.LoginApiPath,
      query,
    );

    try
    {
      final resp = await _client.get(uri);

      if (resp.statusCode == HttpStatus.ok)
      {
        final status = AuthStatus.fromJson(jsonDecode(resp.body));

        if (_state.authStatus == null)
        {
          _state.authStatus = status;
          notifyListeners();
        }
        else
        {
          _state.authStatus = status;
        }
        
        return true;
      }
      else if (resp.statusCode == HttpStatus.unauthorized)
      {
        if (_state.authStatus != null)
        {
          _state.authStatus = null;
          notifyListeners();
        }
        return false;
      }
      else
      {
        // todo
        print('Login request failed, status code = ${resp.statusCode}');
      }
    }
    on SocketException catch (e)
    {
      print (e);
    }

    return false;
  }

  void _onSettingsChange()
  {
    _baseUri = null;
  }
}