import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexGroup.dart';
import 'package:amigotools/services/storage/FlexGroupsStorage.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';

import 'FlexItemModelBase.dart';

class GroupModel extends FlexItemModelBase<FlexGroupsStorage>
{
  GroupModel.open(int itemId)
    : super.open(itemId, edit: false);

  @override @protected
  Future<FlexItemBase?> fetchItemInternal(int id) async
  {
    final items = await itemsStorage.fetch(id: id);
    return items.isNotEmpty ? items.first : null;
  }

  @override @protected
  dynamic getValueInternal(String fieldIdent)
  {
    switch (fieldIdent)
    {
      case "\$\$name":
        return (flexItemInternal as FlexGroup).name;

      default:
        return super.getValueInternal(fieldIdent);
    }
  }
}