import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/config/views/FlexItemViewerScreenConfig.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/views/flex_forms/FlexItemForm.dart';

class FlexItemViewerScreen extends StatelessWidget {
  final FlexItemModelBase model;

  const FlexItemViewerScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: model,
        builder: (context, child) {
          var model = context.watch<FlexItemModelBase>();

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
              actions: buildAppBarActions<FlexItemViewerScreenKeys>(
                items: FlexItemViewerScreenConfig.BarItems,
                onPressed: (key) => _onAction(context, model, key),
              ),
            ),
            body: FlexItemForm(),
          );
        });
  }

  void _onAction(BuildContext context, FlexItemModelBase model,
      FlexItemViewerScreenKeys key) {
    switch (key) {
      default:
    }
  }
}
