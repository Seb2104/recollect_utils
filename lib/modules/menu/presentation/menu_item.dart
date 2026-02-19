part of '../menu.dart';

/// A single selectable entry in a [Menu] dropdown.
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

  Widget build(BuildContext context) {
    final scope = MenuScope.of(context);
    final config = scope.itemConfig;
    final height = scope.itemHeight;

    return InkWell(
      onTap: () {
        scope.controller.selectItem(this);
      },
      child: Container(
        height: height,
        padding: config.padding,
        alignment: switch (config.alignment) {
          Aligned.left => Alignment.centerLeft,
          Aligned.center => Alignment.center,
          Aligned.right => Alignment.centerRight,
        },
        child: Word(label, color: Colours.grey),
      ),
    );
  }
}
