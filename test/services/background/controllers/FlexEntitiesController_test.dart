import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:amigotools/entities/flexes/FlexEntity.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/background/controllers/FlexEntitiesController.dart';
import 'package:amigotools/services/webapi/FlexEntitiesApi.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';

import 'FlexEntitiesController_test.mocks.dart';

@GenerateMocks([FlexEntitiesStorage, FlexEntitiesApi])
void main() async
{
  await setupServiceLocator(backgroundChannel: false);

  group("onCleanData", ()
  {
    test("call two times", () async
    {
      final mockApi = _mockApiBuilder();
      final mockStorage = _mockStorageBuilder();

      final controller = FlexEntitiesController();

      for (var i=0; i<2; i++)
      {
        expect(await controller.onCleanData(), true);

        verify(mockStorage.setSilentMode(true)).called(1);
        verify(mockStorage.setSilentMode(false)).called(1);
        verify(mockStorage.deleteAll()).called(1);
        verify(mockStorage.add(any)).called(2);

        verifyNever(mockStorage.update(any));
        verifyNever(mockStorage.delete(ids: anyNamed("ids")));

        verify(mockApi.fetchEntities()).called(1);
      }
    });
  });

  group("onServerState", ()
  {
    test("with state null", () async
    {
      final mockApi = _mockApiBuilder();
      final mockStorage = _mockStorageBuilder();

      final controller = FlexEntitiesController();
      final state = {"entities": null};

      expect(await controller.onServerState(state), true);

      verify(mockStorage.setSilentMode(true)).called(1);
      verify(mockStorage.setSilentMode(false)).called(1);
      verify(mockStorage.deleteAll()).called(1);
      verify(mockStorage.add(any)).called(2);

      verifyNever(mockStorage.update(any));
      verifyNever(mockStorage.delete(ids: anyNamed("ids")));

      verify(mockApi.fetchEntities()).called(1);
    });

    test("empty state", () async
    {
      final mockApi = _mockApiBuilder();
      final mockStorage = _mockStorageBuilder();

      final controller = FlexEntitiesController();
      final state = {"unknown": []};

      expect(await controller.onServerState(state), true);

      verifyNever(mockStorage.setSilentMode(any));
      verifyNever(mockStorage.deleteAll());
      verifyNever(mockStorage.add(any));
      verifyNever(mockStorage.update(any));
      verifyNever(mockStorage.delete(ids: anyNamed("ids")));

      verifyNever(mockApi.fetchEntities());
    });

    test("with state [1,2,3]", () async
    {
      final mockApi = _mockApiBuilder();
      final mockStorage = _mockStorageBuilder();

      final controller = FlexEntitiesController();
      final state = {"entities": <dynamic>[1,2,3]}; // dynamic cast is important for testing

      expect(await controller.onServerState(state), true);

      verify(mockStorage.setSilentMode(true)).called(1);
      verify(mockStorage.setSilentMode(false)).called(1);
      verifyNever(mockStorage.deleteAll());
      verifyNever(mockStorage.add(any));

      verify(mockStorage.update(any)).called(2);
      verify(mockStorage.delete(ids: anyNamed("ids"))).called(1);

      verifyNever(mockApi.fetchEntities());
      verify(mockApi.fetchEntities(ids: [1,2,3])).called(1);
    });
  });

  group("onServiceStart", ()
  {
    test("call", () async
    {
      final mockApi = _mockApiBuilder();
      final mockStorage = _mockStorageBuilder();

      final controller = FlexEntitiesController();
      expect(await controller.onServiceStart(), true);

      verifyNever(mockStorage.setSilentMode(any));
      verifyNever(mockStorage.deleteAll());
      verifyNever(mockStorage.add(any));
      verifyNever(mockStorage.update(any));
      verifyNever(mockStorage.delete(ids: anyNamed("ids")));

      verifyNever(mockApi.fetchEntities());
    });
  });
}

const mockEntity1 = const FlexEntity(
  id: 1,
  ident: "ent1",
  type: FlexEntityType.Object,
  name: "Object 1",
  plural: null,
  fields: [],
  headlines: [],
  atMenu: true,
  atStart: false,
  atFinish: false,
  required: false,
);

const mockEntity2 = const FlexEntity(
  id: 2,
  ident: "ent2",
  type: FlexEntityType.Object,
  name: "Object 2",
  plural: null,
  fields: [],
  headlines: [],
  atMenu: true,
  atStart: false,
  atFinish: false,
  required: false,
);

MockFlexEntitiesApi _mockApiBuilder()
{
  final api = MockFlexEntitiesApi();

  when(api.fetchEntities(ids: null)).thenAnswer((_) async => [mockEntity1, mockEntity2]);
  when(api.fetchEntities(ids: [1])).thenAnswer((_) async => [mockEntity1]);
  when(api.fetchEntities(ids: [3])).thenAnswer((_) async => []);
  when(api.fetchEntities(ids: [1,2,3])).thenAnswer((_) async => [mockEntity1, mockEntity2]);

  $locator.unregister<FlexEntitiesApi>();
  $locator.registerSingleton<FlexEntitiesApi>(api);

  return api;
}

MockFlexEntitiesStorage _mockStorageBuilder()
{
  final storage = MockFlexEntitiesStorage();

  when(storage.setSilentMode(true)).thenReturn(() => {});
  when(storage.setSilentMode(false)).thenReturn(() => {});

  when(storage.deleteAll()).thenAnswer((_) async => 0);
  when(storage.add(mockEntity1)).thenAnswer((_) async => -1);
  when(storage.add(mockEntity2)).thenAnswer((_) async => -2);
  when(storage.update(mockEntity1)).thenAnswer((_) async => true);
  when(storage.update(mockEntity2)).thenAnswer((_) async => true);
  when(storage.delete(ids: anyNamed("ids"))).thenAnswer((_) async => 1);

  when(storage.acceptChanges(receivedItems: [mockEntity1, mockEntity2])).thenAnswer((_) async => true);
  when(storage.acceptChanges(requestedIdsOrAll: [1,2,3], receivedItems: [mockEntity1, mockEntity2])).thenAnswer((_) async => true);

  $locator.unregister<FlexEntitiesStorage>();
  $locator.registerSingleton<FlexEntitiesStorage>(storage);

  return storage;
}