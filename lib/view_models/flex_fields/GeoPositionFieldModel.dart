import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/entities/rest/GeoPosition.dart';
import 'package:amigotools/services/geopos/ExternalMapProvider.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class GeoPositionFieldModel extends FlexFieldModel
{
  final _provider = $locator.get<ExternalMapProvider>();

  bool _canOpenMap = false;
  String _friendlyValue = "";

  GeoPositionFieldModel(FlexField flexField, dynamic value)
    : super(flexField, value);

  bool get canOpenMap => _canOpenMap;

  GeoPosition? get geoPosVal => value is GeoPosition ? value as GeoPosition : null;

  @override
  bool get hasNotEmptyValue => geoPosVal != null;

  @override
  String get friendlyValue => _friendlyValue;

  @override @protected
  void prepareFriendlyValueAndNotifyListenersInternal()
  {
    if (geoPosVal != null)
    {
      _friendlyValue = geoPosVal!.addr ?? "${geoPosVal!.lat},${geoPosVal!.lng}";
    }
    else
    {
      _friendlyValue = "";
    }

    notifyListeners();
  }

  @override @protected
  void initInternal(dynamic val) async
  {
    super.initInternal(val);

    _canOpenMap = await _provider.canOpenMap();
    notifyListeners();
  }

  void openOnMap() async
  {
    var opened = false;

    if (hasNotEmptyValue)
    {
      opened = await _provider.openMapWithPosition(geoPosVal!.lat, geoPosVal!.lng);
    }

    if (!opened)
    {
      // TODO
    }
  }
}