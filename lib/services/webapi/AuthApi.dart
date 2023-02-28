import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/utils/data/CryptoHelper.dart';

class AuthApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<String?> sysLogin(
    {required String ident, required String pass, required String devid, required String devname}) async
  {
    _connector.useIdentOrFromSettings(ident);

    final resp = await _connector.request(
      WebApiConfig.SysLoginApiPath,
      queryParams: {
        "pass": generateMd5(pass),
        "devid": devid,
        "devname": devname,
        "api": WebApiConfig.ApiVersion.toString(),
      },
      authIfLost: false,
    );

    _connector.useIdentOrFromSettings(null);

    return resp;
  }
}