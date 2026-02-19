part of '../menu.dart';

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
/// Controls the look and feel of each row in the [Menu] overlay, including
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
