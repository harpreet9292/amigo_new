import 'package:get_it/get_it.dart';

import 'package:amigotools/services/background/BackgroundDispatcher.dart';
import 'package:amigotools/services/background/BackgroundApp.dart';
import 'package:amigotools/services/background/BackgroundRoutine.dart';
import 'package:amigotools/services/webapi/FlexGroupsApi.dart';
import 'package:amigotools/services/webapi/SettingsApi.dart';
import 'package:amigotools/services/storage/DatabaseConnector.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/services/state/AppStateBridge.dart';
import 'package:amigotools/services/webapi/UsersApi.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/services/storage/FlexGroupsStorage.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/services/storage/UsersStorage.dart';
import 'package:amigotools/services/webapi/FlexEntitiesApi.dart';
import 'package:amigotools/services/webapi/FlexObjectsApi.dart';
import 'package:amigotools/services/storage/FlexOrdersStorage.dart';
import 'package:amigotools/services/storage/FlexOutcomesStorage.dart';
import 'package:amigotools/services/storage/SysTasksStorage.dart';
import 'package:amigotools/services/storage/ObjectEventsStorage.dart';
import 'package:amigotools/services/webapi/FlexOrdersApi.dart';
import 'package:amigotools/services/webapi/FlexOutcomesApi.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:amigotools/services/webapi/ServerStateApi.dart';
import 'package:amigotools/services/nfc/NfcProvider.dart';
import 'package:amigotools/services/files/PhotosProvider.dart';
import 'package:amigotools/services/geopos/ExternalMapProvider.dart';
import 'package:amigotools/services/geopos/GeoLocationProvider.dart';
import 'package:amigotools/services/webapi/AuthApi.dart';
import 'package:amigotools/services/state/InfoProvider.dart';
import 'package:amigotools/services/beeper/BeeperProvider.dart';
import 'package:amigotools/services/core/workflows/ObjectVisitsManagerCoreModel.dart';
import 'package:amigotools/services/core/routines/RoutinesManagerCoreModel.dart';
import 'package:amigotools/services/webapi/EventsApi.dart';
import 'package:amigotools/services/storage/FlexCustItemsStorage.dart';
import 'package:amigotools/services/storage/MaterialsStorage.dart';
import 'package:amigotools/services/webapi/FlexCustItemsApi.dart';
import 'package:amigotools/services/webapi/MaterialsApi.dart';
import 'package:amigotools/services/storage/RoutineTasksStorage.dart';
import 'package:amigotools/services/storage/RoutinesStorage.dart';
import 'package:amigotools/services/webapi/RoutinesApi.dart';

GetIt $locator = GetIt.instance;

Future<void> setupServiceLocator({required bool backgroundChannel}) async
{
  // settings

  final settingsProvider = SettingsProvider();
  await settingsProvider.init(); // await is important to init other services with initialized settings service
  $locator.registerSingleton<SettingsProvider>(settingsProvider);

  // state

  final appState = AppStateBridge(backgroundChannel: backgroundChannel);
  $locator.registerSingleton<AppStateBridge>(appState, dispose: (instance) => instance.dispose());
  
  final infoProv = InfoProvider();
  await infoProv.ensureInit();
  $locator.registerSingleton<InfoProvider>(infoProv);

  // background

  if (!backgroundChannel)
  {
    $locator.registerLazySingleton<BackgroundDispatcher>(() => BackgroundDispatcher(), dispose: (instance) => instance.dispose());
  }
  else
  {
    $locator.registerLazySingleton<BackgroundApp>(() => BackgroundApp());
    $locator.registerLazySingleton<BackgroundRoutine>(() => BackgroundRoutine(), dispose: (instance) => instance.dispose());
  }

  // core

  $locator.registerLazySingleton<RoutinesManagerCoreModel>(() => RoutinesManagerCoreModel(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<ObjectVisitsManagerCoreModel>(() => ObjectVisitsManagerCoreModel(), dispose: (instance) => instance.dispose());

  // rest

  $locator.registerFactory<BeeperProvider>(() => BeeperProvider());
  $locator.registerFactory<PhotosProvider>(() => PhotosProvider());
  $locator.registerFactory<ExternalMapProvider>(() => ExternalMapProvider());
  $locator.registerLazySingleton<NfcProvider>(() => NfcProvider(), dispose: (instance) => instance.dispose());
  $locator.registerFactory<GeoLocationProvider>(() => GeoLocationProvider());

  // storage

  final dbConnector = DatabaseConnector();
  await dbConnector.init(initSchema: backgroundChannel);
  $locator.registerSingleton<DatabaseConnector>(dbConnector);
  $locator.registerLazySingleton<FlexEntitiesStorage>(() => FlexEntitiesStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<FlexGroupsStorage>(() => FlexGroupsStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<FlexObjectsStorage>(() => FlexObjectsStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<FlexOrdersStorage>(() => FlexOrdersStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<FlexOutcomesStorage>(() => FlexOutcomesStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<FlexCustItemsStorage>(() => FlexCustItemsStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<MaterialsStorage>(() => MaterialsStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<UsersStorage>(() => UsersStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<SysTasksStorage>(() => SysTasksStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<ObjectEventsStorage>(() => ObjectEventsStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<RoutinesStorage>(() => RoutinesStorage(), dispose: (instance) => instance.dispose());
  $locator.registerLazySingleton<RoutineTasksStorage>(() => RoutineTasksStorage(), dispose: (instance) => instance.dispose());

  // webapi

  $locator.registerLazySingleton<ApiConnector>(() => ApiConnector(appState), dispose: (instance) => instance.dispose());
  $locator.registerFactory<AuthApi>(() => AuthApi());
  $locator.registerFactory<FlexEntitiesApi>(() => FlexEntitiesApi());
  $locator.registerFactory<FlexGroupsApi>(() => FlexGroupsApi());
  $locator.registerFactory<FlexObjectsApi>(() => FlexObjectsApi());
  $locator.registerFactory<FlexOrdersApi>(() => FlexOrdersApi());
  $locator.registerFactory<FlexOutcomesApi>(() => FlexOutcomesApi());
  $locator.registerFactory<FlexCustItemsApi>(() => FlexCustItemsApi());
  $locator.registerFactory<SettingsApi>(() => SettingsApi());
  $locator.registerFactory<ServerStateApi>(() => ServerStateApi());
  $locator.registerFactory<MaterialsApi>(() => MaterialsApi());
  $locator.registerFactory<UsersApi>(() => UsersApi());
  $locator.registerFactory<EventsApi>(() => EventsApi());
  $locator.registerFactory<RoutinesApi>(() => RoutinesApi());
}