import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';

class SettingsProvider extends ChangeNotifier
{
  bool _silentMode = false;

  late final SharedPreferences prefs;

  Future<void> init() async
  {
    prefs = await SharedPreferences.getInstance();

    if (kDebugMode)
    {
      if (SettingsConfig.DefaultValues.length != SettingsKeys.values.length)
      {
        throw UnimplementedError("Not all SettingsKeys values have a default value in SettingsConfig.DefaultValues");
      }
    }
  }

  void setSilentMode(bool enable)
  {
    if (_silentMode != enable)
    {
      _silentMode = enable;

      if (!_silentMode)
      {
        notifyListeners();
      }
    }
  }

  void reload() async
  {
    await prefs.reload();
    notifyListeners();
  }

  T get<T>(SettingsKeys key)
  {
    final keystr = enumValueToString(key)!;

    try
    {
      if (T == dynamic)
      {
        throw ArgumentError("Generic argument T should have specific type");
      }
      else if ("" is T) // String or nullable String
      {
        return prefs.getString(keystr) ?? SettingsConfig.DefaultValues[key];
      }
      else if (1 is T) // int or nullable int
      {
        return prefs.getInt(keystr) ?? SettingsConfig.DefaultValues[key];
      }
      else if (1.1 is T) // double or nullable double
      {
        return prefs.getDouble(keystr) ?? SettingsConfig.DefaultValues[key];
      }
      else if (true is T) // bool or nullable bool
      {
        return prefs.getBool(keystr) ?? SettingsConfig.DefaultValues[key];
      }
    }
    on TypeError
    {
      return SettingsConfig.DefaultValues[key];
    }

    // else
    throw TypeError();
  }

  void set(SettingsKeys key, dynamic value)
  {
    final keystr = enumValueToString(key)!;
    
    if (kDebugMode)
    {
      if (value != null
        && SettingsConfig.DefaultValues[key] != null
        && SettingsConfig.DefaultValues[key].runtimeType != value.runtimeType)
      {
        throw TypeError();
      }
    }

    setRaw(keystr, value);
  }

  void setRaw(String keystr, dynamic value)
  {
    // setters and remove() of prefs are async for background saving to storage only,
    // it's enough for us that it makes changes in internal cache first... why we will not wait for them

    if (value is String)
    {
      prefs.setString(keystr, value); // ignoring of returned Future<bool>
    }
    else if (value is int)
    {
      prefs.setInt(keystr, value);
    }
    else if (value is double)
    {
      prefs.setDouble(keystr, value);
    }
    else if (value is bool)
    {
      prefs.setBool(keystr, value);
    }
    else if (value == null)
    {
      if (prefs.containsKey(keystr))
        prefs.remove(keystr); // ignoring of returned Future<bool>
    }
    else
    {
      throw TypeError();
    }

    if (!_silentMode)
      notifyListeners();
  }

  void remove(SettingsKeys key)
  {
    final keystr = enumValueToString(key)!;

    if (prefs.containsKey(keystr))
    {
      prefs.remove(keystr); // ignoring of returned Future<bool>
    }
  }
}