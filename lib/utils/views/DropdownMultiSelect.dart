import 'package:flutter/material.dart';

class DropdownMultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final void Function(List<String>) onChanged;
  final String? hint;
  final bool isDense;
  final bool enabled;
  final InputDecoration? decoration;

  final Widget Function(List<String> selectedValues)? titleBuilder;
  final Widget Function(String option)? itemBuilder;

  const DropdownMultiSelect({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.hint,
    this.titleBuilder,
    this.itemBuilder,
    this.isDense = false,
    this.enabled = true,
    this.decoration,
  });

  @override
  _DropdownMultiSelectState createState() => _DropdownMultiSelectState();
}

class _DropdownMultiSelectState extends State<DropdownMultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.titleBuilder != null
            ? widget.titleBuilder!(widget.selectedItems)
            : Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(widget.selectedItems.isNotEmpty
                    ? _buildTitleString()
                    : widget.hint ?? ""),
              ),
        Positioned.fill(
          // expands to first sibling if that's higher
          child: Container(
            alignment: Alignment.centerLeft,
            child: DropdownButtonFormField<String>(
              decoration: widget.decoration != null
                  ? widget.decoration
                  : InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    ),
              isDense: widget.isDense,
              onChanged: widget.enabled ? (x) {} : null,
              selectedItemBuilder: (context) => widget.items // important
                  .map(
                    (e) => DropdownMenuItem(
                      child: Container(),
                    ),
                  )
                  .toList(),
              items: widget.items
                  .map(
                    (x) => DropdownMenuItem(
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(x)
                          : _CheckboxRow(
                              selected: widget.selectedItems.contains(x),
                              label: x,
                              onChanged: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    if (!widget.selectedItems.contains(x)) {
                                      widget.selectedItems.add(x);
                                      widget.onChanged(widget.selectedItems);
                                    }
                                  } else {
                                    if (widget.selectedItems.remove(x))
                                      widget.onChanged(widget.selectedItems);
                                  }
                                });
                              },
                            ),
                      value: x,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _buildTitleString() {
    return widget.items
        .where((x) => widget.selectedItems.contains(x)) // using original order
        .join(", ");
  }
}

class _CheckboxRow extends StatefulWidget {
  final String label;
  final bool selected;
  final void Function(bool) onChanged;

  const _CheckboxRow({
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  @override
  _CheckboxRowState createState() => _CheckboxRowState(selected);
}

class _CheckboxRowState extends State<_CheckboxRow> {
  bool selected;

  _CheckboxRowState(this.selected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        // hotfix for GestureDetector, otherwise not full height is tappable
        color: Colors.transparent, // important
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: (val) => _onTap(),
            ),
            Expanded(
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    // setState is important because popup of dropdown is not rebuilt with parent widget
    setState(() {
      selected = !selected;
      widget.onChanged(selected);
    });
  }
}
