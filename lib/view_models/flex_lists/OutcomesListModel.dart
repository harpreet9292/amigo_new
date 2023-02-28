import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/services/storage/FlexOutcomesStorage.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';

class OutcomesListModel extends DbItemsListModelBase<FlexOutcomesStorage>
{
  final _entitiesStorage = $locator.get<FlexEntitiesStorage>();

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    await _entitiesStorage.ensureFilledCache();

    return await itemsStorage.fetchBrief(
      solveIdent: (ident, hash)
      {
        final name = ident is String ? _entitiesStorage.getCachedBriefItem(ident)?.title : null;
        if (name != null)
        {
          final id = hash["id"] as int;
          final sid = id > 0 ? "#$id" : "(${id*-1})";
          return "$name $sid";
        }

        return null;
      },
    );
  }
}