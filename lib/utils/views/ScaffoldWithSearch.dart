import 'package:flutter/material.dart';
import 'package:amigotools/utils/types/Proc.dart';

class ScaffoldWithSearch extends StatefulWidget {
  final String title;
  final Widget? drawer;
  final Widget? body;
  final List<Widget>? actions;
  final String searchHint;
  final Proc1<String>? onSearchChanged;
  final bool blockBackButton;

  const ScaffoldWithSearch({
    required this.title,
    this.drawer,
    this.body,
    this.actions,
    this.searchHint = "Search",
    this.onSearchChanged,
    this.blockBackButton = false,
  });

  @override
  _ScaffoldWithSearchState createState() => _ScaffoldWithSearchState();
}

class _ScaffoldWithSearchState extends State<ScaffoldWithSearch> {
  final _editingController = TextEditingController();

  bool _drawerOpened = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _editingController.addListener(_controllerListener);
  }

  @mustCallSuper
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          _stopSearch();
          return false;
        } else {
          return !widget.blockBackButton || _drawerOpened;
        }
      },
      child: Scaffold(
        appBar: !_isSearching ? _buildNormalAppBar() : _buildSearchAppBar(),
        drawer: widget.drawer,
        body: widget.body,
        onDrawerChanged: (opened) => _drawerOpened = opened,
      ),
    );
  }

  AppBar _buildNormalAppBar() {
    final actions = widget.onSearchChanged != null
        ? <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
          ]
        : <Widget>[];

    if (widget.actions != null) actions.addAll(widget.actions!);

    return AppBar(
      title: Text(widget.title),
      actions: actions,
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: BackButton(onPressed: _stopSearch),
      title: TextField(
        controller: _editingController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.searchHint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_editingController.text.isNotEmpty) {
              _editingController.clear();
            } else {
              _stopSearch();
            }
          },
        ),
      ],
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _editingController.clear();
    });
  }

  void _controllerListener() {
    if (widget.onSearchChanged != null)
      widget.onSearchChanged!(_editingController.text);
  }
}
