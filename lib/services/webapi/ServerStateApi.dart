import 'dart:convert';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

class ServerStateApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Map<String, dynamic>?> getState({required int? stamp}) async
  {
    final resp = await _connector.request("${WebApiConfig.ServerStateApiPath}/${stamp ?? ''}");
    return resp != null ? jsonDecode(resp) : null;
  }
}