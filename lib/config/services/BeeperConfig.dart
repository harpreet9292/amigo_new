import 'package:amigotools/utils/types/Pair.dart';

abstract class BeeperConfig
{
  static const SoundsFilesPath = "assets/sounds/";

  static const Patterns = const <SignalTypes, Pair<List<int>?, String?>>{
    SignalTypes.Incoming: Pair([500, 1000, 500, 2000], null),
  };
}

enum SignalTypes
{
  Incoming,
  Message,
  Warning,

  Started,
  Accepted,
  Completed,

  Unsuitable,
  Duplicate,
  Unknown,
}