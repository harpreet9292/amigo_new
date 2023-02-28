class BriefDbItem
{
  final int id;
  final String? ident;
  final String title;
  final String? subtitle;
  final dynamic extra;

  const BriefDbItem({
    required this.id,
    this.ident,
    required this.title,
    this.subtitle,
    this.extra,
  });
}