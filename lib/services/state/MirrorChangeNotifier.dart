import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

abstract class MirrorChangeNotifier extends ChangeNotifier
{
  final _service = FlutterBackgroundService();
  late final StreamSubscription _subscription;
  late final String _typeName;

  MirrorChangeNotifier()
  {
    _typeName = runtimeType.toString();

    _subscription = _service.onDataReceived.listen((event)
    {
      if (event?["notify_mirrors"] == _typeName)
      {
        super.notifyListeners();
      }
    });
  }

  @override
  @mustCallSuper
  void notifyListeners()
  {
    _service.sendData({"notify_mirrors": _typeName});
    super.notifyListeners();
  }

  @override
  @mustCallSuper
  void dispose()
  {
    _subscription.cancel();
    super.dispose();
  }
}