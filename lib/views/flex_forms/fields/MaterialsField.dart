import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:amigotools/config/views/FlexItemEditorScreenConfig.dart';
import 'package:amigotools/views/flex_forms/fields/DividerField.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/utils/views/AppBarActionsBuilder.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';

class MaterialsField extends FlexFieldBase {
  MaterialsField({required bool editMode}) : super(editMode: editMode);

  @override
  void onClick(BuildContext context, FlexFieldModel model) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: _MaterialsEditor(model),
      ),
    );
  }
}

class _MaterialsEditor extends StatelessWidget {
  final FlexFieldModel model;

  const _MaterialsEditor(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<FlexFieldModel>(
        builder: (context, model, _) => Scaffold(
          appBar: AppBar(
            title: Text(model.label),
            actions: buildAppBarActions<FlexItemEditorScreenConfig>(
              items: FlexItemEditorScreenConfig.MaterialsEditorBarItems,
              onPressed: (key) => _onAction(context, model, key),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                interactive: true,
                child: ListView(children: <Widget>[
                  _createMaterialItem("title"),
                  SizedBox(height: 6),
                  _createMaterialItem("title"),
                  SizedBox(height: 6),
                  _createMaterialItem("title"),
                  DividerField(),
                  _createMaterialItem("title"),
                  SizedBox(height: 6),
                  _createMaterialItem("title"),
                  SizedBox(height: 6),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createMaterialItem(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          flex: 1,
          child: TextField(
            style: TextStyle(
              height: 1.5,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              enabledBorder: _createBorder(
                  width: 1.0, color: GeneralConfig.palette2Neutrals200),
            ),
          ),
        ),
        SizedBox(width: 6),
        GestureDetector(
          child: Center(
            child: Icon(
              Icons.close,
              color: GeneralConfig.palette2SupportingRed700,
            ),
          ),
        ),
      ],
    );
  }

  void _onAction(BuildContext context, FlexFieldModel model,
      FlexItemEditorScreenConfig key) {
    switch (key) {
      default:
    }
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
