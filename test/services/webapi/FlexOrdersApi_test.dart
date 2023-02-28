import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/entities/flexes/FlexOrder.dart';
import 'package:amigotools/services/webapi/FlexOrdersApi.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

import '_mock_client_builder.dart';

void main() async
{
  await setupServiceLocator(backgroundChannel: false);

  group("fetchOrders", ()
  {
    test("no ids, not authenticated", () async
    {
      await buildMockClient();

      final connector = $locator.get<ApiConnector>();
      await connector.logout();

      final api = $locator.get<FlexOrdersApi>();
      final res = await api.fetchOrders();

      expect(res, null);
    });

    test("no ids, authenticated", () async
    {
      await buildMockClient();

      final connector = $locator.get<ApiConnector>();
      await connector.login("123");

      final api = $locator.get<FlexOrdersApi>();
      final res = await api.fetchOrders();

      expect(res, isA<Iterable<FlexOrder>>());
    });

    test("with ids", () async
    {
      await buildMockClient();

      final connector = $locator.get<ApiConnector>();
      await connector.login("123");

      final api = $locator.get<FlexOrdersApi>();
      final res = await api.fetchOrders(ids: [101]);

      expect(res, isA<Iterable<FlexOrder>>());
      expect(res!.first.id, 101);
    });
  });

  group("changeOrder", ()
  {
    test("argument error", () async
    {
      await buildMockClient();

      final connector = $locator.get<ApiConnector>();
      await connector.login("123");

      final api = $locator.get<FlexOrdersApi>();
      final orders = await api.fetchOrders();

      expect(() async => await api.changeOrder(orders!.first), throwsA(isA<ArgumentError>()));
    });

    test("change state", () async
    {
      await buildMockClient();

      final connector = $locator.get<ApiConnector>();
      await connector.login("123");

      final api = $locator.get<FlexOrdersApi>();
      final orders = await api.fetchOrders();

      final res = await api.changeOrder(orders!.first, state: FlexOrderState.Closed);

      expect(res, true);
    });
  });
}