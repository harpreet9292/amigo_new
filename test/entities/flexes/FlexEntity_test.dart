import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/entities/flexes/FlexEntity.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';

void main()
{
  group("toJson()", ()
  {
    test("unserialized nested lists", ()
    {
      final obj = _createFlexEntity();

      final actualJsonObj = obj.toJson();
      
      expect(actualJsonObj["fields"], isA<List<FlexField>>());
      expect(actualJsonObj["fields"].length, 1);

      expect(actualJsonObj["headlines"], isA<List<String>>());
      expect(actualJsonObj["headlines"].length, 2);
    });

    test("jsonEncode() serializes nested objects", ()
    {
      final obj = _createFlexEntity();

      final actualJsonObj = obj.toJson();
      final actualJsonStr = jsonEncode(actualJsonObj);

      final directJsonStr = jsonEncode(obj);

      expect(actualJsonStr, directJsonStr);
    });

    test("nested enum", ()
    {
      final obj = _createFlexEntity();
      final res = obj.toJson();

      expect(res["type"], "Outcome");
    });
  });

  group("fromJson()", ()
  {
    test("after toJson()", ()
    {
      final obj = _createFlexEntity();
      final jsonStr = jsonEncode(obj);

      final recreated = FlexEntity.fromJson(jsonDecode(jsonStr));

      expect(recreated.hashCode, isNot(obj.hashCode));
      expect(recreated.fields[0].hashCode, isNot(obj.fields[0].hashCode));

      expect(recreated.id, obj.id);
      expect(recreated.headlines.length, obj.headlines.length);
      expect(recreated.headlines[0], obj.headlines[0]);
      expect(recreated.type, obj.type);
      expect(recreated.fields[0].type, obj.fields[0].type);
      expect(recreated.fields[0].values!.length, obj.fields[0].values!.length);
    });

    test("unexpected enum value", ()
    {
      final obj = _createFlexEntity();
      final jsonStr = jsonEncode(obj);

      final modifiedJsonStr = jsonStr.replaceFirst("\"Draft\"", "\"UnknownValue\"");
      final modifiedJson = jsonDecode(modifiedJsonStr);

      final recreated = FlexEntity.fromJson(modifiedJson);

      expect(recreated.hashCode, isNot(obj.hashCode));

      expect(recreated.type, FlexEntityType.Outcome);
    });

    test("int instead of bool values", ()
    {
      final obj = _createFlexEntity();
      final jsonStr = jsonEncode(obj);

      var modifiedJsonStr = jsonStr.replaceAll('true', '1');
      modifiedJsonStr = modifiedJsonStr.replaceAll('false', '0');
      final modifiedJson = jsonDecode(modifiedJsonStr);

      final recreated = FlexEntity.fromJson(modifiedJson);
      expect(recreated.atMenu, true);
    });
  });
}

FlexEntity _createFlexEntity() => FlexEntity(
  id: 12,
  ident: "eid",
  type: FlexEntityType.Outcome,
  name: "Some outcome",
  plural: null,
  fields: [
    FlexField(
      ident: "fid",
      type: FlexFieldType.Selection,
      label: "Field label",
      required: true,
      readonly: false,
      hint: "Field hint",
      initial: null,
      inputType: FlexFieldInputType.email,
      min: null,
      max: 100,
      multiple: false,
      values: ["val1", "val2"],
      param: null,
      storable: true
    ),
  ],
  headlines: ["f1", "f2"],
  atMenu: true,
  atStart: false,
  atFinish: false,
  required: false,
);