import 'package:flutter/material.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';

void showModalDialog(
    {required BuildContext context,
    required String title,
    List<Widget>? actions,
    required Widget body}) {
  showDialog(
    context: context,
    builder: (context) =>
        buildModalDialog(title: title, actions: actions, body: body),
  );
}

Dialog buildModalDialog(
    {required String title, List<Widget>? actions, required Widget body}) {
  return Dialog(
    insetPadding: EdgeInsets.all(12.0),
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: GeneralConfig.palette2Neutrals0,
        elevation: 0,
        iconTheme: IconThemeData(
          color: GeneralConfig.palette2Primary600, //back icon color
        ),
        title: Text(
          title,
          style: TextStyle(
            color: GeneralConfig.palette2Primary600,
            fontSize: 16,
          ),
        ),
        actions: actions,
      ),
      body: body,
    ),
  );
}
