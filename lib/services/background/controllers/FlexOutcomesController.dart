import 'dart:async';

import 'package:amigotools/entities/flexes/FlexField.dart';
import 'package:amigotools/entities/flexes/FlexOutcome.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/background/abstractions/ControllerBase.dart';
import 'package:amigotools/services/files/PhotosProvider.dart';
import 'package:amigotools/services/storage/FlexEntitiesStorage.dart';
import 'package:amigotools/services/storage/FlexOutcomesStorage.dart';
import 'package:amigotools/services/webapi/FlexOutcomesApi.dart';

class FlexOutcomesController extends ControllerBase
{
  final _entitiesStorage = $locator.get<FlexEntitiesStorage>();
  final _storage = $locator.get<FlexOutcomesStorage>();
  final _api = $locator.get<FlexOutcomesApi>();
  final _photos = $locator.get<PhotosProvider>();

  @override
  Future<bool> onLoginChanged(bool isLogin) async
  {
    if (isLogin)
    {
      _storage.addListener(_onStorageChanged);

      _onStorageChanged();
    }
    else
    {
      _storage.removeListener(_onStorageChanged);
    }

    return true;
  }

  void _onStorageChanged() async
  {
    final outcomes = await _storage.fetch(sysStatus: FlexOutcomeSysStatus.Completed);

    for (final outcome in outcomes)
    {
      if (await _sendOutcome(outcome))
      {
        await _storage.delete(id: outcome.id);
        
        // ?
        // await _storage.updatePartial(
        //   id: outcome.id,
        //   values: {"sys_status": enumValueToString(FlexOutcomeSysStatus.Sent)},
        // );
      }
      else
      {
        // todo
      }
    }
  }

  Future<bool> _sendOutcome(FlexOutcome outcome) async
  {
    final id = await _api.sendOutcome(outcome);

    if (id != null)
    {
      final entities = await _entitiesStorage.fetch(ident: outcome.entityIdent);
      if (entities.isEmpty)
      {
        // todo
        return false;
      }

      final entity = entities.first;
      final folderName = "${outcome.entityIdent}_${outcome.id}"; // old id here

      final imgfields = entity.fields
        .where((x) => x.type == FlexFieldType.Images)
        .where((x) => outcome.values.containsKey(x.ident))
        .map((x) => outcome.values[x.ident]);

      for (final field in imgfields)
      {
        final names = (field.value as String).split('//');
        
        for (final name in names)
        {
          final file = await _photos.getImageFile(folder: folderName, name: name);
          await _api.sendImage(id, file); // new id here
        }
      }
    }
    else
    {
      // todo
      return false;
    }

    return true;
  }
}