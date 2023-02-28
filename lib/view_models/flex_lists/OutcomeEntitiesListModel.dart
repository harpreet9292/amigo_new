import 'package:flutter/foundation.dart';

import 'package:amigotools/entities/flexes/FlexEntity.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';

class OutcomeEntitiesListModel extends DbItemsListModelBase<FlexEntitiesStorage>
{
  final bool plural;
  final bool? isFav;
  final bool? atMenu;
  final bool? atLogin;
  final bool? atLogout;

  OutcomeEntitiesListModel({required this.plural, this.isFav, this.atMenu, this.atLogin, this.atLogout});
 
  @override
  String get title => "Outcome type";

  @override @protected
  Future<Iterable<BriefDbItem>> fetchBriefItemsInternal() async
  {
    return await itemsStorage.fetchBrief(
      getPlural: plural,
      types: [FlexEntityType.Outcome, FlexEntityType.Order],
      hasRoleCreate: authUserRole,
      isFav: isFav,
      atMenu: atMenu,
      atLogin: atLogin,
      atLogout: atLogout,
    );
  }
}