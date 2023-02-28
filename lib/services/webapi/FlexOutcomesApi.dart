import 'dart:io';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/utils/data/JsonHelper.dart';
import 'package:amigotools/config/services/WebApiConfig.dart';
import 'package:amigotools/services/webapi/ApiConnector.dart';
import 'package:amigotools/entities/flexes/FlexOutcome.dart';

class FlexOutcomesApi
{
  final _connector = $locator.get<ApiConnector>();

  Future<Iterable<FlexOutcome>?> fetchOutcomes({List<int>? ids}) async
  {
    return jsonDecodeAndMapList<FlexOutcome>(
      await _connector.request(WebApiConfig.OutcomesApiCat, queryIds: ids),
      mapper: (item) => FlexOutcome.fromJson(item),
    );
  }

  Future<int?> sendOutcome(FlexOutcome outcome) async
  {
    final mapdata = outcome.toJson();

    mapdata.removeWhere((key, value) => key.startsWith("sys_"));

    if (mapdata['id'] is int && mapdata['id'] <= 0)
    {
      mapdata.remove('id');
    }

    final resp = await _connector.request(
      WebApiConfig.OutcomesApiCat,
      postData: mapdata,
    );

    // return assigned id
    return resp != null ? int.tryParse(resp) : null;
  }

  Future<bool> sendImage(int itemId, File file) async
  {
    final resp = await _connector.upload(
      "${WebApiConfig.OutcomesImageApiPath}/$itemId",
      file: file,
    );

    return resp;
  }
}