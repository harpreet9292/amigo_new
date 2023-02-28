import 'package:intl/intl.dart';

import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/entities/workflows/WorkflowTimeslot.dart';

class TimeslotCoreModel
{
  const TimeslotCoreModel(this.item);

  final WorkflowTimeslot item;

  TimeslotTypeCoreModel get type
  {
    if (item.days.isNotEmpty)
    {
      switch (item.days[0])
      {
        case 'M':
          return TimeslotTypeCoreModel.Monthly;
        case 'W':
          return TimeslotTypeCoreModel.Weekly;
        case 'D':
          return TimeslotTypeCoreModel.Date;
      }
    }

    return TimeslotTypeCoreModel.Unknown;
  }

  DateTime calcFullStartTime(DateTime baseDate)
  {
    if (item.startTime.isAfter(item.endTime))
    {
      baseDate = baseDate.add(Duration(days: -1));
    }

    return new DateTime(baseDate.year, baseDate.month, baseDate.day,
        item.startTime.hour, item.startTime.minute, item.startTime.second);
  }

  DateTime calcFullEndTime(DateTime baseDate)
  {
    return new DateTime(baseDate.year, baseDate.month, baseDate.day,
        item.endTime.hour, item.endTime.minute, item.endTime.second);
  }

  bool isValidForDate(DateTime date)
  {
    date = date.getDatePart();

    if (item.startDate != null && date.isBefore(item.startDate!.getDatePart()))
      return false;

    if (item.endDate != null && date.isAfter(item.endDate!.getDatePart()))
      return false;

    return true;
  }

  bool isAllowedForDate(DateTime date, {int? acceptDayOfWeek})
  {
    if (!isValidForDate(date)) return false;

    switch (type)
    {
      case TimeslotTypeCoreModel.Weekly:
        final dow = (acceptDayOfWeek != null) ? acceptDayOfWeek : date.weekday;
        return item.days.contains(dow.toString());

      case TimeslotTypeCoreModel.Monthly:
        final et = date.day.toString();
        return item.days.substring(1).split(',').contains(et);

      case TimeslotTypeCoreModel.Date:
        final et = dateTimeToIsoDate(date);
        return item.days.substring(1).split(',').contains(et);

      case TimeslotTypeCoreModel.Unknown:
        // nothing
        break;
    }

    return false;
  }

  TimeslotTimeRelationCoreModel howIsDateTime(DateTime dateTime, {int? acceptDayOfWeek})
  {
    if (!isAllowedForDate(dateTime, acceptDayOfWeek: acceptDayOfWeek))
      return TimeslotTimeRelationCoreModel.Unsuitable;

    final start = calcFullStartTime(dateTime);
    final end = calcFullEndTime(dateTime);

    if (dateTime.isBefore(start))
      return TimeslotTimeRelationCoreModel.Early;

    if (dateTime.isAfter(end))
      return TimeslotTimeRelationCoreModel.Late;

    return TimeslotTimeRelationCoreModel.InTime;
  }

  String getTimePeriodAsString()
  {
    final start = dateTimeToLocalString(item.startTime, timeOnly: true);
    final end = dateTimeToLocalString(item.endTime, timeOnly: true);

    return "$start - $end";
  }

  String getDaysAsString()
  {
    if (item.days.length > 1)
    {
      final days = item.days.substring(1);

      switch (type)
      {
        case TimeslotTypeCoreModel.Weekly:
          var daynames = _getNamesOfWeekDays().toList();
          var chars = List.filled(7, '\u25AA', growable: true);
          for (var i = 0; i < 7; i++)
          {
            if (days.contains(i.toString()))
            {
              chars[i] = daynames[i][0].toUpperCase();
            }
          }

          // Moving Sunday to the last position
          chars.add(chars[0]);
          chars.removeAt(0);

          // Space between Friday and Saturday
          chars.insert(5, ' ');

          return chars.join();

        case TimeslotTypeCoreModel.Date:
          final dt = DateTime.tryParse(days);
          if (dt != null)
            return dateTimeToLocalString(dt, dateOnly: true);
          break;

        case TimeslotTypeCoreModel.Monthly:
          final day = int.tryParse(days);
          if (day != null && day >= 1 && day <= 31)
            return day.toString();
          break;

        case TimeslotTypeCoreModel.Unknown:
          // nothing
          break;
      }
    }

    return "\u2014";
  }

  Iterable<String> _getNamesOfWeekDays() sync*
  {
    final format = DateFormat.EEEE();
    final oneDay = Duration(days: 1);

    var date = DateTime(2021, 8, 1); // known Sunday

    for (var i = 0; i<7; i++)
    {
      yield format.format(date);
      date = date.add(oneDay);
    }
  }
}

enum TimeslotTypeCoreModel
{
  Unknown,
  Weekly,
  Monthly,
  Date,
}

enum TimeslotTimeRelationCoreModel
{
  Early,
  InTime,
  Late,
  Unsuitable,
}