import 'package:flutter/material.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';

class FlexFieldValidationMsg extends StatelessWidget {
  final String? textOrHide;
  final double top;

  const FlexFieldValidationMsg({this.textOrHide, this.top = 8.0});

  @override
  Widget build(BuildContext context) {
    return textOrHide != null && textOrHide!.isNotEmpty
        ? Container(
            padding: EdgeInsets.only(top: top, left: 14, bottom: 4),
            alignment: Alignment.topLeft,
            child: Text(
              textOrHide!,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: GeneralConfig.palette2SupportingRed700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        : Container();
  }
}
