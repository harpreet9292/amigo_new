import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';

void main()
{
  group("init()", ()
  {
    test("", () async
    {
      final obj = await _createObj();
      expect(obj.prefs.getKeys(), isA<Set>());
    });
  });

  group("setSilentMode()", ()
  {
    test("default disabled mode", () async
    {
      var called = false;

      final obj = await _createObj();
      obj.addListener(() => called = true);
      obj.set(SettingsKeys.ConsumerName, "Our consumer");
      expect(called, true);
    });

    test("disable", () async
    {
      var called = false;

      final obj = await _createObj();
      obj.addListener(() => called = true);
      obj.setSilentMode(false);
      obj.set(SettingsKeys.ConsumerName, "Our consumer");
      expect(called, true);
    });

    test("enable", () async
    {
      var called = false;

      final obj = await _createObj();
      obj.addListener(() => called = true);
      obj.setSilentMode(true);
      obj.set(SettingsKeys.ConsumerName, "Our consumer");
      expect(called, false);
    });

    test("enable-disable", () async
    {
      var called = false;

      final obj = await _createObj();
      obj.addListener(() => called = true);
      obj.setSilentMode(true);
      obj.set(SettingsKeys.ConsumerName, "Our consumer");
      expect(called, false);

      obj.setSilentMode(false);
      expect(called, true);
    });
  });

  group("get()", ()
  {
    test("default String value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.ConsumerName);

      obj = await _createObj();
      expect(obj.get<String>(SettingsKeys.ConsumerName), SettingsConfig.DefaultValues[SettingsKeys.ConsumerName]);
    });

    test("default int value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);

      obj = await _createObj();
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });

    test("without generic type", () async
    {
      final obj = await _createObj();
      expect(() => obj.get(SettingsKeys.ConsumerName), throwsA(isA<ArgumentError>()));
    });

    test("wrong value type", () async
    {
      var obj = await _createObj();
      obj.prefs.setInt(SettingsKeys.ConsumerName.toString().split('.')[1], 123); // wrong int value

      obj = await _createObj();
      expect(obj.get<String>(SettingsKeys.ConsumerName), SettingsConfig.DefaultValues[SettingsKeys.ConsumerName]);
    });

    test("wrong generic type", () async
    {
      var obj = await _createObj();
      obj.prefs.setString(SettingsKeys.ConsumerName.toString().split('.')[1], "test");

      obj = await _createObj();
      expect(() => obj.get<int>(SettingsKeys.ConsumerName), throwsA(isA<TypeError>()));
    });

    test("wrong generic type for default value", () async
    {
      var obj = await _createObj();
      await obj.prefs.remove(SettingsKeys.ConsumerName.toString().split('.')[1]);

      obj = await _createObj();
      expect(() => obj.get<int>(SettingsKeys.ConsumerName), throwsA(isA<TypeError>()));
    });

    test("default nullable value with default null", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.SystemKey);

      obj = await _createObj();
      expect(obj.get<String?>(SettingsKeys.SystemKey), null);
    });

    test("get nullable String value for non-null default value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.ConsumerName);

      obj = await _createObj();
      expect(obj.get<String?>(SettingsKeys.ConsumerName), SettingsConfig.DefaultValues[SettingsKeys.ConsumerName]);
    });

    test("get nullable int value for non-null default value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);

      obj = await _createObj();
      expect(obj.get<int?>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });
  });

  group("set()", ()
  {
    test("String value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.ConsumerName);

      obj = await _createObj();
      obj.set(SettingsKeys.ConsumerName, "Our consumer");
      expect(obj.get<String>(SettingsKeys.ConsumerName), "Our consumer");
    });

    test("int value", () async
    {
      var obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);

      obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, 77);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), 77);
    });

    test("null value", () async
    {
      var obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, 55);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), 55);

      obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, null);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });

    test("null value twice", () async
    {
      var obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, 55);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), 55);

      obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, null);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);

      obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, null);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });

    test("wrong type value", () async
    {
      final obj = await _createObj();
      expect(() => obj.set(SettingsKeys.PeriodicGeoPosMinutes, "str77"), throwsA(isA<TypeError>()));
    });
  });

  group("remove()", ()
  {
    test("normal", () async
    {
      var obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, 55);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), 55);

      obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });

    test("twice", () async
    {
      var obj = await _createObj();
      obj.set(SettingsKeys.PeriodicGeoPosMinutes, 55);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), 55);

      obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);

      obj = await _createObj();
      obj.remove(SettingsKeys.PeriodicGeoPosMinutes);
      expect(obj.get<int>(SettingsKeys.PeriodicGeoPosMinutes), SettingsConfig.DefaultValues[SettingsKeys.PeriodicGeoPosMinutes]);
    });
  });
}

Future<SettingsProvider> _createObj() async
{
  final obj = SettingsProvider();
  await obj.init();
  return obj;
}