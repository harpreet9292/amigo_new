import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/data/CryptoHelper.dart';

void main()
{
  group("generateMd5()", ()
  {
    test("\"123\"", ()
    {
      final res = generateMd5("123");
      expect(res, "202cb962ac59075b964b07152d234b70");
    });

    test("empty string", ()
    {
      final res = generateMd5("");
      expect(res.isNotEmpty, true);
    });
  });
}