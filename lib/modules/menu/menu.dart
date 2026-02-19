/// A searchable dropdown menu widget.
///
/// [Menu] renders a compact trigger button that, when tapped, opens an
/// overlay dropdown populated with [MenuItem]s. It supports optional
/// **type-to-search** filtering (set [MenuConfig.searchable] to `true`),
/// keyboard navigation (arrow keys, Enter, Escape), and colour history.
///
/// ## Quick Start
///
/// ```dart
/// Menu(
///   height: 40,
///   width: 200,
///   items: [
///     MenuItem(label: 'Option A', value: 'a'),
///     MenuItem(label: 'Option B', value: 'b'),
///   ],
/// )
/// ```
///
/// ## Architecture
///
/// The menu is split into several collaborating classes:
///
/// | Class          | Role                                       |
/// |----------------|--------------------------------------------|
/// | [Menu]         | Root widget — trigger button & overlay host |
/// | [MenuController] | State management & overlay lifecycle      |
/// | [MenuItem]     | Data model + widget builder for each row   |
/// | [MenuScope]    | InheritedWidget providing controller access |
/// | [MenuConfig]   | Visual / behavioural options for the menu   |
/// | [ItemConfig]   | Visual options for individual items         |
library menu;
// V!
import 'package:recollect_utils/recollect_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'controller/menu_controller.dart';
part 'presentation/menu_item.dart';
part 'presentation/menu_scope.dart';
part 'structs/item_config.dart';
part 'structs/menu_config.dart';

/// Callback for custom item filtering logic.
///
/// Receives the full [items] list and the current search [query], and should
/// return a new list containing only the items that match.
typedef MenuFilterCallback =
    List<MenuItem> Function(List<MenuItem> items, String query);

/// Callback for custom search-highlight logic.
///
/// Receives the current (possibly filtered) [items] and the [query], and
/// should return the index of the best match, or `null` if nothing matches.
typedef MenuSearchCallback = int? Function(List<MenuItem> items, String query);

/// Callback invoked when a menu item is selected.
///
/// Receives the selected [MenuItem] as a parameter.
typedef OnMenuItemSelected = void Function(MenuItem item);

/// A dropdown menu widget with optional search, filter, and keyboard support.
///
/// Displays a trigger bar showing the currently selected [MenuItem]. Tapping
/// it opens an overlay with the available items. When [MenuConfig.searchable]
/// is enabled, the trigger bar transforms into a text field for live
/// filtering.
///
/// Pass a [MenuController] to control the menu programmatically (e.g. to
/// open, close, or select items from outside the widget).
class Menu extends StatefulWidget {
  final double height;
  final double width;
  final List<MenuItem> items;
  final MenuController? controller;
  final OnMenuItemSelected? onSelected;

  final MenuConfig menuConfig;
  final ItemConfig itemConfig;

  const Menu({
    super.key,
    required this.height,
    required this.width,
    required this.items,
    this.controller,
    this.onSelected,
    this.menuConfig = const MenuConfig(),
    this.itemConfig = const ItemConfig(),
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late final FocusNode _focusNode;
  late final FocusNode _searchFocusNode;
  late final LayerLink _layerLink;
  late final ScrollController _scrollController;
  late final MenuController _menuController;
  late final TextEditingController _searchController;
  bool _controllerCreatedInternally = false;
  bool _isClosing = false;
  bool _wasOverlayVisible = false;

  bool get _searchable => widget.menuConfig.searchable;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _layerLink = LayerLink();
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    if (widget.controller != null) {
      _menuController = widget.controller!;
      _menuController.attachFocusNode(_focusNode);
      _menuController.attachOnSelected(widget.onSelected);
    } else {
      _controllerCreatedInternally = true;
      _menuController = MenuController(
        initialState: MenuState(
          selectedItem: widget.items.first,
          filteredItems: widget.items,
          isOverlayVisible: false,
        ),
        focusNode: _focusNode,
        onSelected: widget.onSelected,
      );
    }

    _searchController.addListener(_onSearchChanged);
    _menuController.addListener(_onControllerChanged);

    if (_searchable) {
      HardwareKeyboard.instance.addHandler(_onKeyEvent);
    }
  }

  @override
  void dispose() {
    if (_searchable) {
      HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    }
    _menuController.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    if (_controllerCreatedInternally) {
      _menuController.dispose();
    }
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!mounted || _isClosing) return;
    final config = widget.menuConfig;
    final query = _searchController.text;

    if (config.enableFilter) {
      _menuController.filterItems(
        widget.items,
        query,
        filterCallback: config.filterCallback,
      );
    } else {
      _menuController.updateFilteredItems(widget.items);
    }

    if (config.enableSearch) {
      _menuController.searchHighlight(
        query,
        searchCallback: config.searchCallback,
      );
      _scrollToHighlight();
    }
  }

  void _onControllerChanged() {
    if (!mounted) return;

    final isVisible = _menuController.value.isOverlayVisible;
    final wasVisible = _wasOverlayVisible;
    _wasOverlayVisible = isVisible;

    if (wasVisible && !isVisible) {
      _isClosing = true;
      _searchController.clear();
      _menuController.updateFilteredItems(widget.items);
      _isClosing = false;
    }

    setState(() {});
  }

  bool _onKeyEvent(KeyEvent event) {
    if (!_menuController.isOverlayVisible) return false;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _menuController.highlightNext();
      _scrollToHighlight();
      return true;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _menuController.highlightPrevious();
      _scrollToHighlight();
      return true;
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      _menuController.selectHighlighted();
      return true;
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _focusNode.unfocus();
      _searchFocusNode.unfocus();
      _menuController.hideOverlay();
      return true;
    }

    return false;
  }

  void _scrollToHighlight() {
    final idx = _menuController.value.highlightedIndex;
    if (idx == null) return;

    final itemExtent = widget.height;
    final targetOffset = idx * itemExtent;
    final viewportHeight = _scrollController.position.viewportDimension;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (targetOffset < _scrollController.offset) {
      _scrollController.jumpTo(targetOffset.clamp(0.0, maxScroll));
    } else if (targetOffset + itemExtent >
        _scrollController.offset + viewportHeight) {
      _scrollController.jumpTo(
        (targetOffset + itemExtent - viewportHeight).clamp(0.0, maxScroll),
      );
    }
  }

  void _onFocusChanged() {
    if (!mounted) return;
    if (_searchable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_focusNode.hasFocus && !_searchFocusNode.hasFocus) {
          _menuController.hideOverlay();
        }
      });
    } else {
      if (!_focusNode.hasFocus) _menuController.hideOverlay();
    }
  }

  void _onSearchFocusChanged() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focusNode.hasFocus && !_searchFocusNode.hasFocus) {
        _menuController.hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: GestureDetector(
            onTap: () {
              _menuController.toggleOverlay(context, _createItemsOverlay);
            },
            child: Material(
              color: widget.menuConfig.backgroundColour,
              borderRadius: _menuController.isOverlayVisible
                  ? BorderRadius.only(
                      topLeft: widget.menuConfig.borderRadius.topLeft,
                      topRight: widget.menuConfig.borderRadius.topRight,
                    )
                  : widget.menuConfig.borderRadius,
              elevation: widget.itemConfig.elevation,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  if (_searchable && _menuController.isOverlayVisible)
                    Expanded(
                      child: TextField(
                        cursorHeight: 14,
                        cursorColor: Colours.black,
                        cursorWidth: 1,
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: TIMES_NEW_ROMAN,
                          fontFamilyFallback: [APPLE_COLOUR_EMOJI],
                        ),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    )
                  else ...[
                    Word(_menuController.value.selectedItem.label),
                    Spacer(),
                  ],
                  AnimatedRotation(
                    turns: 1,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _menuController.isOverlayVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createItemsOverlay() {
    _searchFocusNode.requestFocus();
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = _menuController.value.selectedItem.label;
    _searchController.addListener(_onSearchChanged);
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          _searchFocusNode.unfocus();
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
                    elevation: widget.itemConfig.elevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: widget.itemConfig.borderRadius.bottomLeft,
                        bottomRight: widget.itemConfig.borderRadius.bottomRight,
                      ),
                    ),
                    color: widget.itemConfig.backgroundColour,
                    child: _buildMenuContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return MenuScope(
      controller: _menuController,
      itemConfig: widget.itemConfig,
      itemHeight: widget.height,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: widget.itemConfig.padding,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _menuController.value.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuController.value.filteredItems[index];
                    final isHighlighted =
                        _menuController.value.highlightedIndex == index;
                    return Container(
                      color: isHighlighted
                          ? Colors.blue.withValues(alpha: 0.1)
                          : null,
                      child: item.build(context),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
