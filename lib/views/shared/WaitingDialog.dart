import 'package:flutter/material.dart';

showWaitingDialog(BuildContext context, {String? text}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            text != null
                ? Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text(text),
                  )
                : Container(),
          ],
        ),
      ),
    ),
  );
}
