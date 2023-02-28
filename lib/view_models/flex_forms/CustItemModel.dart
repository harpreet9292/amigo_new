import 'package:flutter/foundation.dart';

import 'package:amigotools/services/storage/FlexCustItemsStorage.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';

import 'FlexItemModelBase.dart';

class CustItemModel extends FlexItemModelBase<FlexCustItemsStorage>
{
  CustItemModel.open(int itemId)
    : super.open(itemId, edit: false);

  @override @protected
  Future<FlexItemBase?> fetchItemInternal(int id) async
  {
    final items = await itemsStorage.fetch(id: id);
    return items.isNotEmpty ? items.first : null;
  }
}