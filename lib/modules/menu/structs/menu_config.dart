part of '../menu.dart';

/// Behavioural and visual configuration for a [Menu] widget.
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
