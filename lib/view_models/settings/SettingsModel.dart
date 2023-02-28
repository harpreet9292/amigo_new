import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/settings/SettingsProvider.dart';
import 'package:flutter/foundation.dart';

class SettingsModel extends ChangeNotifier
{
  final _settings = $locator.get<SettingsProvider>();

  SettingsModel()
  {
    _settings.addListener(_onSettingsListener);
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _settings.removeListener(_onSettingsListener);
    super.dispose();
  }

  bool getBool(SettingsKeys key) => _settings.get<bool>(key);
  String getString(SettingsKeys key) => _settings.get<String>(key);
  int getInt(SettingsKeys key) => _settings.get<int>(key);
  double getDouble(SettingsKeys key) => _settings.get<double>(key);

  void _onSettingsListener()
  {
    notifyListeners();
  }
}