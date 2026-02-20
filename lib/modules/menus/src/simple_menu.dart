part of '../menus.dart';

/// A dropdown menu widget with optional search, filter, and keyboard support.
///
/// Displays a trigger bar showing the currently selected [MenuItem]. Tapping
/// it opens an overlay with the available items. When [MenuConfig.searchable]
/// is enabled, the trigger bar transforms into a text field for live
/// filtering.
///
/// Pass a [MenuController] to control the menu programmatically (e.g. to
/// open, close, or select items from outside the widget).
class SimpleMenu extends StatefulWidget {
  final double height;
  final double width;
  final List<MenuItem> items;
  final MenuController? controller;
  final OnMenuItemSelected? onSelected;

  final MenuConfig menuConfig;
  final ItemConfig itemConfig;

  const SimpleMenu({
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
  State<SimpleMenu> createState() => _MenuState();
}

class _MenuState extends State<SimpleMenu> {
  late final FocusNode _focusNode;
  late final FocusNode _searchFocusNode;
  late final LayerLink _layerLink;
  late final ScrollController _scrollController;
  late final MenuController _menuController;
  late final TextEditingController _searchController;
  bool _controllerCreatedInternally = false;
  bool _isClosing = false;
  bool _wasOverlayVisible = false;
  bool _enableFilter = false;
  bool _enableSearch = false;

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
        initialState: SimpleMenuState(
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
    if (!_menuController.isOverlayVisible) return;

    setState(() {
      _enableFilter = widget.menuConfig.enableFilter;
      _enableSearch = widget.menuConfig.enableSearch;
      _updateFilteredEntries();
    });
  }

  void _updateFilteredEntries() {
    final text = _searchController.text;
    final config = widget.menuConfig;

    // Filter items based on _enableFilter flag
    List<MenuItem> filtered;
    if (_enableFilter && text.isNotEmpty) {
      if (config.filterCallback != null) {
        filtered = config.filterCallback!(widget.items, text);
      } else {
        final query = text.toLowerCase();
        filtered = widget.items
            .where((item) => item.label.toLowerCase().contains(query))
            .toList();
      }
    } else {
      filtered = widget.items;
    }

    _menuController.updateFilteredItems(filtered);

    // Search and highlight based on _enableSearch flag
    if (_enableSearch && text.isNotEmpty) {
      int? highlightIndex;
      if (config.searchCallback != null) {
        highlightIndex = config.searchCallback!(filtered, text);
      } else {
        final searchText = text.toLowerCase();
        final index = filtered.indexWhere(
          (item) => item.label.toLowerCase().contains(searchText),
        );
        highlightIndex = index != -1 ? index : null;
      }

      if (highlightIndex != null) {
        _menuController.value = _menuController.value.copyWith(
          highlightedIndex: highlightIndex,
        );
        _scrollToHighlight();
      } else {
        _menuController.value = _menuController.value.copyWith(
          clearHighlight: true,
        );
      }
    } else {
      _menuController.value = _menuController.value.copyWith(
        clearHighlight: true,
      );
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
      _highlightNext();
      return true;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _highlightPrevious();
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

  void _updateTextController(String text) {
    _searchController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _highlightNext() {
    setState(() {
      _enableFilter = false;
      _enableSearch = false;

      final filteredItems = _menuController.value.filteredItems;
      if (filteredItems.isEmpty) {
        _menuController.value = _menuController.value.copyWith(
          clearHighlight: true,
        );
        return;
      }

      final current = _menuController.value.highlightedIndex;
      final next = (current == null) ? 0 : (current + 1) % filteredItems.length;

      _menuController.value = _menuController.value.copyWith(
        highlightedIndex: next,
      );

      // Update text field with highlighted item's label
      _searchController.removeListener(_onSearchChanged);
      _updateTextController(filteredItems[next].label);
      _searchController.addListener(_onSearchChanged);
    });
    _scrollToHighlight();
  }

  void _highlightPrevious() {
    setState(() {
      _enableFilter = false;
      _enableSearch = false;

      final filteredItems = _menuController.value.filteredItems;
      if (filteredItems.isEmpty) {
        _menuController.value = _menuController.value.copyWith(
          clearHighlight: true,
        );
        return;
      }

      final current = _menuController.value.highlightedIndex;
      final prev = (current == null || current == 0)
          ? filteredItems.length - 1
          : current - 1;

      _menuController.value = _menuController.value.copyWith(
        highlightedIndex: prev,
      );

      // Update text field with highlighted item's label
      _searchController.removeListener(_onSearchChanged);
      _updateTextController(filteredItems[prev].label);
      _searchController.addListener(_onSearchChanged);
    });
    _scrollToHighlight();
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

/// Horizontal alignment options for menu item text.
enum Aligned {
  /// Left-aligned text.
  left,

  /// Centre-aligned text.
  center,

  /// Right-aligned text.
  right,
}

/// Visual configuration for individual dropdown items.
///
/// Controls the look and feel of each row in the [SimpleMenu] overlay, including
/// internal padding, text alignment, background colour, corner radius,
/// border, and elevation.
///
/// ```dart
/// ItemConfig(
///   alignment: Aligned.left,
///   backgroundColour: Colours.white,
///   elevation: 2,
/// )
/// ```
class ItemConfig {
  final EdgeInsetsGeometry padding;
  final Aligned alignment;
  final Colour backgroundColour;
  final BorderRadius borderRadius;
  final Border border;
  final double elevation;

  const ItemConfig({
    this.padding = const EdgeInsetsGeometry.all(10),
    this.alignment = Aligned.center,
    this.backgroundColour = Colours.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.border = const Border(),
    this.elevation = 5,
  });
}

/// Behavioural and visual configuration for a [SimpleMenu] widget.
///
/// Controls the trigger bar's appearance (colour, corner radius, border,
/// padding) as well as search behaviour:
///
/// - [searchable] — when `true`, the trigger bar becomes a text field on
///   open so the user can type to search.
/// - [enableFilter] — live-filter the item list as the user types.
/// - [enableSearch] — highlight the best match as the user types (without
///   removing non-matching items).
/// - [filterCallback] / [searchCallback] — optional custom logic for
///   filtering and highlighting. When omitted, a case-insensitive
///   substring match is used.
///
/// ```dart
/// MenuConfig(
///   searchable: true,
///   enableFilter: true,
///   borderRadius: BorderRadius.circular(8),
/// )
/// ```
class MenuConfig {
  final EdgeInsetsGeometry padding;
  final Colour backgroundColour;
  final BorderRadius borderRadius;
  final Border border;
  final bool searchable;
  final bool enableFilter;
  final bool enableSearch;
  final MenuFilterCallback? filterCallback;
  final MenuSearchCallback? searchCallback;

  const MenuConfig({
    this.padding = const EdgeInsetsGeometry.all(0),
    this.backgroundColour = Colours.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.border = const Border(),
    this.searchable = false,
    this.enableFilter = true,
    this.enableSearch = true,
    this.filterCallback,
    this.searchCallback,
  });
}

/// An [InheritedWidget] that provides the active [MenuController],
/// [ItemConfig], and item height to descendant widgets.
///
/// Placed at the root of the dropdown overlay so that [MenuItem.build] can
/// look up the controller and styling without needing explicit parameters.
///
/// Access the nearest scope with `MenuScope.of(context)`.
class MenuScope extends InheritedWidget {
  final MenuController controller;
  final ItemConfig itemConfig;
  final double itemHeight;

  MenuItem? get selected => controller.value.selectedItem;

  const MenuScope({
    super.key,
    required this.controller,
    required this.itemConfig,
    required this.itemHeight,
    required super.child,
  });

  static MenuScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MenuScope>();
    assert(scope != null, 'No MenuScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(MenuScope oldWidget) {
    return controller != oldWidget.controller ||
        itemConfig != oldWidget.itemConfig ||
        itemHeight != oldWidget.itemHeight;
  }
}

/// Immutable snapshot of the menu's current state.
///
/// Held by [MenuController] as a [ValueNotifier] value, so any change to
/// the state triggers listeners (and therefore widget rebuilds).
///
/// - [selectedItem] — the item currently shown in the trigger bar.
/// - [filteredItems] — the subset of items visible in the dropdown (may be
///   the full list or a search-filtered subset).
/// - [isOverlayVisible] — whether the dropdown overlay is currently showing.
/// - [highlightedIndex] — the index of the keyboard-highlighted item, or
///   `null` if nothing is highlighted.
class SimpleMenuState {
  final MenuItem selectedItem;
  final List<MenuItem> filteredItems;
  final bool isOverlayVisible;
  final int? highlightedIndex;

  const SimpleMenuState({
    required this.selectedItem,
    required this.filteredItems,
    required this.isOverlayVisible,
    this.highlightedIndex,
  });

  SimpleMenuState copyWith({
    MenuItem? selectedItem,
    List<MenuItem>? filteredItems,
    bool? isOverlayVisible,
    int? highlightedIndex,
    bool clearHighlight = false,
  }) {
    return SimpleMenuState(
      selectedItem: selectedItem ?? this.selectedItem,
      filteredItems: filteredItems ?? this.filteredItems,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      highlightedIndex: clearHighlight
          ? null
          : (highlightedIndex ?? this.highlightedIndex),
    );
  }
}

/// Manages the lifecycle, selection, filtering, and overlay visibility of a
/// [SimpleMenu].
///
/// Extends [ValueNotifier] so the [SimpleMenu] widget rebuilds whenever the state
/// changes. You can create a controller externally and pass it to [SimpleMenu] for
/// programmatic control, or let the widget create one internally.
///
/// ## Key methods
///
/// - [selectItem] — picks an item, closes the overlay, and unfocuses.
/// - [filterItems] — filters the item list against a search query.
/// - [searchHighlight] — highlights the best-matching item without filtering.
/// - [highlightNext] / [highlightPrevious] — keyboard arrow navigation.
/// - [showOverlay] / [hideOverlay] / [toggleOverlay] — overlay management.
class MenuController extends ValueNotifier<SimpleMenuState> {
  FocusNode? _focusNode;
  OverlayEntry? _overlay;
  OnMenuItemSelected? _onSelected;

  MenuController({
    required SimpleMenuState initialState,
    FocusNode? focusNode,
    OnMenuItemSelected? onSelected,
  }) : _focusNode = focusNode,
       _onSelected = onSelected,
       super(initialState);

  void attachFocusNode(FocusNode node) {
    _focusNode = node;
  }

  void attachOnSelected(OnMenuItemSelected? callback) {
    _onSelected = callback;
  }

  bool get isOverlayVisible => _overlay != null;

  void selectItem(MenuItem item) {
    value = value.copyWith(selectedItem: item, isOverlayVisible: false);
    _focusNode?.unfocus();
    hideOverlay();
    _onSelected?.call(item);
  }

  void updateFilteredItems(List<MenuItem> items) {
    value = value.copyWith(filteredItems: items);
  }

  void highlightNext() {
    final items = value.filteredItems;
    if (items.isEmpty) return;
    final current = value.highlightedIndex;
    final next = (current == null) ? 0 : (current + 1) % items.length;
    value = value.copyWith(highlightedIndex: next);
    if (_overlay != null && _overlay!.mounted) {
      _overlay!.markNeedsBuild();
    }
  }

  void highlightPrevious() {
    final items = value.filteredItems;
    if (items.isEmpty) return;
    final current = value.highlightedIndex;
    final prev = (current == null || current == 0)
        ? items.length - 1
        : current - 1;
    value = value.copyWith(highlightedIndex: prev);
    if (_overlay != null && _overlay!.mounted) {
      _overlay!.markNeedsBuild();
    }
  }

  void selectHighlighted() {
    final idx = value.highlightedIndex;
    if (idx != null && idx < value.filteredItems.length) {
      selectItem(value.filteredItems[idx]);
    }
  }

  void filterItems(
    List<MenuItem> allItems,
    String query, {
    MenuFilterCallback? filterCallback,
  }) {
    if (query.isEmpty) {
      value = value.copyWith(filteredItems: allItems, clearHighlight: true);
      if (_overlay != null && _overlay!.mounted) {
        _overlay!.markNeedsBuild();
      }
      return;
    }

    final List<MenuItem> filtered;
    if (filterCallback != null) {
      filtered = filterCallback(allItems, query);
    } else {
      final q = query.toLowerCase();
      filtered = allItems
          .where((item) => item.label.toLowerCase().contains(q))
          .toList();
    }
    value = value.copyWith(filteredItems: filtered, clearHighlight: true);
    if (_overlay != null && _overlay!.mounted) {
      _overlay!.markNeedsBuild();
    }
  }

  void searchHighlight(String query, {MenuSearchCallback? searchCallback}) {
    if (query.isEmpty) {
      value = value.copyWith(clearHighlight: true);
      if (_overlay != null && _overlay!.mounted) {
        _overlay!.markNeedsBuild();
      }
      return;
    }

    int? index;
    if (searchCallback != null) {
      index = searchCallback(value.filteredItems, query);
    } else {
      final q = query.toLowerCase();
      index = value.filteredItems.indexWhere(
        (e) => e.label.toLowerCase().contains(q),
      );
      if (index == -1) index = null;
    }

    if (index != null) {
      value = value.copyWith(highlightedIndex: index);
    } else {
      value = value.copyWith(clearHighlight: true);
    }
    if (_overlay != null && _overlay!.mounted) {
      _overlay!.markNeedsBuild();
    }
  }

  void showOverlay(BuildContext context, OverlayEntry Function() builder) {
    if (_overlay != null) return;

    _focusNode?.requestFocus();

    _overlay = builder();
    Overlay.of(context).insert(_overlay!);
    value = value.copyWith(isOverlayVisible: true);
  }

  void hideOverlay() {
    if (_overlay != null) {
      try {
        _overlay?.remove();
      } catch (e) {
        // Overlay may already be removed if the widget tree was disposed
      }
      _overlay = null;
    }
    value = value.copyWith(isOverlayVisible: false);
  }

  void toggleOverlay(BuildContext context, OverlayEntry Function() builder) {
    if (_overlay != null) {
      hideOverlay();
    } else {
      showOverlay(context, builder);
    }
  }

  @override
  void dispose() {
    hideOverlay();
    super.dispose();
  }
}

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
