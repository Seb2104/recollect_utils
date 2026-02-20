part of '../../menus.dart';

/// A single selectable entry in a [SimpleMenu] dropdown.
///
/// Each item carries a human-readable [label] (displayed in the dropdown)
/// and an arbitrary [value] string (used for programmatic identification).
///
/// Items build themselves via the [build] method, which reads the nearest
/// [MenuScope] to access the active [MenuController] and [ItemConfig].
/// Tapping the item calls [MenuController.selectItem], closing the dropdown
/// and updating the trigger bar.
class MenuItem {
  final String label;
  final dynamic value;

  const MenuItem({required this.label, required this.value});
}
