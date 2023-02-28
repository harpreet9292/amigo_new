import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/entities/rest/GeoPosition.dart';
import 'package:amigotools/entities/flexes/FlexOutcome.dart';

void main()
{
  group("toJson()", ()
  {
    test("unserialized nested objects", ()
    {
      final obj = _createOutcome();
      final actualJsonObj = obj.toJson();

      expect(actualJsonObj["position"], isA<GeoPosition>());
    });

    test("jsonEncode() serializes nested objects", ()
    {
      final obj = _createOutcome();

      final actualJsonObj = obj.toJson();
      final actualJsonStr = jsonEncode(actualJsonObj);

      final directJsonStr = jsonEncode(obj);

      expect(actualJsonStr, directJsonStr);
    });

    test("DateTime", ()
    {
      final obj = _createOutcome();
      final res = obj.toJson();

      expect(res["time"].length, 19); // 19 - without 'Z'
    });

    test("nested Map", ()
    {
      final obj = _createOutcome();
      final res = obj.toJson();

      expect(res["values"], isA<Map<String, dynamic>>());

      expect(res["values"]["int1"], 255);
      expect(res["values"]["bool1"], true);
    });

    test("nested enum", ()
    {
      final obj = _createOutcome();
      final res = obj.toJson();

      expect(res["sys_status"], "Draft");
    });
  });

  group("fromJson()", ()
  {
    test("after toJson()", ()
    {
      final obj = _createOutcome();
      final jsonStr = jsonEncode(obj);

      final recreated = FlexOutcome.fromJson(jsonDecode(jsonStr));

      expect(recreated.hashCode, isNot(obj.hashCode));
      expect(recreated.position.hashCode, isNot(obj.position.hashCode));

      expect(recreated.id, obj.id);
      expect(recreated.values.length, obj.values.length);
      expect(recreated.sysStatus, obj.sysStatus);
      expect(recreated.position!.lat, obj.position!.lat);

      expect(recreated.time.day, obj.time.day);
      expect(recreated.time.second, obj.time.second);
    });

    test("unexpected enum value", ()
    {
      final obj = _createOutcome();
      final jsonStr = jsonEncode(obj);

      final modifiedJsonStr = jsonStr.replaceFirst("\"Draft\"", "\"UnknownValue\"");
      final modifiedJson = jsonDecode(modifiedJsonStr);

      final recreated = FlexOutcome.fromJson(modifiedJson);

      expect(recreated.hashCode, isNot(obj.hashCode));

      expect(recreated.sysStatus, FlexOutcomeSysStatus.Completed);
    });
  });
}

FlexOutcome _createOutcome()
{
  final obj = FlexOutcome(
    id: 12,
    entityIdent: "obj",
    values: {"str1": "text", "int1": 255},
    groupId: null,
    objectId: null,
    orderId: null,
    time: DateTime.now(),
    sysStatus: FlexOutcomeSysStatus.Draft,
    position: GeoPosition(
      lat: 12.34,
      lng: 56.78,
      accur: null,
      speed: 60.0,
      time: DateTime.now(),
      addr: null)
    );

  obj.values["bool1"] = true;

  return obj;
}