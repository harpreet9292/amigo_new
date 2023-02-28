import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';
import 'package:amigotools/services/storage/FlexCustItemsStorage.dart';

class CustItemsListModel extends DbItemsListModelBase<FlexCustItemsStorage>
{
  final String? entityIdent;
  final int? groupId;
  final int? objectId;
  final int? outcomeId;

  CustItemsListModel({required this.entityIdent, this.groupId, this.objectId, this.outcomeId});

  String get title => "Collections";

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    return await itemsStorage.fetchBrief(
      entityIdent: entityIdent,
      groupId: groupId,
      objectId: objectId,
      outcomeId: outcomeId,
      search: searchString.isNotEmpty ? searchString : null,
    );
  }
}