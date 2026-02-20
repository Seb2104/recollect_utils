part of '../../menus.dart';

class MenuDropDown extends StatefulWidget {
  final double height;
  final double width;
  final Colour colour;
  final BorderRadius borderRadius;
  final double iconSize;
  final List<dynamic> items;
  final void Function(dynamic value) onSelected;
  final double dropdownWidth;

  const MenuDropDown({
    super.key,
    required this.width,
    required this.items,
    required this.onSelected,
    this.height = 50,
    this.colour = Colours.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.iconSize = 16,
    required this.dropdownWidth,
  });

  @override
  State<MenuDropDown> createState() => _MenuDropDownState();
}

class _MenuDropDownState extends State<MenuDropDown> {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: InkWell(
          onTap: _toggleOverlay,
          child: Icon(
            _isOverlayVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _overlayEntry?.remove();
    _scrollController.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (!_isOverlayVisible) return false;
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      return true;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      return true;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      return true;
    }

    if (key == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return true;
    }

    return false;
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
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectEntry(dynamic entry) {
    setState(() {});
    widget.onSelected.call(entry);

    _hideOverlay();
  }

  OverlayEntry _createOverlayEntry() {
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
                offset: Offset(-(widget.width * 3), 0),
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                showWhenUnlinked: false,
                child: SizedBox(
                  width: widget.dropdownWidth,
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
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          return _buildItem(widget.items[index], index);
                        },
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

  Widget _buildItem(dynamic entry, int index) {
    Color? backgroundColor;
    backgroundColor = widget.colour;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => _selectEntry(entry),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [Expanded(child: Word('$entry'))]),
        ),
      ),
    );
  }
}
