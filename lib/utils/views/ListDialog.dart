import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Func.dart';
import 'package:amigotools/utils/types/UiItem.dart';

void showListDialog(BuildContext context,
    {String? title,
    required Iterable<UiItem> items,
    required Func1<dynamic, bool> onSelect}) {
  final children = items
      .map(
        (x) => SimpleDialogOption(
          child: ListTile(
            dense: true,
            title: Text(x.title,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          onPressed: () {
            if (onSelect(x.key)) Navigator.of(context).pop();
          },
        ),
      )
      .toList();

  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: title != null
                ? Text(
                    title,
                  )
                : null,
            children: children,
          ));
}
