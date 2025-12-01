import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback onBackButtonPressed;
  final ValueChanged<String> onSearchChanged;
  final List<Widget>? actions;

  const SearchAppBar({
    super.key,
    required this.titleText,
    required this.onBackButtonPressed,
    required this.onSearchChanged,
    this.actions,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearchChanged(_searchController.text);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchChanged('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> finalActions = [
      IconButton(
        icon: Icon(_isSearching ? Icons.close : Icons.search),
        onPressed: _toggleSearch,
      ),
      if (!_isSearching && widget.actions != null) ...widget.actions!,
    ];

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.colors.gradientStart, context.colors.gradientEnd],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: _isSearching ? _toggleSearch : widget.onBackButtonPressed,
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onPrimary.withOpacity(0.7),
                ),
              ),
              style: TextStyle(color: theme.colorScheme.onPrimary),
            )
          : Text(widget.titleText),
      actions: finalActions,
    );
  }
}
