import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mockito/mockito.dart';

import 'package:amigotools/entities/rest/AuthStatus.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/services/webapi/ApiConnectorState.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/data/CryptoHelper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ApiConnector_test.mocks.dart';

Future<http.Client> buildMockClient() async
{
  final client = MockClient();

  const AuthStatusResp = '{"sessionKey": "TEST_SESSION_ID", "id": 1, "name": "User name", "role": "guard", "groups":[], "patrol": false}';

  // Login: correct pin
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.LoginApiPath), {"pin": generateMd5("123")})))
  .thenAnswer((_) async => http.Response(AuthStatusResp, HttpStatus.ok));

  // Login: second correct pin
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.LoginApiPath), {"pin": generateMd5("1234")})))
  .thenAnswer((_) async => http.Response(AuthStatusResp, HttpStatus.ok));

  // Login: incorrect pin
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.LoginApiPath), {"pin": generateMd5("000")})))
  .thenAnswer((_) async => http.Response('', HttpStatus.unauthorized));

  // Login: empty pin
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.LoginApiPath), {"pin": generateMd5("")})))
  .thenAnswer((_) async => http.Response('', HttpStatus.unauthorized));

  // Login: wrong url
  when(client.get(Uri.https("wrong", path.join("api", WebApiConfig.LoginApiPath), {"pin": generateMd5("123")})))
  .thenAnswer((_) async => http.Response('', HttpStatus.notFound));

  // Logout
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.LogoutApiPath), {"s": "TEST_SESSION_ID"})))
  .thenAnswer((_) async => http.Response('', HttpStatus.ok));

  // ping - pong
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", "ping"), {"s": "TEST_SESSION_ID"})))
  .thenAnswer((_) async => http.Response('pong', HttpStatus.ok));

  // Orders
  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.OrdersApiCat), {"s": "TEST_SESSION_ID"})))
  .thenAnswer((_) async => http.Response(
    '[ {"id":101, "entityIdent":"order1", "values":{}, "groupId":1, "objectId":null, "userId":null, "time":"2021-05-25 12:20", "state":"Active"} ]',
    HttpStatus.ok
  ));

  when(client.get(Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.OrdersApiCat), {"s": "TEST_SESSION_ID", "ids": "101"})))
  .thenAnswer((_) async => http.Response(
    '[ {"id":101, "entityIdent":"order1", "values":{}, "groupId":1, "objectId":null, "userId":null, "time":"2021-05-25 12:20", "state":"Active"} ]',
    HttpStatus.ok
  ));

  when(
    client.post(
      Uri.https("dev.amigotools.se", path.join("api", WebApiConfig.OrdersApiCat) + "/101", {"s": "TEST_SESSION_ID"}),
      headers: {"Content-Type": "application/json"},
      body: '{"state":"Closed"}',
      encoding: null,
    )
  )
  .thenAnswer((_) async => http.Response(
    '[ {"id":101, "entityIdent":"order1", "values":{}, "groupId":1, "objectId":null, "userId":null, "time":"2021-05-25 12:20", "state":"Active"} ]',
    HttpStatus.ok
  ));

  $locator.unregister<ApiConnector>();
  $locator.registerLazySingleton<ApiConnector>(() => ApiConnector(ApiConnectorStateMock(), client: client), dispose: (instance) => instance.dispose());

  return client;
}

class ApiConnectorStateMock implements ApiConnectorState
{
  @override
  String? consumerIdent;

  @override
  String? sysKey;

  @override
  AuthStatus? authStatus;

  @override
  String? pinMd5;
}