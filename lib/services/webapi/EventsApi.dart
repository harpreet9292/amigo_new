import 'package:amigotools/entities/workflows/ObjectEventExample.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';

class EventsApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<bool> sendObjectEvent(ObjectEventExample event, {required String? uid}) async
  {
    final mapdata = event.toJson();

    mapdata.remove('id');
    mapdata.removeWhere((key, value) => key.startsWith("sys_"));

    if (uid != null)
    {
      // hotfix until routines structure on server part is not refactored
      mapdata["routineTaskId"] = uid;
    }

    final resp = await _connector.request(
      WebApiConfig.ObjectEventsApiPath,
      postData: mapdata,
    );

    return resp != null;
  }
}