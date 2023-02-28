import 'package:flutter/material.dart';

class UiItem<T>
{
  final T key;
  final String title;
  final IconData? icon;
  final List<UiItem<T>>? subitems;
  final bool fav;
  final bool separator;
  final bool checkbox;

  const UiItem(
    this.key,
    this.title,
    {
      this.icon,
      this.subitems,
      this.fav = false,
      this.separator = false,
      this.checkbox = false,
    }
  );

  @override
  String toString() => this.title;
}