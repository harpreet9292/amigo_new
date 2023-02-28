import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexObject.dart';
import 'package:amigotools/services/storage/FlexObjectsStorage.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';

import 'FlexItemModelBase.dart';

class ObjectModel extends FlexItemModelBase<FlexObjectsStorage>
{
  ObjectModel.open(int itemId)
    : super.open(itemId, edit: false);

  @override @protected
  Future<FlexItemBase?> fetchItemInternal(int id) async
  {
    final items = await itemsStorage.fetch(ids: [id]);
    return items.isNotEmpty ? items.first : null;
  }

  @override @protected
  dynamic getValueInternal(String fieldIdent)
  {
    switch (fieldIdent)
    {
      case "\$\$name":
        return (flexItemInternal as FlexObject).name;

      case "\$geopos":
        return (flexItemInternal as FlexObject).position;

      default:
        return super.getValueInternal(fieldIdent);
    }
  }

  int? get groupId => flexItemInternal?.groupId;

  bool get hasWorkflows
  {
    return flexItemInternal != null
      && (flexItemInternal as FlexObject).workflows != null
      && (flexItemInternal as FlexObject).workflows!.isNotEmpty;
  }

  Iterable<BriefDbItem> get workflows
  {
    return (flexItemInternal as FlexObject).workflows != null
        ? (flexItemInternal as FlexObject)
            .workflows!
            .map((x) => BriefDbItem(id: x.id, title: x.name))
        : [];
  }
}