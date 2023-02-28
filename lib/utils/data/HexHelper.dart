import 'dart:typed_data';

extension Uint8ListExtension on Uint8List
{
  String toHexString({String separator='', String empty=''})
  {
    return isNotEmpty
      ? map((x) => x.toRadixString(16).padLeft(2, '0')).join(separator).toUpperCase()
      : empty;
  }
}