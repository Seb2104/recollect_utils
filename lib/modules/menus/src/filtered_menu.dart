part of '../menus.dart';

class FilteredMenu<T> extends StatefulWidget {
  const FilteredMenu({
    super.key,
    required this.entries,
    required this.setStateCallback,
    this.initialSelection,
    this.onSelected,
    this.height = 40,
    this.width,
    this.label,
    this.keyboardType,
    this.cursorHeight,
  });

  final List<MenuItem> entries;
  final VoidCallback setStateCallback;
  final double? height;
  final double? width;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final String? label;
  final TextInputType? keyboardType;
  final double? cursorHeight;

  @override
  State<FilteredMenu<T>> createState() => _FilteredMenuState<T>();
}

class _FilteredMenuState<T> extends State<FilteredMenu<T>> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  List<MenuItem> _filteredEntries = [];
  int? _currentHighlight;
  int? _selectedEntryIndex;
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          maxLines: 1,
          cursorHeight: widget.cursorHeight,
          onTap: _toggleOverlay,
          onChanged: (text) {
            if (!_isOverlayVisible) {
              _showOverlay();
            }
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: widget.label != null ? Word(widget.label!) : null,
            suffixIcon: IconButton(
              icon: _isOverlayVisible
                  ? const Icon(Icons.arrow_drop_up)
                  : const Icon(Icons.arrow_drop_down),
              onPressed: _toggleOverlay,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _filteredEntries = widget.entries;

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _initializeSelection();

    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _overlayEntry?.remove();
    _scrollController.dispose();

    _textController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(FilteredMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.entries != widget.entries) {
      _filteredEntries = widget.entries;
      _currentHighlight = null;
    }

    if (oldWidget.initialSelection != widget.initialSelection) {
      _initializeSelection();
    }
  }

  void _updateFilteredEntries() {
    final text = _textController.text;

    if (text.isNotEmpty) {
      _filteredEntries = widget.entries.where((entry) {
        return entry.label.toLowerCase().contains(text.toLowerCase());
      }).toList();
      final searchText = text.toLowerCase();
      final index = _filteredEntries.indexWhere(
        (entry) => entry.label.toLowerCase().startsWith(searchText),
      );
      _currentHighlight = index != -1 ? index : null;

      if (_currentHighlight != null) {
        _scrollToHighlight();
      }
      setState(() {});
      widget.setStateCallback.call();
    } else {
      _filteredEntries = widget.entries;
    }
  }

  void _initializeSelection() {
    if (widget.initialSelection != null) {
      final index = widget.entries.indexWhere(
        (e) => e.value == widget.initialSelection,
      );
      if (index != -1) {
        _updateTextController(widget.entries[index].label);
        _selectedEntryIndex = index;
      }
    }
  }

  void _updateTextController(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onTextChanged() {
    if (_isOverlayVisible) {
      setState(() {
        _updateFilteredEntries();
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOverlayVisible) {
      Future.delayed(Duration(milliseconds: 100), () {
        _hideOverlay();
      });
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (!_isOverlayVisible) return false;
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      _highlightNext();
      return true;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      _highlightPrevious();
      return true;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _handleEnter();
      return true;
    }

    if (key == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return true;
    }

    return false;
  }

  void _highlightNext() {
    setState(() {
      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int next = ((_currentHighlight ?? -1) + 1) % _filteredEntries.length;

      _currentHighlight = next;
      _updateTextController(_filteredEntries[next].label);
    });
    _scrollToHighlight();
  }

  void _highlightPrevious() {
    setState(() {
      if (_filteredEntries.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int prev = _currentHighlight ?? 0;
      prev = (prev - 1) % _filteredEntries.length;
      if (prev < 0) prev = _filteredEntries.length - 1;

      _currentHighlight = prev;
      _updateTextController(_filteredEntries[prev].label);
    });
    _scrollToHighlight();
  }

  void _handleEnter() {
    if (_currentHighlight != null &&
        _currentHighlight! < _filteredEntries.length) {
      final entry = _filteredEntries[_currentHighlight!];
      _selectEntry(entry, _currentHighlight!);
    }
  }

  void _scrollToHighlight() {
    if (_currentHighlight == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _currentHighlight! < _filteredEntries.length) {
        final itemHeight = 48.0;
        final offset = _currentHighlight! * itemHeight;
        final viewportHeight = _scrollController.position.viewportDimension;
        final currentScroll = _scrollController.offset;

        if (offset < currentScroll ||
            offset + itemHeight > currentScroll + viewportHeight) {
          _scrollController.animateTo(
            offset - (viewportHeight / 2) + (itemHeight / 2),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_isOverlayVisible) return;

    setState(() {
      _filteredEntries = widget.entries;
      _isOverlayVisible = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _hideOverlay() {
    if (!_isOverlayVisible) return;

    setState(() {
      _isOverlayVisible = false;
      _currentHighlight = null;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectEntry(MenuItem entry, int index) {
    _updateTextController(entry.label);
    _selectedEntryIndex = index;
    _currentHighlight = index;
    widget.onSelected?.call(entry.value);

    _hideOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _hideOverlay();
        },
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                showWhenUnlinked: false,
                child: SizedBox(
                  width: widget.width ?? size.width,

                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _filteredEntries.length,
                        itemBuilder: (context, index) =>
                            _buildItem(_filteredEntries[index], index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(MenuItem entry, int index) {
    final isHighlighted = index == _currentHighlight;
    final isSelected = index == _selectedEntryIndex;

    Color? backgroundColor;
    if (isHighlighted) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => _selectEntry(entry, index),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [Expanded(child: Text(entry.label))]),
        ),
      ),
    );
  }
}
