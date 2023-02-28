import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/geopos/GeoLocationProvider.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/entities/flexes/FlexOutcome.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/services/storage/FlexOutcomesStorage.dart';
import 'package:amigotools/utils/data/EnumHelper.dart';

import 'FlexItemModelBase.dart';

class OutcomeModel extends FlexItemModelBase<FlexOutcomesStorage>
{
  final _location = $locator.get<GeoLocationProvider>();

  OutcomeModel.create(String entityIdent, {Map<String, dynamic>? initialVals})
    : super.create(entityIdent, initialVals: initialVals);

  OutcomeModel.open(int itemId, {required bool edit})
    : super.open(itemId, edit: edit);

  @override @protected
  Future<FlexItemBase?> fetchItemInternal(int id) async
  {
    final items = await itemsStorage.fetch(id: id);
    return items.isNotEmpty ? items.first : null;
  }

  @override @protected
  dynamic getValueInternal(String fieldIdent)
  {
    switch (fieldIdent)
    {
      case "\$object":
        return (flexItemInternal as FlexOutcome).objectId;

      case "\$order":
        return (flexItemInternal as FlexOutcome).orderId;

      case "\$geopos":
        return (flexItemInternal as FlexOutcome).position;

      default:
        return super.getValueInternal(fieldIdent);
    }
  }

  @protected
  List<String> get excludeFieldIdentsForEditMode => ["\$assigned", "\$\$state"];

  @override
  Future<bool> send() async
  {
    if (canSend)
    {
      await saveItemInternal();
      return await itemsStorage.changeStatus(flexItemInternal as FlexOutcome, FlexOutcomeSysStatus.Completed);
    }
    else
    {
      // allow validation messages for all fields if not yet
      if (fields.isNotEmpty && !fields.first.allowErrorMessage)
      {
        fields.forEach((x) => x.allowErrorMessage = true);
        notifyListeners();
      }
    }

    return false;
  }

  @override
  Future<bool> delete() async
  {
    if (await itemsStorage.delete(id: itemId) > 0)
    {
      load();
      return true;
    }

    return false;
  }

  @override
  Future<bool> saveItemInternal({Map<String, dynamic>? initialVals}) async
  {
    final fieldVals = Map<String, dynamic>.fromIterable(
      fields.where((x) => x.hasNotEmptyValue),
      key: (x) => (x as FlexFieldModel).ident,
      value: (x) => (x as FlexFieldModel).value,
    );

    if (initialVals != null)
    {
      fieldVals.addAll(initialVals);
    }

    final groupid = fieldVals["\$group"];
    final objectid = fieldVals["\$object"];
    final orderid = fieldVals["\$order"];

    fieldVals.removeWhere((key, value) => key.startsWith('\$'));

    if (itemId == 0)
    {
      final pos = await _location.getPosition();

      final item = FlexOutcome(
        id: 0,
        entityIdent: entityIdent,
        groupId: groupid,
        objectId: objectid,
        orderId: orderid,
        values: fieldVals,
        position: pos,
        time: DateTime.now(),
        sysStatus: FlexOutcomeSysStatus.Draft,
      );

      final newid = await itemsStorage.add(item);
      if (newid != null)
      {
        itemId = newid;
        load();
      }
      else
      {
        // todo
        return false;
      }
    }
    else
    {
      final values = {
        "groupId": groupid,
        "objectId": objectid,
        "values": fieldVals,
      };

      if (!await itemsStorage.updatePartial(id: itemId, values: values))
      {
        // todo
        return false;
      }
    }

    return true;
  }
}