import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/view_models/account/LoginModel.dart';
import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/view_models/flex_forms/OutcomeModel.dart';
import 'package:amigotools/views/screens/AboutScreen.dart';
import 'package:amigotools/views/flex_lists/DbItemsListDialog.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/view_models/general/AppStateModel.dart';
import 'package:amigotools/view_models/flex_lists/OutcomesListModel.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitModel.dart';
import 'package:amigotools/view_models/workflows/ObjectVisitsListModel.dart';
import 'package:amigotools/view_models/flex_lists/OutcomeEntitiesListModel.dart';

class MainDrawer extends StatelessWidget {
  final MainDrawerKeys? selectedItemKey;
  final int? selectedItemId;

  MainDrawer({this.selectedItemKey, this.selectedItemId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateModel, SettingsModel>(
      builder: (context, stateModel, settingsModel, _) => Drawer(
        child: Column(
          children: [
            _createHeader(context, stateModel, settingsModel),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Scrollbar(
                  interactive: true,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (_) => OutcomesListModel()),
                      ChangeNotifierProvider(
                          create: (_) => ObjectVisitsListModel()),
                    ],
                    child: Consumer2<OutcomesListModel, ObjectVisitsListModel>(
                      builder: (context, outcomesModel, visitsModel, _) =>
                          ListView(
                        padding: EdgeInsets.zero,
                        //itemExtent: 40.0,
                        children: List<Widget>.from(() sync* {
                          for (final item in MainDrawerConfig.Items) {
                            if (!_isAllowedMenuItem(item.key, settingsModel))
                              continue;

                            final subitems = item.subitems != null
                                ? item.subitems!.where((x) =>
                                    _isAllowedMenuItem(x.key, settingsModel))
                                : null;

                            if (subitems == null || subitems.length > 0)
                              yield _createDivider(item.title);

                            if (subitems != null) {
                              for (final subitem in subitems) {
                                yield _createItemTile(
                                  title: subitem.title,
                                  icon: subitem.icon,
                                  highlighted: subitem.key == selectedItemKey,
                                  onTap: () => _onAction(context, subitem.key),
                                );
                              }
                            }

                            if (item.key == MainDrawerKeys.VisitsHeadline) {
                              if (visitsModel.isLoaded &&
                                  !visitsModel.isEmpty) {
                                yield* _createListOfVisits(
                                    context, visitsModel);
                              }
                            }

                            if (item.key == MainDrawerKeys.OutcomesHeadline) {
                              if (outcomesModel.isLoaded &&
                                  !outcomesModel.isEmpty) {
                                yield* _createListOfOutcomes(
                                    context, outcomesModel);
                              }

                              if (_isAllowedMenuItem(
                                  MainDrawerKeys.NewOutcomeButton,
                                  settingsModel))
                                yield _createNewOutcomeButton(context);
                            }
                          }
                        }()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAction(BuildContext context, MainDrawerKeys key) {
    switch (key) {
      case MainDrawerKeys.MainScreen:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
        break;

      case MainDrawerKeys.RoutinesScreen:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routines, (route) => false);
        break;

      case MainDrawerKeys.OrdersScreen:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.orders, (route) => false);
        break;

      case MainDrawerKeys.GroupsScreen:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.groups, (route) => false);
        break;

      case MainDrawerKeys.ObjectsScreen:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.objects, (route) => false);
        break;

      case MainDrawerKeys.NewOutcomeButton:
        showItemsListDialog(
          context,
          model: OutcomeEntitiesListModel(plural: false),
          onSelect: (ident) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.editoutcome,
              arguments: OutcomeModel.create(ident),
            );
          },
        );
        break;

      case MainDrawerKeys.AboutScreen:
        Navigator.pop(context);
        showDialog(context: context, builder: (context) => AboutScreen());
        break;

      case MainDrawerKeys.Logout:
        LoginModel().logout();
        break;

      case MainDrawerKeys.Quit:
        context.read<AppStateModel>().quitApp();
        break;

      default:
    }
  }

  bool _isAllowedMenuItem(MainDrawerKeys key, SettingsModel settings) {
    switch (key) {
      case MainDrawerKeys.RoutinesScreen:
        return settings.getBool(SettingsKeys.MenuRoutines);

      case MainDrawerKeys.OrdersScreen:
        return settings.getBool(SettingsKeys.MenuOrders);

      case MainDrawerKeys.GroupsScreen:
        return settings.getBool(SettingsKeys.MenuGroups);

      case MainDrawerKeys.ObjectsScreen:
        return settings.getBool(SettingsKeys.MenuObjects);

      case MainDrawerKeys.NewOutcomeButton:
        return settings.getBool(SettingsKeys.MenuNewOutcomes);

      case MainDrawerKeys.EquipmentScreen:
        return settings.getBool(SettingsKeys.MenuEquipment);

      case MainDrawerKeys.SettingsScreen:
        return settings.getBool(SettingsKeys.MenuSettings);

      default:
        return true;
    }
  }

  Widget _createHeader(
      BuildContext context, AppStateModel appState, SettingsModel settings) {
    return Container(
      height: 170,
      child: DrawerHeader(
        decoration: BoxDecoration(color: GeneralConfig.palette2Primary800),
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image(
                          width: 40,
                          image: AssetImage(path.join(
                              GeneralConfig.AssetImagesPath,
                              GeneralConfig.AppLogo))),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${appState.appName} v${appState.appVersion}",
                          style: TextStyle(
                              fontSize: 16,
                              color: GeneralConfig.palette2Neutrals100),
                        ),
                        Text(
                          settings.getString(SettingsKeys.ConsumerName),
                          style: TextStyle(
                              fontSize: 12,
                              color: GeneralConfig.palette2Neutrals100,
                              height: 1.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(child: _buildSupportButton(context)),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    child: appState.generalState == GeneralState.Normal
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                appState.loginUserName,
                                style: TextStyle(
                                    color: GeneralConfig.palette2Neutrals100),
                              ),
                              Text(
                                "Login at".tr() + " ${appState.loginTime}",
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: GeneralConfig.palette2Neutrals100,
                                    height: 1.8),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDivider(String title) {
    return Container(
      padding: EdgeInsets.only(top: 4, right: 16, bottom: 0, left: 16),
      margin: EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 6, right: 0, bottom: 2, left: 0),
            child: Text(
              title.tr(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: GeneralConfig.palette2Neutrals900,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: GeneralConfig.palette2Neutrals100,
          ),
        ],
      ),
    );
  }

  Widget _createItemTile(
      {required String title,
      String? subtitle,
      IconData? icon,
      bool highlighted = false,
      required Proc onTap}) {
    return Ink(
      color: highlighted ? GeneralConfig.palette2Primary50 : null,
      child: ListTile(
        dense: true,
        title: Row(
          children: <Widget>[
            Icon(
              icon,
              color: highlighted ? GeneralConfig.palette2Primary600 : null,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.from(() sync* {
                    yield Text(
                      title.tr(),
                      style: TextStyle(
                        fontWeight: highlighted ? FontWeight.bold : null,
                        color: highlighted
                            ? GeneralConfig.palette2Primary600
                            : null,
                      ),
                    );
                    if (subtitle != null)
                      yield Text(
                        subtitle.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: highlighted
                              ? GeneralConfig.palette2Primary600
                              : null,
                        ),
                      );
                  }()),
                ),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Iterable<Widget> _createListOfVisits(
      BuildContext context, ObjectVisitsListModel visitsModel) sync* {
    for (final item in visitsModel.items) {
      yield _createItemTile(
        title: item.title,
        subtitle: item.subtitle?.tr(),
        icon: Icons.house_outlined,
        highlighted: selectedItemKey == MainDrawerKeys.VisitsHeadline &&
            item.id == selectedItemId,
        onTap: () => Navigator.pushReplacementNamed(
          context,
          AppRoutes.objectvisit,
          arguments: ObjectVisitModel.load(item.id),
        ),
      );
    }
  }

  Iterable<Widget> _createListOfOutcomes(
      BuildContext context, OutcomesListModel outcomesModel) sync* {
    for (final item in outcomesModel.items) {
      yield _createItemTile(
        title: item.ident!,
        subtitle: item.subtitle,
        icon: Icons.work_outline_rounded,
        highlighted: selectedItemKey == MainDrawerKeys.OutcomesHeadline &&
            item.id == selectedItemId,
        onTap: () => Navigator.pushReplacementNamed(
          context,
          AppRoutes.editoutcome,
          arguments: OutcomeModel.open(item.id, edit: true),
        ),
      );
    }
  }

  Widget _createNewOutcomeButton(BuildContext context) {
    return Row(children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Icon(
          Icons.favorite_outline,
          color: GeneralConfig.palette2Neutrals0,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 0, right: 16, bottom: 4, left: 0),
          child: TextButton(
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(MainDrawerConfig.NewOutcomeButton.icon),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      MainDrawerConfig.NewOutcomeButton.title.tr(),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
            onPressed: () =>
                _onAction(context, MainDrawerKeys.NewOutcomeButton),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(50, 30),
              primary: GeneralConfig.palette2SupportingCyan400,
              side: BorderSide(
                width: 0,
                color: GeneralConfig.palette2Neutrals0,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget? _buildSupportButton(BuildContext context) {
    final settings = context.watch<SettingsModel>();

    final title = settings.getString(SettingsKeys.SupportButtonTitle);
    final phone = settings.getString(SettingsKeys.SupportButtonPhone);
    if (title.isEmpty || phone.isEmpty) return null;

    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: GeneralConfig.palette2Neutrals300),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_in_talk_outlined,
              color: GeneralConfig.palette2Neutrals300),
          SizedBox(width: 4),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: TextStyle(
                color: GeneralConfig.palette2Neutrals300,
              ),
            ),
          ),
        ],
      ),
      onPressed: () async => launch("tel:$phone"),
      onLongPress: () async => launch("tel:$phone"), // ? sms optional
    );
  }
}
