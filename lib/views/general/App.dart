import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/views/general/AppRoutes.dart';
import 'package:amigotools/view_models/general/AppStateModel.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// todo: debug. remove it
//    context.setLocale(Locale("ru"));
//    context.deleteSaveLocale();

    return Selector<AppStateModel, GeneralState>(
      // no using model here, just to refresh
      selector: (_, model) => model.generalState,
      builder: (context, generalState, _) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateRoute: AppRoutes.generateRoute,
        theme: ThemeData(
          primaryColor: GeneralConfig.palette2Primary800,
          //   accentColor: GeneralConfig.palette2SupportingCyan400,
          cardColor: Colors.white, //date time background

          backgroundColor: GeneralConfig.palette2Primary600,
          highlightColor: GeneralConfig.palette2Primary600,
          splashColor: GeneralConfig.palette2Primary600,

          scaffoldBackgroundColor: GeneralConfig.palette2Neutrals0,

          textTheme: TextTheme(),

          colorScheme: ColorScheme.light(
            primary: GeneralConfig.palette2Primary600,
            onPrimary: GeneralConfig.palette2Neutrals100,
          ),
        ),
      ),
    );
  }
}
