import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/view_models/flex_lists/DbItemsListModelBase.dart';

void showItemsListDialog<T extends DbItemsListModelBase>(BuildContext context,
    {required T model, required Proc1<String> onSelect}) {
  showDialog(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      value: model,
      child: AlertDialog(
        title: Text(model.title.tr()),
        titlePadding: EdgeInsets.all(17),
        contentPadding: EdgeInsets.zero,
        content: Consumer<T>(
          builder: (context, model, _) => Container(
            width: 300, // ios needs it, otherwise crash
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                interactive: true,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: List.from(
                    model.items.map((x) => ListTile(
                        title: Text(x.title),
                        onTap: () {
                          Navigator.pop(context);
                          onSelect(x.ident!);
                        })),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
