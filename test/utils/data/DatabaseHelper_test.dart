import 'package:amigotools/utils/data/DatabaseHelper.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  group('valuesForSqlOperatorIn', ()
  {
    test('1', ()
    {
      final input = [1];
      final res = valuesForSqlOperatorIn(input);

      expect(res, "('1')");
    });

    test('1,2', ()
    {
      final input = [1,2];
      final res = valuesForSqlOperatorIn(input);

      expect(res, "('1','2')");
    });

    test("'str','str'", ()
    {
      final input = ["'str'", "'str'"];
      final res = valuesForSqlOperatorIn(input);

      expect(res, "('''str''','''str''')");
    });

    test('"str"', ()
    {
      final input = ['"str"'];
      final res = valuesForSqlOperatorIn(input);

      expect(res, "('\"str\"')");
    });

    test('null, 1', ()
    {
      final input = [null, 1];
      final res = valuesForSqlOperatorIn(input);

      expect(res, "(null,'1')");
    });

    test('empty', ()
    {
      final input = [];

      expect(() => valuesForSqlOperatorIn(input), throwsArgumentError);
    });
  });

  group('escapeForSqlOperatorLike', ()
  {
    test('qwe', ()
    {
      final input = "qwe";
      final res = escapeForSqlOperatorLike(input);

      expect(res, "qwe");
    });

    test('"qwe"', ()
    {
      final input = '"qwe"';
      final res = escapeForSqlOperatorLike(input);

      expect(res, '"qwe"');
    });

    test("'qwe'", ()
    {
      final input = "'qwe'";
      final res = escapeForSqlOperatorLike(input);

      expect(res, "''qwe''");
    });

    test("q_%", ()
    {
      final input = "q_%";
      final res = escapeForSqlOperatorLike(input);

      expect(res, "q\\_\\%");
    });

    test("%_q_%", ()
    {
      final input = "%_q_%";
      final res = escapeForSqlOperatorLike(input);

      expect(res, "\\%\\_q\\_\\%");
    });
  });

  group('toNum', ()
  {
    test('true', ()
    {
      final res = true.toNum();
      expect(res, 1);
    });

    test('false', ()
    {
      final res = false.toNum();
      expect(res, 0);
    });
  });
}