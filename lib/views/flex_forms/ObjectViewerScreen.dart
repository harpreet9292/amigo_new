import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/view_models/flex_lists/OutcomeEntitiesListModel.dart';
import 'package:amigotools/views/flex_forms/FlexItemForm.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/config/views/ObjectsViewConfig.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/view_models/flex_forms/ObjectModel.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitModel.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/utils/types/UiItem.dart';
import 'package:amigotools/utils/views/ListDialog.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';
import 'package:amigotools/view_models/flex_forms/OutcomeModel.dart';
import 'package:amigotools/views/flex_lists/DbItemsListDialog.dart';

class ObjectViewerScreen extends StatelessWidget {
  final ObjectModel model;

  const ObjectViewerScreen(this.model);

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
            actions: buildAppBarActions<ObjectsViewKeys>(
              items: ObjectsViewConfig.ItemViewBarItems.where((x) {
                switch (x.key) {
                  case ObjectsViewKeys.Workflows:
                    return model.hasWorkflows &&
                        context
                            .watch<SettingsModel>()
                            .getBool(SettingsKeys.AllowUnscheduledVisits);
                  case ObjectsViewKeys.NewOutcome:
                    return true;
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
      BuildContext context, ObjectModel model, ObjectsViewKeys key) async {
    switch (key) {
      case ObjectsViewKeys.Workflows:
        _showWorkflowsListDialog(context,
            onSelect: (x) => Navigator.pushNamed(context, AppRoutes.objectvisit,
                arguments: ObjectVisitModel.create(
                    objectId: model.itemId, workflowId: x)));
        break;
      case ObjectsViewKeys.NewOutcome:
        showItemsListDialog(
          context,
          model: OutcomeEntitiesListModel(plural: false),
          onSelect: (ident) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.editoutcome,
              arguments: OutcomeModel.create(ident, initialVals: {
                "\$object": model.itemId,
                "\$group": model.groupId,
              }),
            );
          },
        );
        break;
    }
  }

  void _showWorkflowsListDialog(BuildContext context,
      {required Proc1<int> onSelect}) {
    final items = model.workflows.map((e) => UiItem(e.id, e.title));
    showListDialog(context, title: "Workflows".tr(), items: items,
        onSelect: (key) {
      onSelect(key);
      return false;
    });
  }
}
