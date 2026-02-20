part of '../../recollect_utils.dart';

/// Custom icon data bundled with the Collect package.
///
/// These icons are loaded from the `CollectIcons` font family and cover
/// common table-editing and colour-formatting actions. Use them just like
/// you'd use any [Icons] constant:
///
/// ```dart
/// Icon(CollectIcons.add_column_left)
/// Icon(CollectIcons.text_colour, color: Colors.red)
/// ```
///
/// ## Available Icons
///
/// | Icon                    | Description                              |
/// |-------------------------|------------------------------------------|
/// | [add_column_left]       | Insert a column to the left              |
/// | [add_column_right]      | Insert a column to the right             |
/// | [format_colour_fill]    | Fill/background colour bucket            |
/// | [insert_row_above]      | Insert a row above                       |
/// | [insert_row_below]      | Insert a row below                       |
/// | [remove_column_left]    | Remove the column to the left            |
/// | [remove_column_right]   | Remove the column to the right           |
/// | [remove_row_above]      | Remove the row above                     |
/// | [remove_row_below]      | Remove the row below                     |
/// | [text_colour]           | Text/foreground colour indicator         |
class CollectIcons {
  CollectIcons._();

  static const _kFontFam = 'CollectIcons';
  static const String? _kFontPkg = null;

  /// Insert a new column to the left of the current selection.
  static const IconData add_column_left = IconData(
    0xe800,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData add_column_right = IconData(
    0xe801,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData format_colour_fill = IconData(
    0xe802,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData insert_row_above = IconData(
    0xe803,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData insert_row_below = IconData(
    0xe804,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData remove_column_left = IconData(
    0xe805,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData remove_column_right = IconData(
    0xe806,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData remove_row_above = IconData(
    0xe807,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData remove_row_below = IconData(
    0xe808,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
  static const IconData text_colour = IconData(
    0xe809,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
}
