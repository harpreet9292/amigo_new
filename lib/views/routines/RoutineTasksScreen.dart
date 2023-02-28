import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/view_models/routines/RoutineTaskModel.dart';
import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/utils/types/ViewModelItem.dart';
import 'package:amigotools/view_models/routines/RoutineScreenModel.dart';
import 'package:amigotools/view_models/routines/RoutinesListModel.dart';
import 'package:amigotools/views/shared/GroupedCardsList.dart';
import 'package:amigotools/view_models/routines/RoutineTasksListModel.dart';
import 'package:amigotools/utils/views/ScaffoldWithSearch.dart';
import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/config/views/RoutinesViewConfig.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';

class RoutineTasksScreen extends StatelessWidget {
  static const routeName = "/routines";

  RoutineTasksScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RoutineScreenModel(),
        builder: (context, child) {
          final scrModel = context.watch<RoutineScreenModel>();

          return ScaffoldWithSearch(
            title: RoutinesViewConfig.ScreenTitle.tr(),
            drawer: MainDrawer(selectedItemKey: MainDrawerKeys.RoutinesScreen),
            body: Column(
              children: [
                _buildRoutineSelector(context),
                Expanded(child: _buildTasksList(context)),
              ],
            ),
            searchHint: "Search".tr(),
            onSearchChanged: scrModel.currentRoutine != null
                ? (search) => scrModel
                    .currentRoutine!.tasksListModel.searchString = search
                : null,
            blockBackButton: true,
          );
        });
  }

  Widget _buildRoutineSelector(BuildContext context) {
    final scrModel = context.watch<RoutineScreenModel>();

    return ChangeNotifierProvider.value(
        value: scrModel.routinesList,
        builder: (context, child) {
          final model = context.watch<RoutinesListModel>();
          return DropdownButton<int>(
            isExpanded: true,
            items: model.items
                .map((e) => DropdownMenuItem(
                      child: ListTile(
                        title: Text(e.name),
                        subtitle: Text(e.timePeriod ?? ""),
                        trailing: e.date != null ? Text(e.date!) : null,
                      ),
                      value: e.id,
                    ))
                .toList(),
            onChanged: (id) => scrModel.setCurrentRoutine(id!),
            value: scrModel.currentRoutine?.id,
          );
        });
  }

  Widget _buildTasksList(BuildContext context) {
    final scrModel = context.watch<RoutineScreenModel>();
    if (scrModel.currentRoutine == null) return Container();

    return ChangeNotifierProvider.value(
      value: scrModel.currentRoutine!.tasksListModel,
      child: Consumer<RoutineTasksListModel>(
        builder: (context, model, _) => GroupedCardsList(
          groups: model.getAvailableGroups(),
          onGetItemsForGroup: (group) =>
              model.getItemsForGroup(group).map((x) => ViewModelItem(
                    key: x,
                    title: x.object,
                    subtitle1: x.workflow,
                    subtitle2: x.period,
                  )),
          onTap: (task) => _openDetails(context, task),
          onGetMenuItems: context
                  .watch<SettingsModel>()
                  .getBool(SettingsKeys.AllowTaskRejectAndAdmit)
              ? (item) sync* {
                  if (item.isRejected)
                    yield* RoutinesViewConfig.ItemMenuItems.where(
                        (x) => x.key == RoutinesViewKeys.Admit);
                  else
                    yield* RoutinesViewConfig.ItemMenuItems.where(
                        (x) => x.key == RoutinesViewKeys.Reject);
                }
              : null,
          onMenuItemSelect: (item, key) => _onAction(context, item, key),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, RoutineTaskModel taskModel) async =>
      Navigator.pushNamed(
        context,
        AppRoutes.objectvisit,
        arguments: taskModel.getObjectVisitModel(),
      );

  void _onAction(BuildContext context, RoutineTaskModel item, RoutinesViewKeys key) {
    switch (key)
    {
      case RoutinesViewKeys.Pause:
        item.pauseObjectVisit();
        break;

      case RoutinesViewKeys.Reject:
        item.setRejectStatus(true);
        break;

      case RoutinesViewKeys.Admit:
        item.setRejectStatus(false);
        break;
    }
  }
}
