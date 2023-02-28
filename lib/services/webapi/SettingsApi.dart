import 'dart:convert';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

class SettingsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Map<String, dynamic>?> fetchSettings({List<String>? keys}) async
  {
    final params = keys != null ? {"keys": keys.join(',')} : null;
    final resp = await _connector.request(WebApiConfig.SettingsApiCat, queryParams: params);
    return resp != null ? jsonDecode(resp) : null;
  }
}