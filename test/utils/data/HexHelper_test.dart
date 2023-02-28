import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/utils/data/HexHelper.dart';

void main()
{
  group('toHexString', ()
  {
    test('[0, 1, 10, 11, 15]', ()
    {
      final input = Uint8List.fromList([0, 1, 10, 11, 15]);
      final actual = input.toHexString();

      expect(actual, "00010A0B0F");
    });

    test('[0, 1, 10, 11, 15] with separator', ()
    {
      final input = Uint8List.fromList([0, 1, 10, 11, 15]);
      final actual = input.toHexString(separator: '-');

      expect(actual, "00-01-0A-0B-0F");
    });

    test('default empty', ()
    {
      final input = Uint8List.fromList([]);
      final actual = input.toHexString();

      expect(actual, "");
    });

    test('set empty', ()
    {
      final input = Uint8List.fromList([]);
      final actual = input.toHexString(empty: "<empty>");

      expect(actual, "<empty>");
    });
  });
}