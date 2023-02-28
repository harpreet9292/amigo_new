import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/types/Pair.dart';

void main()
{
  group('Constructor', ()
  {
    test("Strings", ()
    {
      final pair = Pair("str1", "str2");
      expect(pair.item1, "str1");
      expect(pair.item2, "str2");
    });

    test("Integers", ()
    {
      final pair = Pair(1, 2);
      expect(pair.item1, 1);
      expect(pair.item2, 2);
    });

    test("String and Integer", ()
    {
      final pair = Pair("str1", 2);
      expect(pair.item1, "str1");
      expect(pair.item2, 2);
    });
  });

  group('Operator ==', ()
  {
    test("Equal", ()
    {
      final pair1 = Pair("1", "2");
      final pair2 = Pair("1", "2");
      expect(pair1 == pair2, true);
    });

    test("Not equal", ()
    {
      final pair1 = Pair("1", "2");
      final pair2 = Pair("2", "1");
      expect(pair1 == pair2, false);
    });

    test("Not equal when wrong generic type", ()
    {
      final pair1 = Pair("1", "2");
      final pair2 = Pair("1", 2);
      // ignore: unrelated_type_equality_checks
      expect(pair1 == pair2, false);
    });

    test("Not equal, wrong object type", ()
    {
      final pair1 = Pair("1", "2");
      // ignore: unrelated_type_equality_checks
      expect(pair1 == "1", false);
    });
  });
}