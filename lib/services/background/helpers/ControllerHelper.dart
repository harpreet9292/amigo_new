import 'package:amigotools/entities/abstractions/DbEntityBase.dart';
import 'package:amigotools/services/_locator.dart';
import 'package:amigotools/services/storage/helpers/StorageBase.dart';
import 'package:amigotools/utils/types/Func.dart';

class ControllerHelper<TEntity extends DbEntityBase, TStorage extends StorageBase>
{
  final _storage = $locator.get<TStorage>();

  Future<bool> init(String apiCat, Func1<List<int>?, Future<Iterable<TEntity>?>> onFetchItems) async
  {
    this.apiCat = apiCat;
    this.onFetchItems = onFetchItems;
    return true;
  }

  late final String apiCat;
  late final Func1<List<int>?, Future<Iterable<TEntity>?>> onFetchItems;

  Future<bool> onCleanData() async => await _updateFromServer(ids: null);

  Future<bool> onServerState(Map<String, dynamic> state) async
  {
    if (state.containsKey(apiCat))
    {
      final ids = (state[apiCat] as List?)?.cast<int>();
      return await _updateFromServer(ids: ids);
    }

    return true;
  }

  Future<bool> _updateFromServer({required List<int>? ids}) async
  {
    final items = await onFetchItems(ids);

    if (items != null)
    {
      _storage.setSilentMode(true);
      await _storage.acceptChanges(requestedIdsOrAll: ids, receivedItems: items);
      _storage.setSilentMode(false);

      return true;
    }

    return false;
  }
}