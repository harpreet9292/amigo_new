import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';

class LabelField extends StatelessWidget {
  const LabelField();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FlexFieldModel>();

    return Container(
      padding: EdgeInsets.only(top: 4, right: 6, bottom: 4, left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlexFieldLabel(model.label, model.required),
          model.value != null
              ? Text(
                  model.value,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: GeneralConfig.palette2Neutrals900,
                    fontSize: 12,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
