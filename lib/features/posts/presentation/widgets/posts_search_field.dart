import 'package:flutter/material.dart';

class PostsSearchField extends StatefulWidget {
  const PostsSearchField({
    super.key,
    required this.query,
    required this.onQueryChanged,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  State<PostsSearchField> createState() => _PostsSearchFieldState();
}

class _PostsSearchFieldState extends State<PostsSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );

  @override
  void didUpdateWidget(PostsSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync only external query changes (e.g. clear-search actions); text
    // typed here already matches and must not reset the cursor.
    if (widget.query != oldWidget.query && widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onQueryChanged,
      textInputAction: .search,
      decoration: InputDecoration(
        hintText: 'Search posts',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  widget.onQueryChanged('');
                },
              ),
      ),
    );
  }
}
