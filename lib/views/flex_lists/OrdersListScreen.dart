import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/utils/views/ScaffoldWithSearch.dart';
import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/views/shared/GroupedCardsList.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/view_models/flex_lists/OrdersListModel.dart';
import 'package:amigotools/views/flex_forms/OrderViewerScreen.dart';
import 'package:amigotools/view_models/flex_forms/OrderModel.dart';
import 'package:amigotools/config/views/OrdersViewConfig.dart';

class OrdersListScreen extends StatelessWidget {
  static const routeName = "/orders";

  final bool selectionMode;

  const OrdersListScreen({this.selectionMode = false});

  @override
  Widget build(BuildContext context) {
    final model = OrdersListModel();

    return ScaffoldWithSearch(
      title: OrdersViewConfig.ScreenTitle.tr(),
      drawer: !selectionMode
          ? MainDrawer(selectedItemKey: MainDrawerKeys.OrdersScreen)
          : null,
      body: ChangeNotifierProvider.value(
        value: model,
        child: Consumer<OrdersListModel>(
          builder: (context, model, _) => GroupedCardsList(
            groups: OrderGroupType.values
                .map((x) =>
                    BriefDbItem(id: x.index, title: enumValueToString(x)!.tr()))
                .toList(),
            onGetItemsForGroup: (item) =>
                model.getItemsForGroupType(OrderGroupType.values[item.id]),
            onTap: (id) => _openDetails(context, model, id),
          ),
        ),
      ),
      searchHint: "Search".tr(),
      onSearchChanged: (search) => model.searchString = search,
      blockBackButton: !selectionMode,
    );
  }

  void _openDetails(BuildContext context, OrdersListModel model, int id) async {
    final itemmodel = OrderModel.open(id);
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(12.0),
        child: OrderViewerScreen(itemmodel),
      ),
    );
  }
}
