abstract class WebApiConfig
{
  static const DefaultApiUrlTemplate = "https://[ident].amigotools.se/api";
  //static const DefaultApiUrlTemplate = "http://192.168.0.11/api";

  static const TimeoutSec = 15;
  static const ApiVersion = 1;
  static const StampKeyName = "stamp";

  static const ServerStateApiPath =   "state";
  static const SysLoginApiPath =      "auth/syslogin";
  static const LoginApiPath =         "auth/login";
  static const LogoutApiPath =        "auth/logout";
  static const UserPositionApiPath =  "$UsersApiCat/pos";
  static const OutcomesImageApiPath = "$OutcomesApiCat/image";
  static const OrderChangeApiPath =   "$OrdersApiCat/change";
  static const ObjectEventsApiPath =  "$EventsApiCat/objects";

  static const EntitiesApiCat =     "entities";
  static const GroupsApiCat =       "groups";
  static const ObjectsApiCat =      "objects";
  static const OutcomesApiCat =     "outcomes";
  static const OrdersApiCat =       "orders";
  static const CustItemsApiCat =    "custitems";
  static const MaterialsApiCat =    "materials";
  static const UsersApiCat =        "users";
  static const RoutinesApiCat =     "routines";
  static const RoutineTasksApiCat = "tasks";
  static const SettingsApiCat =     "settings";
  static const CommandsApiCat =     "commands";
  static const EventsApiCat =       "events";
}

enum WebApiCommands
{
  Message,        // + text
  Alert,          // + text
  Logout,
  Quit,
  SysLogout,
  InformUpgrade,  // + version
  RequireUpgrade, // + version
  ReinitData,
  ClearData,
}