import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/utils/types/UiItem.dart';
import 'package:amigotools/utils/types/Proc.dart';

List<Widget> buildAppBarActions<T>(
    {required List<UiItem> items, required Proc1<T> onPressed}) {
  var list = items
      .where((x) => x.fav)
      .map<Widget>((x) => IconButton(
            icon: Icon(x.icon),
            tooltip: x.title.tr(),
            onPressed: () => onPressed(x.key),
          ))
      .toList();

  final menuitems = items.where((x) => !x.fav);

  if (menuitems.isNotEmpty) {
    list.add(
      PopupMenuButton<T>(
        onSelected: (key) => onPressed(key),
        itemBuilder: (context) => menuitems
            .map(
              (x) => PopupMenuItem<T>(
                value: x.key,
                child: Row(
                  children: [
                    Icon(
                      x.icon,
                      color: Colors.black, // TODO: use color from theme
                    ),
                    Text(" "), // todo
                    Text(x.title.tr()),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  return list;
}
