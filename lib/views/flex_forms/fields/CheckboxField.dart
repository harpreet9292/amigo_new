import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';

class CheckboxField extends FlexFieldBase {
  CheckboxField({required bool editMode}) : super(editMode: editMode);

  @override
  Widget buildEditWidget(BuildContext context, FlexFieldModel model) {
    final model = context.watch<FlexFieldModel>();

    return Theme(
      data: ThemeData(
        // unselectedWidgetColor: GeneralConfig.GeneralConfig.palette2Neutrals200,
        unselectedWidgetColor: model.displayErrorMessage != null
            ? GeneralConfig.palette2SupportingRed700
            : null,
        visualDensity: VisualDensity.compact,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => model.value = !(model.value ?? false),
            child: Padding(
              padding: EdgeInsets.only(right: 6),
              child: Row(
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      primarySwatch: MaterialColor(0xFF38BEC9, {
                        50: Color(0xFFE0FCFF),
                        100: Color(0xFFBEF8FD),
                        200: Color(0xFF87EAF2),
                        300: Color(0xFF54D1DB),
                        400: Color(0xFF38BEC9),
                        500: Color(0xFF38BEC9),
                        600: Color(0xFF38BEC9),
                        700: Color(0xFF0E7C86),
                        800: Color(0xFF0A6C74),
                        900: Color(0xFF044E54),
                      }),
                      unselectedWidgetColor:
                          GeneralConfig.palette2Neutrals200, // Your color
                    ),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: model.value == true,
                      onChanged: (val) => model.value = val,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      textDirection: TextDirection.ltr,
                      text: TextSpan(
                        text: model.label,
                        style: TextStyle(
                          color: GeneralConfig.palette2Neutrals900,
                          fontSize: 16,
                        ),
                        children: model.required
                            ? <TextSpan>[
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                      color: GeneralConfig
                                          .palette2SupportingRed700),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],

                // value: model.value == true,
                // onChanged: (val) => model.value = val,
                //  activeColor: GeneralConfig.palette2SupportingCyan400,
              ),
            ),
          ),

          //  FlexFieldValidationMsg(textOrHide: model.displayErrorMessage, top: 0),
        ],
      ),
    );
  }

  @override
  Widget buildViewWidget(BuildContext context, FlexFieldModel model) {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(
                model.value == true
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_outlined,
                color: GeneralConfig.palette2Neutrals300)),
        FlexFieldLabel(model.label, false),
      ],
    );
  }
}
