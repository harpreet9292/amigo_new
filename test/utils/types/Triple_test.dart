import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/types/Triple.dart';

void main()
{
  group('Constructor', ()
  {
    test("Strings", ()
    {
      final pair = Triple("str1", "str2", "str3");
      expect(pair.item1, "str1");
      expect(pair.item2, "str2");
      expect(pair.item3, "str3");
    });

    test("Integers", ()
    {
      final pair = Triple(1, 2, 3);
      expect(pair.item1, 1);
      expect(pair.item2, 2);
      expect(pair.item3, 3);
    });

    test("String, Integer and Bool", ()
    {
      final pair = Triple("str1", 2, true);
      expect(pair.item1, "str1");
      expect(pair.item2, 2);
      expect(pair.item3, true);
    });
  });

  group('Operator ==', ()
  {
    test("Equal", ()
    {
      final pair1 = Triple("1", "2", "3");
      final pair2 = Triple("1", "2", "3");
      expect(pair1 == pair2, true);
    });

    test("Not equal", ()
    {
      final pair1 = Triple("1", "2", "3");
      final pair2 = Triple("2", "1", "3");
      expect(pair1 == pair2, false);
    });

    test("Not equal when wrong generic type", ()
    {
      final pair1 = Triple("1", "2", "3");
      final pair2 = Triple("1", 2, "3");
      // ignore: unrelated_type_equality_checks
      expect(pair1 == pair2, false);
    });

    test("Not equal, wrong object type", ()
    {
      final pair1 = Triple("1", "2", "3");
      // ignore: unrelated_type_equality_checks
      expect(pair1 == "1", false);
    });
  });
}