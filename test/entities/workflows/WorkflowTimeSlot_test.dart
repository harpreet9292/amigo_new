import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:amigotools/entities/workflows/WorkflowTimeslot.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';

void main()
{
  group("time fields", ()
  {
    test("toJson", ()
    {
      final obj = _createTimeslotObj();
      final res = obj.toJson();

      expect(res["startTime"], "11:30:00");
      expect(res["endTime"], "12:20:00");
    });

    test("toJson - fromJson", ()
    {
      final obj = _createTimeslotObj();
      final json = jsonEncode(obj);
      final recreated = WorkflowTimeslot.fromJson(jsonDecode(json));

      expect(recreated.startTime.minute, 30);
      expect(recreated.endTime.minute, 20);
    });
  });
}

WorkflowTimeslot _createTimeslotObj()
{
  return WorkflowTimeslot(
    id: 12,
    days: "W",
    startTime: parseIsoTime("11:30"),
    endTime: parseIsoTime("12:20"),
    startDate: null,
    endDate: null);
}