import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

void main()
{
  group('enumValueToString()', () {
    test('null', () {
      final res = enumValueToString(null);
      expect(res, null);
    });

    test('normal', () {
      final res = enumValueToString(TestEnumValueToString.Value1);
      expect(res, "Value1");
    });

    test('already stringed', () {
      final res = enumValueToString(TestEnumValueToString.Value1.toString());
      expect(res, "Value1");
    });

    test('error if int', () {
      expect(() => enumValueToString(TestEnumValueToString.Value1.index), throwsA(isA<ArgumentError>()));
    });
  });

  group('enumValueFromString()', () {
    test('Value1', () {
      final res = enumValueFromString(TestEnumValueToString.values, "Value1");
      expect(res, TestEnumValueToString.Value1);
    });

    test('Value2', () {
      final res = enumValueFromString(TestEnumValueToString.values, "Value2");
      expect(res, TestEnumValueToString.Value2);
    });

    test('error if wrong value', () {
      expect(() => enumValueFromString(TestEnumValueToString.values, "WrongValue"), throwsStateError);
    });

    test('error is empty string', () {
      expect(() => enumValueFromString(TestEnumValueToString.values, ""), throwsStateError);
    });
  });
}

enum TestEnumValueToString
{
  Value1,
  Value2,
}