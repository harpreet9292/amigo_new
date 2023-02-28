import 'package:flutter/material.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';
import 'package:amigotools/views/flex_forms/FlexFieldValidationMsg.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/DropdownFieldModel.dart';
import 'package:amigotools/utils/views/DropDownMultiSelect.dart';

class DropdownField extends FlexFieldBase {
  DropdownField({required bool editMode}) : super(editMode: editMode);

  @override
  Widget buildEditWidget(BuildContext context, FlexFieldModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlexFieldLabel(model.label, model.required),
          Container(
              child: model.inputType == FlexFieldInputTypeModel.MultipleChoice
                  ? _buildDropdownMultiSelect(model as DropdownFieldModel)
                  : _buildSimpleDropdown(model as DropdownFieldModel)),
          FlexFieldValidationMsg(textOrHide: model.displayErrorMessage),
        ],
      ),
    );
  }

  _buildSimpleDropdown(DropdownFieldModel model) {
    return DropdownButtonFormField<Object>(
      icon: Icon(
        Icons.arrow_drop_down,
        color: GeneralConfig.palette2Primary600,
      ),
      value: model.inputType != FlexFieldInputTypeModel.MultipleChoice
          ? (model.value != "" ? model.value : null)
          : null,
      onChanged: (val) {
        if (model.inputType != FlexFieldInputTypeModel.MultipleChoice)
          model.value = val;
      },
      hint: model.hint != null ? Text(model.hint!) : null,
      decoration: _buildInputDecoration(model),
      items: model.choices
          .map((item) => DropdownMenuItem<Object>(
                value: item.key,
                onTap: () {},
                child: Text(
                  item.headline1 ?? item.key as String,
                  style: TextStyle(
                    height: 1.5,
                    //    color: GeneralConfig.palette2Neutrals300,
                  ),
                ),
              ))
          .toList(),
    );
  }

  _buildDropdownMultiSelect(DropdownFieldModel model) {
    return DropdownMultiSelect(
      items: model.choices.map((x) => x.headline1 ?? x.key.toString()).toList(),
      selectedItems: model.multiValues,
      onChanged: (list) => model.multiValues = list,
      hint: model.hint,
      isDense: true,
      decoration: _buildInputDecoration(model),
    );
  }

  InputDecoration _buildInputDecoration(FlexFieldModel model)
  {
    return InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: model.displayErrorMessage != null
                ? GeneralConfig.palette2SupportingRed700
                : GeneralConfig.palette2Neutrals200,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
      );
  }
}
