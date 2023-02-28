import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:amigotools/config/services/FilesConfig.dart';

class PhotosProvider
{
  final _picker = ImagePicker();
  String? _photosRootPath;

  Future<String> get photosRootPath async
  {
    if (_photosRootPath == null)
    {
      final dir = await getApplicationDocumentsDirectory();
      _photosRootPath = path.join(dir.path, FilesConfig.PhotosFolderName);
    }

    return _photosRootPath!;
  }

  Future<String?> pickImageFromCamera({required String folder}) async
  {
    var image = await _picker.pickImage(source: ImageSource.camera);
    return await _saveImage(folder, image);
  }

  Future<String?> pickImageFromGallery({required String folder}) async
  {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    return await _saveImage(folder, image);
  }

  Future<File> getImageFile({required String folder, required String name}) async
  {
    final imagepath = path.join(await photosRootPath, folder, name);
    return File(imagepath);
  }

  Future<void> deleteImage({required String folder, required String name}) async
  {
    final imagepath = path.join(await photosRootPath, folder, name);
    await File(imagepath).delete();
  }

  Future<void> deleteFolder({required String folder}) async
  {
    final folderpath = path.join(await photosRootPath, folder);
    await Directory(folderpath).delete();
  }

  Future<String?> _saveImage(String folder, XFile? image) async
  {
    if (image != null)
    {
      final imagename = path.basename(image.path);
      final newpath = path.join(await photosRootPath, folder);
      final newfullpath = path.join(newpath, imagename);

      await Directory(newpath).create(recursive: true);
      await File(image.path).rename(newfullpath);

      return imagename;
    }
    
    return null;
  }
}