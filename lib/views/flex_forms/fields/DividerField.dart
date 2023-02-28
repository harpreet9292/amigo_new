import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';

class DividerField extends StatelessWidget {
  const DividerField();

  Widget build(BuildContext context) {
    final model = context.watch<FlexFieldModel>();

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8, left: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 2, left: 0, right: 0),
            child: Text(
              model.label,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFF102A43),
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
}