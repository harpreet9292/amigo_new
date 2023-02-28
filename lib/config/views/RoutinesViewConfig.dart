import 'package:amigotools/utils/types/UiItem.dart';

class RoutinesViewConfig
{
  static const ScreenTitle = "Tasks";

  static const ItemMenuItems = const [
    UiItem(RoutinesViewKeys.Pause, "Pause"),
    UiItem(RoutinesViewKeys.Reject, "Reject"),
    UiItem(RoutinesViewKeys.Admit, "Admit"),
  ];
}

enum RoutinesViewKeys {
  Pause,
  Reject,
  Admit,
}