import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import 'package:amigotools/entities/rest/GeoPosition.dart';

class GeoLocationProvider extends ChangeNotifier
{
  final Location _location = Location();

  GeoLocationServiceState _state = GeoLocationServiceState.Unknown;

  GeoLocationServiceState get serviceState => _state;

  GeoLocationProvider(/*{required bool backgroundChannel}*/)
  {
    // todo: use flutter_isolate 2.0.0

    //if (backgroundChannel)
    //  _location.enableBackgroundMode(enable: true);
  }

  Future<bool> isServiceAvailable() async
  {
    try
    {
      var enabled = await _location.serviceEnabled();

      if (!enabled)
      {
        enabled = await _location.requestService();
        if (!enabled)
        {
          if (_state != GeoLocationServiceState.Disabled)
          {
            _state = GeoLocationServiceState.Disabled;
            notifyListeners();
          }

          return false;
        }
      }

      var permission = await _location.hasPermission();

      if (permission != PermissionStatus.granted && permission != PermissionStatus.grantedLimited)
      {
        permission = await _location.requestPermission();
      }

      _updateState(permission);

      return permission == PermissionStatus.granted || permission == PermissionStatus.grantedLimited;
    }
    catch (e)
    {
      _state = GeoLocationServiceState.Error;
      print(e);
      return false;
    }
  }

  Future<GeoPosition?> getPosition() async
  {
    if (!await isServiceAvailable())
      return null;

    final locData = await _location.getLocation();

    if (locData.latitude != null && locData.longitude != null && locData.time != null)
    {
      return GeoPosition(
        lat: locData.latitude!,
        lng: locData.longitude!,
        accur: locData.accuracy != null ? double.parse(locData.accuracy!.toStringAsFixed(2)) : null,
        speed: locData.speed,
        time: DateTime.fromMillisecondsSinceEpoch(locData.time!.toInt()),
      );
    }
    else
    {
      return null;
    }
  }

  void _updateState(PermissionStatus permStatus)
  {
    GeoLocationServiceState newstate;

    switch (permStatus)
    {
      case PermissionStatus.granted:
        newstate = GeoLocationServiceState.Available;
        break;
      case PermissionStatus.grantedLimited:
        newstate = GeoLocationServiceState.AvailableLimited;
        break;
      case PermissionStatus.denied:
        newstate = GeoLocationServiceState.Denied;
        break;
      case PermissionStatus.deniedForever:
        newstate = GeoLocationServiceState.DeniedForever;
        break;
    }

    if (_state != newstate)
    {
      _state = newstate;
      notifyListeners();
    }
  }
}

enum GeoLocationServiceState
{
  Unknown,
  Disabled,
  Available,
  AvailableLimited,
  Denied,
  DeniedForever,
  Error,
}