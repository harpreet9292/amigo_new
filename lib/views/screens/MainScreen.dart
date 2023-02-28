import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/views/general/MainDrawer.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/main";

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var session = context.watch<MainModel>().currentSession;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Process".tr()),
      ),
      body: Center(
        child: Text("Main screen".tr()),
      ),
    );
  }
}
