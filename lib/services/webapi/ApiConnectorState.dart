import 'package:amigotools/entities/rest/AuthStatus.dart';

abstract class ApiConnectorState
{
  String? get consumerIdent;
  set consumerIdent(String? val);

  String? get sysKey;
  set sysKey(String? val);
  
  AuthStatus? get authStatus;
  set authStatus(AuthStatus? val);

  String? get pinMd5;
  set pinMd5(String? val);
}