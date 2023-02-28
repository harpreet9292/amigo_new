import 'package:amigotools/entities/abstractions/DbEntityBase.dart';

abstract class FlexItemBase extends DbEntityBase
{
  abstract final String entityIdent;
  abstract final int? groupId;
  abstract final Map<String, dynamic> values;
  abstract final String? headline;
}