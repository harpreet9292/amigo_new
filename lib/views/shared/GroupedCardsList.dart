import 'package:flutter/material.dart';

import 'package:amigotools/utils/types/Func.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/utils/types/BriefDbItem.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/utils/types/ViewModelItem.dart';
import 'package:amigotools/utils/types/UiItem.dart';

class GroupedCardsList extends StatelessWidget {
  final List<BriefDbItem> groups;
  final Func1<BriefDbItem, Iterable<ViewModelItem>> onGetItemsForGroup;
  final Proc1<dynamic> onTap;
  final Func1<dynamic, Iterable<UiItem>>? onGetMenuItems;
  final Proc2<dynamic, dynamic>? onMenuItemSelect;

  const GroupedCardsList({
    required this.groups,
    required this.onGetItemsForGroup,
    required this.onTap,
    this.onGetMenuItems,
    this.onMenuItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Scrollbar(
        interactive: true,
        child: ListView(
          children: List.from(_queryListItems(context)),
        ),
      ),
    );
  }

  Iterable<Widget> _queryListItems(BuildContext context) sync* {
    for (final group in groups) {
      final items = onGetItemsForGroup(group);
      if (items.isNotEmpty) {
        yield _buildGroupHeader(context, group.title);
        yield* items.map((x) => _buildItem(context, x));
      }
    }
  }

  Widget _buildGroupHeader(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 2, left: 8, right: 0),
      child: Text(
        title,
        style: TextStyle(
          color: GeneralConfig.palette2Neutrals900,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, ViewModelItem item) {
    return Card(
      margin: EdgeInsets.all(4),
      elevation: 3,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                item.subtitle1 ?? "",
                style: TextStyle(fontSize: 14),
              ),
            ),
            item.subtitle2 != null
                ? Text(
                    item.subtitle2!,
                    style: TextStyle(fontSize: 14),
                  )
                : Container(),
          ],
        ),
        onTap: () => onTap(item.key),
        trailing: onGetMenuItems != null
            ? PopupMenuButton(
                itemBuilder: (context) => onGetMenuItems!(item.key)
                    .map(
                      (x) => PopupMenuItem(
                        child: Text(x.title),
                        value: x.key,
                      ),
                    )
                    .toList(),
                onSelected: (key) => onMenuItemSelect!(item.key, key),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert,
                    color: GeneralConfig.palette2Primary600),
              )
            : null,
      ),
    );
  }
}
