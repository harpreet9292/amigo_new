import 'package:amigotools/config/services/WebApiConfig.dart';

abstract class SettingsConfig
{
  static const DefaultValues = const <SettingsKeys, dynamic>{

    // State

    SettingsKeys.CurrentWebApiStamp:       0,

    // General values

    SettingsKeys.MainApiUrlTpl:           WebApiConfig.DefaultApiUrlTemplate,
    SettingsKeys.ReservedApiUrlTpl:       WebApiConfig.DefaultApiUrlTemplate,
    SettingsKeys.SystemKey:               null,
    SettingsKeys.ConsumerIdent:           null,
    SettingsKeys.ConsumerName:            "",
    SettingsKeys.CurrentRoutine:          null,

    // Main menu

    SettingsKeys.MenuRoutines:              true,
    SettingsKeys.MenuOrders:                true,
    SettingsKeys.MenuGroups:                true,
    SettingsKeys.MenuObjects:               true,
    SettingsKeys.MenuNewOutcomes:           true,
    SettingsKeys.MenuEquipment:             true,
    SettingsKeys.MenuSettings:              true,

    // General behaviour

    SettingsKeys.PeriodicGeoPosMinutes:     5,
    SettingsKeys.SupportButtonTitle:        "",
    SettingsKeys.SupportButtonPhone:        "",

    // Orders

    SettingsKeys.ShowOrdersOfOthers:        true,
    SettingsKeys.AllowRefuseOrder:          true,
    SettingsKeys.AllowCloseOrder:           true,
    SettingsKeys.AllowOutcomeOfOrder:       true,

    // Routines and Workflows

    SettingsKeys.AllowUnscheduledVisits:    true,
    SettingsKeys.AllowVisitPause:           true,
    SettingsKeys.AllowMultipleActiveVisits: false,
    SettingsKeys.AllowTaskRejectAndAdmit:   true,
  };
}

enum SettingsKeys
{
  CurrentWebApiStamp,

  MainApiUrlTpl,
  ReservedApiUrlTpl,
  SystemKey,
  ConsumerIdent,
  ConsumerName,
  CurrentRoutine,

  MenuRoutines,
  MenuOrders,
  MenuGroups,
  MenuObjects,
  MenuNewOutcomes,
  MenuEquipment,
  MenuSettings,

  PeriodicGeoPosMinutes,
  SupportButtonTitle,
  SupportButtonPhone,

  ShowOrdersOfOthers,
  AllowRefuseOrder,
  AllowCloseOrder,
  AllowOutcomeOfOrder,

  AllowTaskRejectAndAdmit,
  AllowUnscheduledVisits,
  AllowVisitPause,
  AllowMultipleActiveVisits,
}