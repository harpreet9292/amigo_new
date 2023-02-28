import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

import '_mock_client_builder.dart';

@GenerateMocks([http.Client])
void main() async
{
  await setupServiceLocator(backgroundChannel: false);

  group("isAuthenticated", ()
  {
    test("correct pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      expect(connector.isAuthenticated, false);

      await connector.login("123");
      
      expect(connector.isAuthenticated, true);
    });

    test("incorrect pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);
      
      expect(connector.isAuthenticated, false);

      await connector.login("000");
      
      expect(connector.isAuthenticated, false);
    });

    test("logout", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      expect(connector.isAuthenticated, false);

      await connector.login("123");
      
      expect(connector.isAuthenticated, true);

      await connector.logout();

      expect(connector.isAuthenticated, false);
    });
  });

  group("apiUrlBase", ()
  {
    test("if default", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);
      expect(WebApiConfig.DefaultApiUrlTemplate.startsWith(connector.baseUri.scheme), true);
    });

    test("if from settings", () async
    {
      final client = await buildMockClient();

      final settings = $locator.get<SettingsProvider>();

      try
      {
        settings.set(SettingsKeys.MainApiUrlTpl, "https://test.com");

        final connector = ApiConnector(ApiConnectorStateMock(), client: client);
        expect(connector.baseUri.origin, "https://test.com");
      }
      finally
      {
        settings.remove(SettingsKeys.MainApiUrlTpl);
      }
    });

    test("login if from settings", () async
    {
      final client = await buildMockClient();

      final settings = $locator.get<SettingsProvider>();
      
      try
      {
        settings.set(SettingsKeys.MainApiUrlTpl, "http://wrong/api");

        final connector = ApiConnector(ApiConnectorStateMock(), client: client);
        expect(() async => await connector.login("123"), throwsA(isA<HttpException>()));
      }
      finally
      {
        settings.remove(SettingsKeys.MainApiUrlTpl);
      }
    });
  });

  group("login", ()
  {
    test("correct pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      final res = await connector.login("123");

      expect(res, true, reason: "login() should return true if PIN is correct");

      expect(connector.isAuthenticated, true, reason: "auth status should be true");

      expect(notified, 1, reason: "listeners should be notificated when auth status is changed");
    });

    test("incorrect pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      final res = await connector.login("000");

      expect(res, false, reason: "login() should return false if PIN is incorrect");

      expect(connector.isAuthenticated, false, reason: "auth status should stay false");

      expect(notified, 0, reason: "listeners should not be notificated if auth status was not changed");
    });

    test("same correct pin again", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      final res = await connector.login("123");

      expect(res, true, reason: "login() should return true if PIN is correct anyway");

      expect(connector.isAuthenticated, true, reason: "auth status should stay true");

      expect(notified, 2, reason: "listeners should be notificated when the connector was relogged in, even if same PIN");
    });

    test("another correct pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      final res = await connector.login("1234");

      expect(res, true, reason: "login() should return true if PIN is correct anyway");

      expect(connector.isAuthenticated, true, reason: "auth status should stay true");

      expect(notified, 2, reason: "listeners should be notificated when the connector was relogged in");
    });

    test("empty pin", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      final res = await connector.login("");

      expect(res, false);

      expect(notified, 0, reason: "listeners should not be notificated when auth status was not changed");
    });
  });

  group("logout", ()
  {
    test("after login", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      await connector.logout();

      expect(connector.isAuthenticated, false);

      expect(notified, 2, reason: "listeners should be notificated when auth status is changed");
    });

    test("double logout, after login", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      await connector.logout();

      expect(connector.isAuthenticated, false);

      await connector.logout();

      expect(connector.isAuthenticated, false);

      expect(notified, 2, reason: "listeners should not be notificated when auth status was changed");
    });

    test("without login", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.logout();

      expect(connector.isAuthenticated, false);

      expect(notified, 0, reason: "listeners should not be notificated when auth status was changed");
    });

    test("silent = false", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      await connector.logout(silent: false);

      expect(notified, 2);
    });

    test("silent = true", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      await connector.logout(silent: true);

      expect(notified, 1);
    });
  });

  group("request", ()
  {
    test("single ping", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      final res = await connector.request("ping");

      expect(res, "pong");

      expect(notified, 1, reason: "listeners should be notificated when auth status is changed during login");
    });

    test("double ping", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      await connector.login("123");

      await connector.request("ping");
      final res = await connector.request("ping");

      expect(res, "pong");

      expect(notified, 1, reason: "listeners should be notificated when auth status is changed during login");
    });

    test("ping without login", () async
    {
      final client = await buildMockClient();

      final connector = ApiConnector(ApiConnectorStateMock(), client: client);

      var notified = 0;
      connector.addListener(() => notified++);

      final res = await connector.request("ping");

      expect(res, null); // TODO: ?

      expect(notified, 0, reason: "listeners should be notificated when auth status is changed during login");
    });

    // TODO
  });
}