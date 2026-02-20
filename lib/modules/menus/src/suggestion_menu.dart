part of '../menus.dart';

class MenuItems extends StatefulWidget {
  final double height;
  final double width;
  final Colour colour;
  final BorderRadius borderRadius;
  final double size;
  final List<dynamic> items;
  final void Function(dynamic value) onSelected;

  const MenuItems({
    super.key,
    required this.height,
    required this.width,
    required this.colour,
    required this.borderRadius,
    required this.size,
    required this.items,
    required this.onSelected,
  });

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  bool _isOverlayVisible = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _toggleOverlay();
        });
      },
      child: Icon(
        _isOverlayVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: widget.colour,
        size: widget.size,
      ),
    );
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
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                showWhenUnlinked: false,
                child: SizedBox(
                  width: widget.width,
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
                            _buildItem(widget.items[index]),
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

  Widget _buildItem(dynamic item) {
    return Material(
      color: widget.colour,
      child: InkWell(
        onTap: () => widget.onSelected.call(item),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [Expanded(child: Text(item.label))]),
        ),
      ),
    );
  }
}

class IconStyle {
  final double size;
  final Colour colour;

  IconStyle({required this.size, required this.colour});
}
