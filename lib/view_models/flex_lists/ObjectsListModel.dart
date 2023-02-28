import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';

class ObjectsListModel extends DbItemsListModelBase<FlexObjectsStorage>
{
  final int? groupId;

  ObjectsListModel({this.groupId});

  @override
  String get title => "Objects";

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    List<int> grpids;
    
    if (groupId != null)
    {
      grpids = allowedGroupIds.contains(groupId!) ? [groupId!] : [0];
    }
    else
    {
      grpids = allowedGroupIds;
    }

    return await itemsStorage.fetchBrief(
      groupIds: grpids,
      search: searchString.isNotEmpty ? searchString : null,
    );
  }
}