import 'dart:ui' as ui;
import 'package:intl/intl.dart';

String? dateTimeToIsoDate(DateTime? dt)
{
  if (dt == null) return null;

  final iso = dt.toIso8601String();
  return iso.split('T')[0];
}

String? dateTimeToIsoDateTime(DateTime? dt)
{
  if (dt == null) return null;

  final iso = dt.toIso8601String();
  return iso.split('.')[0] + (iso.lastIndexOf('Z') > 0 ? 'Z' : '');
}

String? dateTimeToIsoTime(DateTime? dt)
{
  if (dt == null) return null;

  final iso = dt.toIso8601String();
  final isotime = iso.split('T')[1];
  return isotime.split('.')[0];
}

DateTime parseIsoTime(String isoTime)
{
  if (!isoTime.contains('T'))
  {
    isoTime = "0001-01-01T$isoTime";
  }
  
  return DateTime.parse(isoTime);
}

String dateTimeToLocalString(DateTime dt, {bool dateOnly = false, bool timeOnly = false, bool timeWithSecondsOnly = false})
{
  DateFormat df;

  if (dateOnly)
    df = DateFormat.yMd(ui.window.locale.languageCode);
  else if (timeOnly)
    df = DateFormat.Hm(ui.window.locale.languageCode);
  else if (timeWithSecondsOnly)
    df = DateFormat.Hms(ui.window.locale.languageCode);
  else
    df = DateFormat.yMd(ui.window.locale.languageCode).add_Hm();

  return df.format(dt);
}

String durationToString(Duration duration)
{
  final timearr = [
    (duration.inHours > 48 ? duration.inHours.remainder(24) : duration.inHours).toString(),
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
  ];

  var timestr = timearr.join(':');

  if (duration.inHours > 48)
  {
    timestr = "${duration.inDays}.$timestr";
  }

  return timestr;
}

extension DateTimeExtension on DateTime
{
  DateTime getDatePart() => DateTime(year, month, day);
}