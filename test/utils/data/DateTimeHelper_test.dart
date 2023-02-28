import 'package:flutter_test/flutter_test.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

void main()
{
  group("dateTimeToIsoDate()", ()
  {
    test("normal, start of day", ()
    {
      final dt = DateTime(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoDate(dt);

      expect(actual, "2021-05-20");
    });

    test("normal, end of day", ()
    {
      final dt = DateTime(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoDate(dt);

      expect(actual, "2021-05-20");
    });

    test("utc, start of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoDate(dt);

      expect(actual, "2021-05-20");
    });

    test("utc, end of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoDate(dt);

      expect(actual, "2021-05-20");
    });

    test("attempt to parse", ()
    {
      final dt = DateTime(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoDate(dt);

      final created = DateTime.parse(actual!);

      expect(created.day, 20);
      expect(created.minute, 0);
    });
  });

  group("dateTimeToIsoDateTime()", ()
  {
    test("normal, start of day", ()
    {
      final dt = DateTime(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoDateTime(dt);

      expect(actual, "2021-05-20T00:00:00");
    });

    test("normal, end of day", ()
    {
      final dt = DateTime(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoDateTime(dt);

      expect(actual, "2021-05-20T23:59:59");
    });

    test("utc, start of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoDateTime(dt);

      expect(actual, "2021-05-20T00:00:00Z");
    });

    test("utc, end of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoDateTime(dt);

      expect(actual, "2021-05-20T23:59:59Z");
    });
  });

  group("dateTimeToIsoTime()", ()
  {
    test("normal, start of day", ()
    {
      final dt = DateTime(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoTime(dt);

      expect(actual, "00:00:00");
    });

    test("normal, end of day", ()
    {
      final dt = DateTime(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoTime(dt);

      expect(actual, "23:59:59");
    });

    test("utc, start of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 0, 0, 0);
      final actual = dateTimeToIsoTime(dt);

      expect(actual, "00:00:00");
    });

    test("utc, end of day", ()
    {
      final dt = DateTime.utc(2021, 5, 20, 23, 59, 59);
      final actual = dateTimeToIsoTime(dt);

      expect(actual, "23:59:59");
    });
  });

  group("parseIsoTime()", ()
  {
    test("00:00:00", ()
    {
      final created = parseIsoTime("00:00:00");

      expect(created.hour, 0);
      expect(created.minute, 0);
      expect(created.second, 0);
    });

    test("00:00", ()
    {
      final created = parseIsoTime("00:00");

      expect(created.hour, 0);
      expect(created.minute, 0);
      expect(created.second, 0);
    });

    test("23:59:59", ()
    {
      final created = parseIsoTime("23:59:59");

      expect(created.hour, 23);
      expect(created.minute, 59);
      expect(created.second, 59);
    });

    test("23:59", ()
    {
      final created = parseIsoTime("23:59");

      expect(created.hour, 23);
      expect(created.minute, 59);
      expect(created.second, 0);
    });
 
    test("2010-11-12T23:59", ()
    {
      final created = parseIsoTime("23:59");

      expect(created.hour, 23);
      expect(created.minute, 59);
      expect(created.second, 0);
    });

    test("2010-11-12T23:59:59", ()
    {
      final created = parseIsoTime("23:59");

      expect(created.hour, 23);
      expect(created.minute, 59);
      expect(created.second, 0);
    });
  });

  group("durationToString()", ()
  {
    test("zero", ()
    {
      final dt = Duration.zero;
      final actual = durationToString(dt);

      expect(actual, "0:00:00");
    });

    test("1 hour", ()
    {
      final dt = Duration(hours: 1);
      final actual = durationToString(dt);

      expect(actual, "1:00:00");
    });

    test("23:59:59", ()
    {
      final dt = Duration(days: 1) - Duration(seconds: 1);
      final actual = durationToString(dt);

      expect(actual, "23:59:59");
    });

    test("1 day", ()
    {
      final dt = Duration(days: 1);
      final actual = durationToString(dt);

      expect(actual, "24:00:00");
    });

    test("1 day 23:59:59", ()
    {
      final dt = Duration(days: 2) - Duration(seconds: 1);
      final actual = durationToString(dt);

      expect(actual, "47:59:59");
    });

    test("3 day 23:59:59", ()
    {
      final dt = Duration(days: 3) - Duration(seconds: 1);
      final actual = durationToString(dt);

      expect(actual, "2.23:59:59");
    });

    test("100 days", ()
    {
      final dt = Duration(days: 100);
      final actual = durationToString(dt);

      expect(actual, "100.0:00:00");
    });
  });
}