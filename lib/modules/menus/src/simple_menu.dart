part of '../menus.dart';

class SimpleMenu<T> extends StatefulWidget {
  const SimpleMenu({
    super.key,
    required this.items,
    required this.setStateCallback,
    this.initialSelection,
    this.onSelected,
    this.height = 40,
    this.width,
    this.label,
  });

  final List<MenuItem> items;
  final VoidCallback setStateCallback;
  final double? height;
  final double? width;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final String? label;

  @override
  State<SimpleMenu<T>> createState() => _SimpleMenuState<T>();
}

class _SimpleMenuState<T> extends State<SimpleMenu<T>> {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  int? _currentHighlight;
  int? _selectedEntryIndex;
  bool _isOverlayVisible = false;
  String _displayText = '';

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: InkWell(
          onTap: _toggleOverlay,
          child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: widget.label != null ? Word(widget.label!) : null,
              suffixIcon: Icon(
                _isOverlayVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ),
            child: Text(
              _displayText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeSelection();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _overlayEntry?.remove();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SimpleMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _currentHighlight = null;
    }

    if (oldWidget.initialSelection != widget.initialSelection) {
      _initializeSelection();
    }
  }

  void _initializeSelection() {
    if (widget.initialSelection != null) {
      final index = widget.items.indexWhere(
        (e) => e.value == widget.initialSelection,
      );
      if (index != -1) {
        _displayText = widget.items[index].label;
        _selectedEntryIndex = index;
      }
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
      if (widget.items.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int next = ((_currentHighlight ?? -1) + 1) % widget.items.length;
      _currentHighlight = next;
    });
    _scrollToHighlight();
  }

  void _highlightPrevious() {
    setState(() {
      if (widget.items.isEmpty) {
        _currentHighlight = null;
        return;
      }

      int prev = _currentHighlight ?? 0;
      prev = (prev - 1) % widget.items.length;
      if (prev < 0) prev = widget.items.length - 1;

      _currentHighlight = prev;
    });
    _scrollToHighlight();
  }

  void _handleEnter() {
    if (_currentHighlight != null && _currentHighlight! < widget.items.length) {
      final entry = widget.items[_currentHighlight!];
      _selectEntry(entry, _currentHighlight!);
    }
  }

  void _scrollToHighlight() {
    if (_currentHighlight == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _currentHighlight! < widget.items.length) {
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
      _isOverlayVisible = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
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
    setState(() {
      _displayText = entry.label;
      _selectedEntryIndex = index;
      _currentHighlight = index;
    });
    widget.onSelected?.call(entry.value);
    widget.setStateCallback.call();

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
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) =>
                            _buildItem(widget.items[index], index),
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
