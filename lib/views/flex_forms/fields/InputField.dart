import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/views/flex_forms/FlexFieldLabel.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/views/flex_forms/FlexFieldValidationMsg.dart';

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final FlexFieldModel _model;
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _model = context.read<FlexFieldModel>();

    _controller = TextEditingController();
    _controller.addListener(_controllerListener);

    _focusNode.addListener(() {
      // hotfix: https://github.com/flutter/flutter/issues/47128
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    _model.value = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    TextInputType? inputType;
    List<TextInputFormatter>? inputFormatters;
    if (_model.inputType == FlexFieldInputTypeModel.Number) {
      inputType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    } else if (_model.inputType == FlexFieldInputTypeModel.MultilineText) {
      inputType = TextInputType.multiline;
    }

    _controller.text = _model.value != null ? _model.value.toString() : "";

    return Selector<FlexFieldModel, String?>(
      selector: (_, model) => model.displayErrorMessage,
      builder: (context, errormsg, _) => Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlexFieldLabel(_model.label, _model.required),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (val) => _model.value =
                  _model.inputType == FlexFieldInputTypeModel.Number
                      ? num.tryParse(val)
                      : val,
              keyboardType: inputType,
              minLines: inputType == TextInputType.multiline ? 3 : null,
              maxLines: inputType == TextInputType.multiline ? 7 : null,
              maxLength: _model.max?.toInt(),
              textInputAction: inputType != TextInputType.multiline
                  ? TextInputAction.next
                  : null,
              inputFormatters: inputFormatters,
              style: TextStyle(
                height: 1.5,
              ),
              decoration: InputDecoration(
                isDense: true,

                //hide letter counter from the bottom
                counterStyle: TextStyle(
                  height: double.minPositive,
                ),
                counterText: "",

                contentPadding: EdgeInsets.all(8),
                hintStyle: TextStyle(
                  color: GeneralConfig.palette2Neutrals300,
                ),
                hintText: _model.hint,

                enabledBorder: _createBorder(
                    width: 1.0,
                    color: _model.displayErrorMessage != null
                        ? GeneralConfig.palette2SupportingRed700
                        : GeneralConfig.palette2Neutrals200),
                focusedBorder: _createBorder(
                    width: 2.0,
                    color: _model.displayErrorMessage != null
                        ? GeneralConfig.palette2SupportingRed700
                        : GeneralConfig.palette2SupportingCyan400),

                // disabled TextField styles
                /*  enabled: false,
                            filled: true,
                            fillColor: GeneralConfig.palette2Neutrals50,
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: GeneralConfig.palette2Neutrals200,
                              ), */
                // closed error TextField styles
              ),
            ),
            FlexFieldValidationMsg(textOrHide: _model.displayErrorMessage),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _createBorder(
      {required double width, required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
