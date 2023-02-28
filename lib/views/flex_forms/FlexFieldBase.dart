import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/views/flex_forms/FlexFieldValidationMsg.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';

abstract class FlexFieldBase extends StatelessWidget {
  final bool editMode;

  const FlexFieldBase({required this.editMode});

// #region Protected overridable methods

  @protected
  String getValue(BuildContext context, FlexFieldModel model) =>
      model.friendlyValue;

  @protected
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(
          FlexFieldModel model) =>
      [];

  @protected
  void onClick(BuildContext context, FlexFieldModel model) {}

// #endregion

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FlexFieldModel>();
    return editMode
        ? buildEditWidget(context, model)
        : buildViewWidget(context, model);
  }

  @protected
  Widget buildEditWidget(BuildContext context, FlexFieldModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlexFieldLabel(model.label, model.required),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              GestureDetector(
                onTap: () => onClick(context, model),
                child: TextField(
                  enabled: false,
                  controller:
                      TextEditingController(text: getValue(context, model)),
                  style: TextStyle(height: 1.5),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    hintText: model.hint,
                    hintStyle: TextStyle(
                      color: GeneralConfig.palette2Neutrals300,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: model.displayErrorMessage != null
                            ? GeneralConfig.palette2SupportingRed700
                            : GeneralConfig.palette2Neutrals200,
                      ),
                    ),
                  ),
                ),
              ),
              _buildButtonsPanel(context, model),
            ],
          ),
          FlexFieldValidationMsg(textOrHide: model.displayErrorMessage),
        ],
      ),
    );
  }

  @protected
  Widget buildViewWidget(BuildContext context, FlexFieldModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    model.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: GeneralConfig.palette2Primary800,
                    ),
                  ),
                  Text(
                    getValue(context, model),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            _buildButtonsPanel(context, model),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsPanel(BuildContext context, FlexFieldModel model) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: getActionIcons(model)
            // .map((x) => InkWell(
            //       child: Icon(
            //         x.item1,
            //         color: GeneralConfig.palette2Primary600,
            //       ),
            //     ))
            .map(
              (x) => IconButton(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                constraints: BoxConstraints(),
                icon: Icon(x.item1),
                onPressed: () => x.item2(context, model),
                color: GeneralConfig.palette2Primary600,
              ),
            )
            .toList(),
      ),
    );
  }
}
