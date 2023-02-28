import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';

void main()
{
  group('jsonDecodeAndMapList()', ()
  {
    test("for null", ()
    {
      final json = null;

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res, null);
    });

    test("for empty json", ()
    {
      final json = "";

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res, null);
    });

    test("for empty array", ()
    {
      final json = "[]";

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res, []);
    });

    test("for array of ints", ()
    {
      final json = "[1,2,3]";

      final res1 = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res1, [1,2,3]);

      final res2 = jsonDecodeAndMapList(json, mapper: (row) => row.toString());
      expect(res2, ["1","2","3"]);
    });

    test("for array of different types", ()
    {
      final json = "[1,\"2\",true]";

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res, [1, "2", true]);
    });

    test("for array of hashes", ()
    {
      final json = "[{\"qwe\": 123}, {}]";

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res!.length, 2);
      expect(res.first, isA<Map<String, dynamic>>());
    });

    test("for array of big hash", ()
    {
      final json = '[ {"id":1, "entityIdent":"order1", "values":{}, "groupId":1, "objectId":null, "userId":null, "time":"2021-05-25 12:20", "state":"Active"} ]';

      final res = jsonDecodeAndMapList(json, mapper: (row) => row);
      expect(res!.length, 1);
      expect(res.first, isA<Map<String, dynamic>>());
    });
  });

  group('jsonDecodeValueToBool()', ()
  {
    test("for null", ()
    {
      expect(jsonDecodeValueToBool(null), false);
    });

    test("for empty string", ()
    {
      expect(jsonDecodeValueToBool(""), false);
    });

    test("for space string", ()
    {
      expect(jsonDecodeValueToBool(" "), false);
    });


    test("for '1' string", ()
    {
      expect(jsonDecodeValueToBool("1"), false);
    });

    test("for 0", ()
    {
      expect(jsonDecodeValueToBool(0), false);
    });

    test("for 1", ()
    {
      expect(jsonDecodeValueToBool(1), true);
    });

    test("for true string", ()
    {
      expect(jsonDecodeValueToBool("true"), true);
    });

    test("for True string", ()
    {
      expect(jsonDecodeValueToBool("True"), true);
    });

    test("for true", ()
    {
      expect(jsonDecodeValueToBool(true), true);
    });
  });
}