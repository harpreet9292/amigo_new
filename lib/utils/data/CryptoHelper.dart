import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String str)
{
  return md5.convert(utf8.encode(str)).toString();
}