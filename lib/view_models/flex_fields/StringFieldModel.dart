import 'package:url_launcher/url_launcher.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/geopos/ExternalMapProvider.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';

class StringFieldModel extends FlexFieldModel
{
  late final FlexItemModelBase _itemModel;

  StringFieldModel(FlexField flexField, dynamic value)
    : super(flexField, value);

  @override
  void onBoundToItemModel(FlexItemModelBase itemModel, bool editMode)
  {
    _itemModel = itemModel;
  }

  void performAction() async
  {
    if (!hasNotEmptyValue) return;

    switch (inputType)
    {
      case FlexFieldInputTypeModel.Address:
       _openMapWithAddress();
        break;

      case FlexFieldInputTypeModel.Telephone:
        _openCallerId();
        break;

      default:
    }
  }

  void _openMapWithAddress() async
  {
    final _provider = $locator.get<ExternalMapProvider>();

    final regions = _itemModel.fields
      .where((x) => x.hasNotEmptyValue)
      .where((x) => x.inputType == FlexFieldInputTypeModel.Region || x.inputType == FlexFieldInputTypeModel.Postcode)
      .map((x) => x.value as String)
      .join(", ");

    final addr = value as String;
    final fulladdr = [addr, regions].join(", ");

    await _provider.openMapWithAddress(fulladdr);
  }

  void _openCallerId() async
  {
    final tel = (value as String).split(RegExp(r"[;,]"))[0];
    await launch("tel:$tel");
  }
}