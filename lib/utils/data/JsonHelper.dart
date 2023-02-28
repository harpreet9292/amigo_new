import 'dart:convert';

import 'package:amigotools/utils/types/Func.dart';

Iterable<T>? jsonDecodeAndMapList<T>(String? json, {required Func1<dynamic, T> mapper})
{
  if (json != null && json.isNotEmpty)
  {
    final Iterable<dynamic> rows = jsonDecode(json);
    return rows.map(mapper);
  }
  else
  {
    return null;
  }
}

bool jsonDecodeValueToBool(dynamic val)
{
  if (val is bool)
    return val;
  else if (val is int)
    return val != 0;
  else if (val is String)
    return val.toLowerCase() == "true";
  else
    return false;
}