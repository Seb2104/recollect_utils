part of '../../recollect_utils.dart';

/// Defines alignment and sizing options for dropdown menus.
///
/// [AlignType] is used by menu widgets like [SuggestionField] and [MenuDropDown]
/// to control how the dropdown menu is positioned and sized relative to its
/// anchor widget.
///
/// ## Values
///
/// - `left` - Dropdown aligns to the left edge of the anchor
/// - `center` - Dropdown is centered below the anchor
/// - `right` - Dropdown aligns to the right edge of the anchor
/// - `fill` - Dropdown fills the entire width of the anchor
///
/// ## Example Usage
///
/// ```dart
/// SuggestionField(
///   items: ['Option 1', 'Option 2'],
///   alignDropdown: AlignType.fill, // Dropdown fills full width
///   onSelected: (value) {},
/// )
/// ```
///
/// ## Visual Representation
///
/// ```
/// AlignType.left:
/// ┌────────────┐
/// │  Anchor    │
/// └────────────┘
/// ┌──────┐
/// │ Menu │
/// └──────┘
///
/// AlignType.center:
/// ┌────────────┐
/// │  Anchor    │
/// └────────────┘
///    ┌──────┐
///    │ Menu │
///    └──────┘
///
/// AlignType.right:
/// ┌────────────┐
/// │  Anchor    │
/// └────────────┘
///       ┌──────┐
///       │ Menu │
///       └──────┘
///
/// AlignType.fill:
/// ┌────────────┐
/// │  Anchor    │
/// └────────────┘
/// ┌────────────┐
/// │    Menu    │
/// └────────────┘
/// ```
///
/// ## See Also
///
/// - [SuggestionField] - Uses `alignDropdown` parameter
/// - [MenuDropDown] - Internal component that implements alignment
enum AlignType {
  left,
  center,
  right,
  fill,
}