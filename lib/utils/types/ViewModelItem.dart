import 'package:amigotools/utils/types/BriefDbItem.dart';

class ViewModelItem
{
  final dynamic key;
  final String title;
  final String? subtitle1;
  final String? subtitle2;
  final String? subtitle3;
  final dynamic extra;

  const ViewModelItem({
    required this.key,
    required this.title,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
    this.extra,
  });

  ViewModelItem.fromBriefDbItem(BriefDbItem dbitem)
      : this.key = dbitem.id,
        this.title = dbitem.title,
        this.subtitle1 = dbitem.subtitle,
        this.subtitle2 = null,
        this.subtitle3 = null,
        this.extra = dbitem.extra;
}