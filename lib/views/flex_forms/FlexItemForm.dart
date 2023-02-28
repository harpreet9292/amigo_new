import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/views/flex_forms/fields/DividerField.dart';
import 'package:amigotools/views/flex_forms/fields/ImagesField.dart';
import 'package:amigotools/views/flex_forms/fields/LabelField.dart';
import 'package:amigotools/views/flex_forms/fields/PlaceIdField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';
import 'package:amigotools/views/flex_forms/fields/InputField.dart';
import 'package:amigotools/views/flex_forms/fields/ViewField.dart';
import 'package:amigotools/views/flex_forms/fields/CheckboxField.dart';
import 'package:amigotools/views/flex_forms/fields/DropdownField.dart';
import 'package:amigotools/views/flex_forms/fields/DateTimeField.dart';
import 'package:amigotools/views/flex_forms/fields/GeoPositionField.dart';
import 'package:amigotools/views/flex_forms/fields/MaterialsField.dart';
import 'package:amigotools/views/flex_forms/fields/ItemSelectorField.dart';

class FlexItemForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = context.select<FlexItemModelBase, FlexItemModelStatus>(
        (model) => model.status);

    switch (status) {
      case FlexItemModelStatus.Loading:
        return Center(child: CircularProgressIndicator());

      case FlexItemModelStatus.Ready:
        return _buildListWithFields(context);

      case FlexItemModelStatus.Sending:
        return Stack(
          children: [
            IgnorePointer(child: _buildListWithFields(context)),
            Center(child: CircularProgressIndicator()),
          ],
        );

      case FlexItemModelStatus.Gone:
        return Container();
    }
  }

  Widget _buildListWithFields(BuildContext context) {
    final model = context.read<FlexItemModelBase>();
    return Scrollbar(
      interactive: true,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: model.fields
                .map(
                  (fieldModel) => ChangeNotifierProvider.value(
                    value: fieldModel,
                    child:
                        _createFieldWidget(fieldModel.widget, model.editMode),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _createFieldWidget(FlexFieldWidgetModel widget, bool editMode) {
    switch (widget) {
      case FlexFieldWidgetModel.Input:
        return editMode ? InputField() : ViewField();

      case FlexFieldWidgetModel.Checkbox:
        return CheckboxField(editMode: editMode);

      case FlexFieldWidgetModel.Dropdown:
        return DropdownField(editMode: editMode);

      case FlexFieldWidgetModel.DateTime:
        return DateTimeField(editMode: editMode);

      case FlexFieldWidgetModel.Images:
        return ImagesField(editMode: editMode);

      case FlexFieldWidgetModel.Label:
        return LabelField();

      case FlexFieldWidgetModel.GeoPosition:
        return GeoPositionField(editMode: editMode);

      case FlexFieldWidgetModel.ItemSelector:
        return ItemSelectorField(editMode: editMode);

      case FlexFieldWidgetModel.Materials:
        return MaterialsField(editMode: editMode);

      case FlexFieldWidgetModel.PlaceId:
        return PlaceIdField(editMode: editMode);

      case FlexFieldWidgetModel.Divider:
        return DividerField();

      case FlexFieldWidgetModel.Undefined:
        return Container();
    }
  }
}
