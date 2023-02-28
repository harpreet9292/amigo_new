import 'package:flutter/material.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';

class FlexFieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const FlexFieldLabel(this.text, this.required);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 2, left: 0, right: 0),
      child: RichText(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: GeneralConfig.palette2Neutrals900,
            fontSize: 14,
          ),
          children: required
              ? [
                  TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: GeneralConfig.palette2SupportingRed700,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
