String valuesForSqlOperatorIn(Iterable list)
{
  if (list.isEmpty)
    throw ArgumentError("list is empty");

  final str = list
    .map((x) =>
      x != null
      ? "'${x.toString().replaceAll("'", "''")}'"
      : "null"
    )
    .join(',');

  return "($str)";
}

String escapeForSqlOperatorLike(String str)
{
  return str
    .replaceAll("'", "''")
    .replaceAll("_", "\\_")
    .replaceAll("%", "\\%");
}

String keepString(dynamic value)
{
  return value.toString();
}

extension BoolExtension on bool
{
  num toNum()
  {
    return this ? 1 : 0;
  }
}