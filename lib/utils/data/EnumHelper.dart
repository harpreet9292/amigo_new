String? enumValueToString(Object? value)
{
  if (value != null)
  {
    final arr = value.toString().split('.');

    if (arr.length != 2)
    {
      throw ArgumentError("Argument value should be enum value");
    }

    return arr[1];
  }

  return null;
}

T enumValueFromString<T>(Iterable<T> values, String value) {
  return values.cast<T>().firstWhere(
    (type) => type.toString().split(".").last == value);
}