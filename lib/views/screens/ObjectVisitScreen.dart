import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';
import 'package:amigotools/utils/types/ViewModelStatus.dart';
import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/config/views/WorkflowsViewConfig.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitModel.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/view_models/flex_forms/ObjectModel.dart';
import 'package:amigotools/views/flex_forms/ObjectViewerScreen.dart';
import 'package:amigotools/views/flex_lists/DbItemsListDialog.dart';
import 'package:amigotools/view_models/flex_forms/OutcomeModel.dart';
import 'package:amigotools/view_models/flex_lists/OutcomeEntitiesListModel.dart';

// ignore: must_be_immutable
class ObjectVisitScreen extends StatelessWidget {
  static const routeName = "/objectvisit";

  final ObjectVisitModel model;
  bool _drawerOpened = false;

  ObjectVisitScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, child) {
        var model = context.watch<ObjectVisitModel>();

        if (model.status == ViewModelStatus.Gone) {
          Future.microtask(() {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.root);
            }
          });
          return Scaffold(body: Container());
        }

        final statusLabel =
            model.workflowState != ObjectVisitStateModel.NotStarted
                ? "[${enumValueToString(model.workflowState)!.tr()}]"
                : "";

        final allowBack = Navigator.canPop(context) && (model.itemId == null || !model.canStop);

        return model.status == ViewModelStatus.Ready
            ? WillPopScope(
                onWillPop: () async => _drawerOpened || allowBack,
                child: Scaffold(
                  drawer: !allowBack
                      ? MainDrawer(
                          selectedItemKey: MainDrawerKeys.VisitsHeadline,
                          selectedItemId: model.itemId,
                        )
                      : null,
                  onDrawerChanged: (opened) => _drawerOpened = opened,
                  appBar: AppBar(
                    title: Text("${"Workflow".tr()} $statusLabel"),
                    actions: _buildBarItems(context),
                    leading: allowBack
                        ? IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          )
                        : null,
                  ),
                  body: Column(
                    children: [
                      _buildObjectInfoPanel(context),
                      _buildWorkflowInfoPanel(context),
                      _buildProcessInfoPanel(context),
                      _buildActivitiesPanel(context),
                    ],
                  ),
                ),
              )
            : Scaffold();
      },
    );
  }

  Widget _buildObjectInfoPanel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.objectInfo.title,
                  style: TextStyle(fontSize: 18),
                ),
                model.objectInfo.subtitle != null
                    ? Text(model.objectInfo.subtitle!)
                    : Container(),
              ],
            ),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.auto_stories_outlined,
                  color: GeneralConfig.palette2Primary600),
              onPressed: () => _openObjectDetails(context)),
        ],
      ),
    );
  }

  Widget _buildWorkflowInfoPanel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.workflowInfo.title,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              model.workflowInfo.subtitle != null
                  ? Text("${model.workflowInfo.subtitle!} ${"min".tr()}")
                  : Container(),
            ],
          ),
          model.timeslotInfo != null
              ? Text(model.timeslotInfo!.title)
              : Container(),
        ],
      ),
    );
  }

  Widget _buildProcessInfoPanel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Row(
        children: () sync* {
          if (model.canStart && model.stopTime == null)
            yield _buildProcessInfoItem(
              null,
              "Not started",
              ObjectVisitValueStyleModel.Normal,
            );

          if (model.startTimeStyle != ObjectVisitValueStyleModel.Hidden)
            yield _buildProcessInfoItem(
              "Started",
              dateTimeToLocalString(model.startTime!,
                  timeWithSecondsOnly: true),
              model.startTimeStyle,
            );

          if (model.durationStyle != ObjectVisitValueStyleModel.Hidden)
            yield TimerBuilder.periodic(
              Duration(seconds: 1),
              builder: (context) => _buildProcessInfoItem(
                "Duration",
                durationToString(model.duration),
                model.durationStyle,
              ),
            );

          if (model.stopTimeStyle != ObjectVisitValueStyleModel.Hidden)
            yield _buildProcessInfoItem(
              "Finished",
              dateTimeToLocalString(model.stopTime!, timeWithSecondsOnly: true),
              model.stopTimeStyle,
            );
          else if (model.pauseTime != null)
            yield _buildProcessInfoItem(
              "Paused",
              dateTimeToLocalString(model.pauseTime!,
                  timeWithSecondsOnly: true),
              ObjectVisitValueStyleModel.Normal,
            );
          else if (model.resumeTime != null)
            yield _buildProcessInfoItem(
              "Resumed",
              dateTimeToLocalString(model.resumeTime!,
                  timeWithSecondsOnly: true),
              ObjectVisitValueStyleModel.Normal,
            );
        }()
            .toList(),
      ),
    );
  }

  Expanded _buildProcessInfoItem(
      String? label, String value, ObjectVisitValueStyleModel style) {
    Color color;

    if (style == ObjectVisitValueStyleModel.Warning)
      color = GeneralConfig.palette2Primary2100;
    else if (style == ObjectVisitValueStyleModel.Problem)
      color = GeneralConfig.palette2SupportingRed100;
    else
      color = GeneralConfig.palette2SupportingCyan50;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(3),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(4.0),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            label != null ? Text(label).tr() : Container(),
            Text(
              value,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesPanel(BuildContext context) {
    final list = model.activities.map((x) {
      if (x.instructions)
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(x.title),
                    x.subtitle != null
                        ? Text(
                            x.subtitle!,
                            style: TextStyle(fontSize: 12),
                          )
                        : Container()
                  ],
                )
              ],
            ));
      else if (x.single)
        return Row(
          children: [
            Icon(x.completed
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded),
            GestureDetector(
              onTap: () => model.markActivityCompleted(x),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    x.title,
                    style: TextStyle(fontSize: 16),
                  ),
                  x.subtitle != null
                      ? Text(
                          x.subtitle!,
                          style: TextStyle(fontSize: 12),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        );
      else
        return Row(
          children: [
            Checkbox(
                value: x.completed,
                onChanged: (checked) => model.markActivityCompleted(x)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  x.title,
                  style: TextStyle(fontSize: 16),
                ),
                x.subtitle != null
                    ? Text(
                        x.subtitle!,
                        style: TextStyle(fontSize: 12),
                      )
                    : Container()
              ],
            )
          ],
        );
    });

    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          interactive: true,
          child: Column(
            children: list.toList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems(BuildContext context) {
    return buildAppBarActions<WorkflowsViewKeys>(
      items: WorkflowsViewConfig.ItemViewBarItems.where((x) {
        switch (x.key) {
          case WorkflowsViewKeys.Start:
            return model.canStart;
          case WorkflowsViewKeys.Stop:
            return model.canStop;
          case WorkflowsViewKeys.Pause:
            return model.canPause;
          case WorkflowsViewKeys.Resume:
            return model.canResume;
          case WorkflowsViewKeys.NewOutcome:
            return true;
        }
      }).toList(),
      onPressed: (key) => _onAction(context, model, key),
    );
  }

  void _onAction(
      BuildContext context, ObjectVisitModel model, WorkflowsViewKeys key) {
    switch (key) {
      case WorkflowsViewKeys.Start:
        model.start();
        break;
      case WorkflowsViewKeys.Stop:
        model.stop();
        break;
      case WorkflowsViewKeys.Pause:
        model.pause();
        break;
      case WorkflowsViewKeys.Resume:
        model.resume();
        break;
      case WorkflowsViewKeys.NewOutcome:
        showItemsListDialog(
          context,
          model: OutcomeEntitiesListModel(plural: false),
          onSelect: (ident) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.editoutcome,
              arguments: OutcomeModel.create(ident, initialVals: {
                "\$object": model.objectInfo.id,
                "\$group": model.objectInfo.extra,
              }),
            );
          },
        );
        break;
    }
  }

  void _openObjectDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(12.0),
        child: ObjectViewerScreen(ObjectModel.open(model.objectInfo.id)),
      ),
    );
  }
}
