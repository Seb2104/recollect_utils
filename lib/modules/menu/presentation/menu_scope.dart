part of '../menu.dart';

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
