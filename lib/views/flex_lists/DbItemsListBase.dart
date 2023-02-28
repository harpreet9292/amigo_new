import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/utils/views/ScaffoldWithSearch.dart';
import 'package:amigotools/views/general/MainDrawer.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/config/views/MainDrawerConfig.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';

abstract class DbItemsListBase<T extends DbItemsListModelBase> extends StatelessWidget {
  final bool selectionMode;

  const DbItemsListBase({this.selectionMode = false});

  T createListModel();

  Widget getDetailsScreen(int id);

  MainDrawerKeys? get selectedItemKey;

  @override
  Widget build(BuildContext context) {
    final model = createListModel();
    return ScaffoldWithSearch(
      title: model.title.tr(),
      drawer: !selectionMode
          ? MainDrawer(selectedItemKey: selectedItemKey)
          : null,
      body: ChangeNotifierProvider.value(
        value: model,
        builder: (context, _) => Consumer<T>(
            builder: (context, model, _) => _createListView(context, model)),
      ),
      searchHint: "Search".tr(),
      onSearchChanged: (search) => model.searchString = search,
      blockBackButton: !selectionMode,
    );
  }

  Widget _createListView(BuildContext context, DbItemsListModelBase model) =>
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          interactive: true,
          child: ListView(
            children: List.from(
              model.items.map(
                (x) => Container(
                  decoration: BoxDecoration(
                    border: new Border(
                      bottom: new BorderSide(
                        color: GeneralConfig.palette2Neutrals50,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    title: Text(
                      x.title,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    subtitle: x.subtitle != null && x.subtitle!.isNotEmpty
                        ? Text(
                            x.subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        : null,
                    onTap: () => selectionMode
                        ? Navigator.pop(context, x.id)
                        : _openDetails(context, x.id),
                    trailing: selectionMode
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.auto_stories_outlined,
                                color: GeneralConfig.palette2Primary600),
                            onPressed: () => _openDetails(context, x.id),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _openDetails(BuildContext context, int id) async {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: getDetailsScreen(id),
          insetPadding: EdgeInsets.all(12.0),
        ),
      );
  }
}
