import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/config/views/FlexItemEditorScreenConfig.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/views/flex_forms/FlexItemForm.dart';
import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/views/shared/WaitingDialog.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';

// ignore: must_be_immutable
class FlexItemEditorScreen extends StatelessWidget {
  static const routeName = "/edititem";

  final FlexItemModelBase model;
  bool _drawerOpened = false;

  FlexItemEditorScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, child) {
        final status = context.select<FlexItemModelBase, FlexItemModelStatus>(
            (model) => model.status);

        if (status == FlexItemModelStatus.Gone) {
          Future.microtask(() {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.root);
            }
          });

          return Scaffold(body: Container());
        }

        return WillPopScope(
          onWillPop: () async => _drawerOpened,
          child: Scaffold(
            drawer: MainDrawer(selectedItemKey: MainDrawerKeys.OutcomesHeadline, selectedItemId: model.itemId),
            onDrawerChanged: (opened) => _drawerOpened = opened,
            appBar: AppBar(
              title: Text(context.select<FlexItemModelBase, String>(
                  (model) => model.entityName)),
              actions: buildAppBarActions<FlexItemEditorScreenKeys>(
                  items: FlexItemEditorScreenConfig.BarItems,
                  onPressed: (key) => _onAction(context, key)),
            ),
            body: FlexItemForm(),
          ),
        );
      },
    );
  }

  void _onAction(BuildContext context, FlexItemEditorScreenKeys key) async {
    switch (key) {
      case FlexItemEditorScreenKeys.Send:
        if (model.canSend)
          showWaitingDialog(context, text: "Sending".tr() + "...");

        final res = await model.send();

        if (model.canSend) Navigator.pop(context);

        if (res) {
          Navigator.pushReplacementNamed(context, AppRoutes.root);
        }
        break;

      case FlexItemEditorScreenKeys.Delete:
        if (!await model.delete()) {
          // push if not deleted only because when success delete will change status to Gone
          Navigator.pushReplacementNamed(context, AppRoutes.root);
        }
        break;

      default:
    }
  }
}
