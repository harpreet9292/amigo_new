import 'package:flutter/foundation.dart';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/entities/abstractions/FlexItemBase.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/entities/flexes/FlexEntity.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/config/views/FlexItemViewerScreenConfig.dart';
import 'package:amigotools/view_models/flex_fields/ImagesFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/ItemSelectorFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/PlaceIdFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/MaterialsFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/UserFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/GeoPositionFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/StringFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/DropdownFieldModel.dart';
import 'package:amigotools/view_models/flex_fields/DateTimeFieldModel.dart';

abstract class FlexItemModelBase<TStorage extends StorageBase> extends ChangeNotifier
{
  final _entitiesStorage = $locator.get<FlexEntitiesStorage>();

  @protected
  final itemsStorage = $locator.get<TStorage>();

// #region Private fields

  FlexItemModelStatus _status = FlexItemModelStatus.Loading;

  String? _entityIdent;
  int? _itemId;

  FlexEntity? _flexEntity;
  FlexItemBase? _flexItem;
  List<FlexFieldModel> _fieldModels = [];
  bool _validFields = false;

// #endregion

// #region Properties

  final bool editMode;

  FlexItemModelStatus  get status => _status;

  String get entityIdent => _entityIdent!;

  String get entityName => _flexEntity?.name ?? "";

  @protected
  FlexEntity? get flexEntityInternal => _flexEntity;

  @protected
  FlexItemBase? get flexItemInternal => _flexItem;

  int get itemId => _itemId ?? 0;
  @protected
  set itemId(int val) => _itemId = val;

  List<FlexFieldModel> get fields => _fieldModels;

  bool get canSend => _validFields;

// #endregion

// #region Constructors and dispose

  FlexItemModelBase.create(String entityIdent, {Map<String, dynamic>? initialVals})
    : _entityIdent = entityIdent, _itemId = null, editMode = true
  {
    saveItemInternal(initialVals: initialVals).then((value)
    {
      _entitiesStorage.addListener(load);
    });
  }

  FlexItemModelBase.open(int itemId, {required bool edit})
    : _entityIdent = null, _itemId = itemId, editMode = edit
  {
    load();

    _entitiesStorage.addListener(load);

    if (!edit)
    {
      itemsStorage.addListener(load);
    }
  }

  @mustCallSuper
  @override
  void dispose()
  {
    _entitiesStorage.removeListener(load);
    itemsStorage.removeListener(load);

    for (final fieldModel in _fieldModels)
    {
      fieldModel.dispose();
    }

    super.dispose();
  }

// #endregion

// #region Abstract open methods

  Future<bool> send() => throw UnimplementedError();

  Future<bool> delete() => throw UnimplementedError();

// #endregion

// #region Protected overridable methods

  @protected
  Future<bool> saveItemInternal({Map<String, dynamic>? initialVals}) async => true;

  @protected // abstract
  Future<FlexItemBase?> fetchItemInternal(int id);

  @protected
  dynamic getValueInternal(String fieldIdent)
  {
    switch (fieldIdent)
    {
      case "\$group":
        return flexItemInternal?.groupId;

      default:
        return _flexItem?.values[fieldIdent];
    }
  }

  @protected
  List<String> get excludeFieldIdentsForEditMode => [];

// #endregion

// #region Loading and init

  void load() async
  {
    _status = FlexItemModelStatus.Loading;

    if (await _loadItemIfHasId() && await _loadEntity())
    {
      _initFieldModels();
      _validateFields(allowNotify: false);
      _status = FlexItemModelStatus.Ready;
    }
    else
    {
      _status = FlexItemModelStatus.Gone;
    }

    notifyListeners();
  }

  Future<bool> _loadItemIfHasId() async
  {
    if (_itemId != null)
    {
      _flexItem = await fetchItemInternal(_itemId!);

      if (_flexItem != null)
      {
        _entityIdent = _flexItem!.entityIdent;
      }
      else
      {
        return false;
      }
    }

    return true;
  }

  Future<bool> _loadEntity() async
  {
    if (_entityIdent != null)
    {
      final entities = await _entitiesStorage.fetch(ident: _entityIdent);
      if (entities.isNotEmpty)
      {
        _flexEntity = entities.first;
        return true;
      }
    }

    return false;
  }

  void _initFieldModels()
  {
    final fieldModels = <FlexFieldModel>[];

    if (!editMode && _flexItem != null)
    {
      fieldModels.add(_createIdentifierFieldModel());
    }

    for (var field in _flexEntity!.fields)
    {
      if (editMode && excludeFieldIdentsForEditMode.contains(field.ident)) continue;

      final value = _flexItem != null ? getValueInternal(field.ident) : null;

      // hide fields with empty value in view mode 
      if (editMode || (value != null && value.toString().isNotEmpty))
      {
        var modelfield = _createFieldModel(field, value);

        if (modelfield != null && modelfield.widget != FlexFieldWidgetModel.Undefined)
        {
          fieldModels.add(modelfield);
        }
      }
    }

    _fieldModels = List.unmodifiable(fieldModels);

    _fieldModels.forEach((modelfield)
    {
      modelfield.onBoundToItemModel(this, editMode);
      modelfield.addListener(() => _onFieldModelChanged(modelfield));
    });
  }

  FlexFieldModel _createIdentifierFieldModel()
  {
    final value = "$entityName #${_flexItem!.id}";
  
    return FlexFieldModel(
      FlexField(
          type: FlexFieldType.String,
          ident: "\$id",
          label: FlexItemViewerScreenConfig.IdentifierFieldName,
          readonly: true,
        ),
      value,
    );
  }

  FlexFieldModel? _createFieldModel(FlexField flexField, dynamic value)
  {
    switch (flexField.type)
    {
      case FlexFieldType.String:
        return StringFieldModel(flexField, value);

      case FlexFieldType.Selection:
        return DropdownFieldModel(flexField, value);

      case FlexFieldType.DateTime:
        return DateTimeFieldModel(flexField, value);

      case FlexFieldType.Object:
      case FlexFieldType.Group:
      case FlexFieldType.Collection:
        return ItemSelectorFieldModel(flexField, value);

      case FlexFieldType.User:
        return UserFieldModel(flexField, value);

      case FlexFieldType.Images:
        return ImagesFieldModel(flexField, value);

      case FlexFieldType.Materials:
        return MaterialsFieldModel(flexField, value);

      case FlexFieldType.PlaceId:
        return PlaceIdFieldModel(flexField, value);

      case FlexFieldType.GeoPosition:
        return !editMode ? GeoPositionFieldModel(flexField, value) : null;

      default:
        return FlexFieldModel(flexField, value);
    }
  }

// #endregion

// #region Fields managment

  void _onFieldModelChanged(FlexFieldModel modelfield)
  {
    saveItemInternal(); // do not await
    _validateFields(allowNotify: true);
  }

  bool _validateFields({required bool allowNotify})
  {
    var newValid = true;

    for (var field in fields)
    {
      if (!field.isValidValue)
      {
        newValid = false;
        break;
      }
    }

    if (_validFields != newValid)
    {
      _validFields = newValid;
      if (allowNotify) notifyListeners();
      return true;
    }

    return false;
  }

// #endregion
}

enum FlexItemModelStatus
{
  Loading,
  Ready,
  Sending,
  Gone,
}