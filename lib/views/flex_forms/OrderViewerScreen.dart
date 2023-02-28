import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/views/flex_forms/FlexItemForm.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/config/views/OrdersViewConfig.dart';
import 'package:amigotools/view_models/flex_forms/OrderModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';

class OrderViewerScreen extends StatelessWidget {
  final OrderModel model;

  const OrderViewerScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FlexItemModelBase>.value(
      value: model,
      builder: (context, child) {
        context.watch<FlexItemModelBase>();

        if (model.status == FlexItemModelStatus.Gone) {
          Future.microtask(() {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.root);
            }
          });

          return Scaffold(body: Container());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(model.entityName),
            actions: buildAppBarActions<OrdersViewKeys>(
              items: OrdersViewConfig.ItemViewBarItems.where((x) {
                switch (x.key) {
                  case OrdersViewKeys.TakeOrder:
                    return model.canTakeOrder;
                  case OrdersViewKeys.RefuseOrder:
                    return model.canRefuseOrder;
                  case OrdersViewKeys.CloseOrder:
                    return model.canCloseOrder;
                  case OrdersViewKeys.NewOutcome:
                    return model.canCreateOutcome;
                  case OrdersViewKeys.EditOutcome:
                    return model.canEditOutcome;
                }
              }).toList(),
              onPressed: (key) => _onAction(context, model, key),
            ),
          ),
          body: FlexItemForm(),
        );
      },
    );
  }

  void _onAction(
      BuildContext context, OrderModel model, OrdersViewKeys key) async {
    switch (key) {
      case OrdersViewKeys.TakeOrder:
        await model.takeOrder();
        break;

      case OrdersViewKeys.RefuseOrder:
        await model.refuseOrder();
        break;

      case OrdersViewKeys.CloseOrder:
        await model.closeOrder();
        break;

      case OrdersViewKeys.NewOutcome:
        final outcome = model.createOutcome();
        if (outcome != null) {
          // todo: pop until root! and for edit!
          Navigator.popAndPushNamed(
            context,
            AppRoutes.editoutcome,
            arguments: outcome,
          );
        }
        break;

      case OrdersViewKeys.EditOutcome:
        final outcome = model.getOutcomeToEdit();
        if (outcome != null) {
          Navigator.popAndPushNamed(
            context,
            AppRoutes.editoutcome,
            arguments: outcome,
          );
        }
        break;
    }
  }
}
