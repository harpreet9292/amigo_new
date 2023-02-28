import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:amigotools/utils/data/HexHelper.dart';

typedef NfcProviderTagHandler = bool Function(NfcProviderReadResult result, String? tagid);

class NfcProvider extends ChangeNotifier
{
  final _handlers = <NfcProviderTagHandler>[];
  bool _isSessionStarted = false;

  Future<bool> get isServiceAvailable => NfcManager.instance.isAvailable();

  bool get isSessionStarted => _isSessionStarted;

  @override
  void dispose() async
  {
    if (_isSessionStarted)
    {
      await NfcManager.instance.stopSession();
      _isSessionStarted = false;
    }

    super.dispose();
  }

  void addHandler(NfcProviderTagHandler onDiscovered)
  {
    _handlers.remove(onDiscovered);
    _handlers.insert(0, onDiscovered);

    _ensureCorrectState();
  }

  void removeHandler(NfcProviderTagHandler onDiscovered)
  {
    _handlers.remove(onDiscovered);

    _ensureCorrectState();
  }

  void _ensureCorrectState() async
  {
    final shouldBeStarted = _handlers.isNotEmpty;

    if (_isSessionStarted == shouldBeStarted) return;

    if (shouldBeStarted)
    {
      if (await NfcManager.instance.isAvailable())
      {
        await NfcManager.instance.startSession(
          onDiscovered: _onDiscovered,
          onError: _onError,
        );

        _isSessionStarted = true;
        notifyListeners();
      }
    }
    else
    {
      await NfcManager.instance.stopSession();

      _isSessionStarted = false;
      notifyListeners();
    }
  }

  Future<void> _onError(NfcError error) async
  {
    _notifyHandlers(NfcProviderReadResult.Error, null);
  }

  Future<void> _onDiscovered(NfcTag tag) async
  {
    NfcProviderReadResult result;
    String? tagid;

    final nfca = NfcA.from(tag); // for Android

    if (nfca != null)
    {
      tagid = nfca.identifier.toHexString();
    }
    else
    {
      final mifare = MiFare.from(tag); // for iOS

      if (mifare != null)
      {
        tagid = mifare.identifier.toHexString();
      }
      else
      {
        tagid = null;
      }
    }

    if (tagid != null)
    {
      result = tagid.isNotEmpty && tagid.length < 50
        ? NfcProviderReadResult.Ok
        : NfcProviderReadResult.WrongValue;
    }
    else
    {
      result = NfcProviderReadResult.Incompatible;
    }

    _notifyHandlers(result, tagid);
  }

  void _notifyHandlers(NfcProviderReadResult result, String? tagid)
  {
    // toList is important, handler may unsubscribe
    for (var handler in _handlers.toList())
    {
      try
      {
        final processed = handler(result, tagid);

        if (processed)
        {
          break;
        }
      }
      catch (e)
      {
        Future.microtask(() => removeHandler(handler));
      }
    }
  }
}

enum NfcProviderReadResult
{
  Ok,
  Incompatible,
  WrongValue,
  Error,
}