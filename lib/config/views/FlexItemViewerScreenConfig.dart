import 'package:amigotools/utils/types/UiItem.dart';

class FlexItemViewerScreenConfig
{
  static const BarItems = const <UiItem<FlexItemViewerScreenKeys>>[
    //UiItem(FlexItemViewerScreenKeys.Search, "Search", icon: Icons.search, fav: true),
    //UiItem(FlexItemViewerScreenKeys.NewOutcome, "Outcome", icon: Icons.add),
  ];

  static const IdentifierFieldName = "Identifier";
}

enum FlexItemViewerScreenKeys
{
  Search,
  NewOutcome,
}