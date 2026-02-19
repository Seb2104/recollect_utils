part of '../../recollect_utils.dart';

/// Visual styling configuration for the [ColourPicker] widget.
///
/// Use this to customise the picker's outer container without touching its
/// internal layout. It controls padding, margin, and the background decoration —
/// the three things you'll most often want to tweak when embedding a picker
/// into your own UI.
///
/// ## Example
///
/// ```dart
/// ColourPicker(
///   style: PickerStyle(
///     padding: EdgeInsets.all(16),
///     margin: EdgeInsets.symmetric(horizontal: 24),
///     decoration: BoxDecoration(
///       color: Colors.grey.shade900,
///       borderRadius: BorderRadius.circular(12),
///     ),
///   ),
/// )
/// ```
class PickerStyle {
  /// The internal padding between the picker's decoration edge and its content.
  ///
  /// Defaults to `EdgeInsets.all(20)`.
  final EdgeInsets padding;

  /// The external margin around the picker container.
  ///
  /// Defaults to `EdgeInsets.all(20)`.
  final EdgeInsets margin;

  /// The [BoxDecoration] applied to the picker's outer container.
  ///
  /// By default, this uses a light background with a 20px corner radius,
  /// matching the Collect design language.
  final BoxDecoration decoration;

  /// Creates a [PickerStyle] with the given [padding], [margin], and
  /// [decoration].
  ///
  /// All parameters are optional and fall back to sensible defaults.
  const PickerStyle({
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(20),
    this.decoration = const BoxDecoration(
      color: AppTheme.lightBackground,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  });
}
