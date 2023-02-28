import 'dart:io';

import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/files/PhotosProvider.dart';
import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';
import 'package:amigotools/view_models/flex_forms/FlexItemModelBase.dart';

class ImagesFieldModel extends FlexFieldModel
{
  final _provider = $locator.get<PhotosProvider>();
  late final String _folderName;

  List<ImagesFieldFileModel> _files = [];

  List<ImagesFieldFileModel> get files => _files;

  ImagesFieldModel(FlexField flexField, String? value)
    : super(flexField, value);

  void addImageFromCamera()
  {
    _acceptNewImage(_provider.pickImageFromCamera(folder: _folderName));
  }

  void addImageFromGallery()
  {
    _acceptNewImage(_provider.pickImageFromGallery(folder: _folderName));
  }

  void deleteImage(ImagesFieldFileModel file) async
  {
    if (files.remove(file))
    {
      _updateValue();
      _provider.deleteImage(folder: _folderName, name: file.name); // no await is needed
    }
  }

  @override
  void onBoundToItemModel(FlexItemModelBase itemModel, bool editMode) async
  {
    _folderName = "${itemModel.entityIdent}_${itemModel.itemId}";
  
    if (hasNotEmptyValue) // important because split gives empty item for empty string
    {
      final names = (value != null) ? value!.split('//') : <String>[];

      for (String name in names)
      {
        final file = await _provider.getImageFile(folder: _folderName, name: name);
        _files.add(ImagesFieldFileModel(name, file));
      }

      notifyListeners();
    }
  }

  void _updateValue()
  {
    value = files.map((x) => x.name).join('//');
  }

  void _acceptNewImage(Future<String?> future)
  {
    future.then((filename) async
    {
      if (filename != null)
      {
        final file = await _provider.getImageFile(folder: _folderName, name: filename);
        files.add(ImagesFieldFileModel(filename, file));
        _updateValue();
      }
    });
  }
}

class ImagesFieldFileModel
{
  final String name;
  final File file;

  const ImagesFieldFileModel(this.name, this.file);
}