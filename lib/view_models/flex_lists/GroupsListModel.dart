import 'package:flutter/foundation.dart';

import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';
import 'package:amigotools/services/storage/FlexGroupsStorage.dart';

class GroupsListModel extends DbItemsListModelBase<FlexGroupsStorage>
{
  final int? parentGroupId;

  GroupsListModel({this.parentGroupId});

  @override
  String get title => "Groups";

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    return await itemsStorage.fetchBrief(
      ids: allowedGroupIds,
      groupId: parentGroupId,
      search: searchString.isNotEmpty ? searchString : null,
    );
  }
}