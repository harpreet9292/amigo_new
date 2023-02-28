import 'dart:io';
import 'package:flutter/services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoProvider
{
  late final String uuid;
  late final String deviceName;
  late final String osVersion;

  late final String appName;
  late final String appVersion;

  bool _initialized = false;

  Future<void> ensureInit() async
  {
    if (!_initialized)
    {
      await _ensureInitDeviceInfo();
      await _ensureInitPackageInfo();

      _initialized = true;
    }
  }

  Future<void> _ensureInitDeviceInfo() async
  {
    final deviceInfoPlugin = new DeviceInfoPlugin();

    try
    {
      if (Platform.isAndroid)
      {
        final data = await deviceInfoPlugin.androidInfo;
        uuid = data.androidId!;
        deviceName = data.model ?? "?";
        osVersion = data.version.release ?? "?";
      }
      else if (Platform.isIOS)
      {
        final data = await deviceInfoPlugin.iosInfo;
        uuid = data.identifierForVendor!;
        deviceName = data.name ?? "?";
        osVersion = data.systemVersion ?? "?";
      }
    }
    on PlatformException
    {
      print('Failed to get platform info');
    }
}

  Future<void> _ensureInitPackageInfo() async
  {
    final packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    appVersion = packageInfo.version;
  }
}