import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/views/flex_lists/ObjectsListScreen.dart';
import 'package:amigotools/views/flex_forms/FlexItemViewerScreen.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/ItemSelectorFieldModel.dart';
import 'package:amigotools/views/flex_lists/GroupsListScreen.dart';
import 'package:amigotools/views/flex_lists/CustItemsListScreen.dart';

class ItemSelectorField extends FlexFieldBase {
  ItemSelectorField({required bool editMode}) : super(editMode: editMode);

  @override
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(
      FlexFieldModel model) sync* {
    if (model.hasNotEmptyValue) {
      yield Pair(Icons.auto_stories_outlined, _onDetailsClick);
      if (editMode)
        yield Pair(Icons.close, (context, model) => model.value = null);
    }
  }

  void _onDetailsClick(BuildContext context, FlexFieldModel model) async {
    final itemmodel = await (model as ItemSelectorFieldModel).getSelectedFlexItemModel();
    if (itemmodel != null) {
      showDialog<int?>(
        context: context,
        builder: (context) => Dialog(
          insetPadding: EdgeInsets.all(12.0),
          child: FlexItemViewerScreen(itemmodel),
        ),
      );
    }
  }

  @override
  void onClick(BuildContext context, FlexFieldModel model) async {
    final actmodel = model as ItemSelectorFieldModel;
    Widget screen;

    switch (actmodel.itemType) {
      case ItemSelectorFieldTypeModel.Group:
        screen = GroupsListScreen(selectionMode: true);
        break;

      case ItemSelectorFieldTypeModel.Object:
        screen = ObjectsListScreen(
          selectionMode: true,
          groupId: actmodel.dependencyFieldValue as int?,
        );
        break;

      case ItemSelectorFieldTypeModel.CustItem:
        screen = CustItemsListScreen(entityIdent: actmodel.relatedEntityIdent, selectionMode: true);
        break;

      default:
        throw UnimplementedError();
    }

    final res = await showDialog<int?>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(12.0),
        child: screen,
      ),
    );

    if (res != null) {
      model.value = res > 0 ? res : null;
    }
  }
}
