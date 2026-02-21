part of '../../menus.dart';

class MenuDropDown extends StatefulWidget {
  final double height;
  final double width;
  final Colour colour;
  final double iconSize;
  final List<dynamic> items;
  final void Function(dynamic value) onSelected;
  final double dropdownWidth;
  final AlignType alignDropdown;
  final TextAlign alignText;
  final BoxDecoration decoration;

  const MenuDropDown({
    super.key,
    required this.width,
    required this.items,
    required this.onSelected,
    this.height = 50,
    this.colour = Colours.white,
    this.decoration = const BoxDecoration(),
    this.iconSize = 16,
    required this.dropdownWidth,
    this.alignDropdown = AlignType.fill,
    this.alignText = TextAlign.left,
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
    widget.onSelected.call(entry);
    setState(() {});

    _hideOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    final double _dropdownWidth = switch (widget.alignDropdown) {
      (AlignType.left || AlignType.center || AlignType.right) =>
        widget.dropdownWidth / 2,
      (AlignType.fill) => widget.dropdownWidth,
    };

    final Offset _alignOffset = switch (widget.alignDropdown) {
      (AlignType.fill || AlignType.left) => Offset(-(widget.width * 3), 0),
      AlignType.center => Offset(-(widget.width * 2), 0),
      AlignType.right => Offset(-(widget.width * 1), 0),
    };

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _hideOverlay();
            },
            behavior: HitTestBehavior.translucent,
            child: SizedBox.expand(),
          ),
          CompositedTransformFollower(
            offset: _alignOffset,
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            showWhenUnlinked: false,
            child: SizedBox(
              width: widget.dropdownWidth,
              child: Material(
                elevation: 8,
                child: Container(
                  decoration: widget.decoration.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
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
    );
  }

  Widget _buildItem(dynamic entry, int index) {
    Color? backgroundColor;
    backgroundColor = widget.colour;

    return GestureDetector(
      onTap: () => _selectEntry(entry),
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: backgroundColor,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Word('$entry', textAlign: widget.alignText)),
            ],
          ),
        ),
      ),
    );
  }
}
