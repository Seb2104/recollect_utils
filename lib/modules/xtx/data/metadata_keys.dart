part of '../../../recollect_utils.dart';


/// Centralized constants for metadata keys used in XTX nodes
///
/// This class contains all the string keys used for node metadata,
/// eliminating magic strings scattered throughout the codebase.
class MetadataKeys {
  // Prevent instantiation
  MetadataKeys._();

  // Text formatting keys

  /// Bold text formatting
  static const String bold = 'bold';

  /// Italic text formatting
  static const String italic = 'italic';

  /// Underline text formatting
  static const String underline = 'underline';

  /// Strikethrough text formatting
  static const String strikethrough = 'strikethrough';

  /// Superscript text formatting
  static const String superscript = 'superscript';

  /// Subscript text formatting
  static const String subscript = 'subscript';

  /// Font size formatting
  static const String fontSize = 'fontSize';

  // Block type keys

  /// Block type metadata key
  static const String blockType = 'blockType';

  // Block type values

  /// Header level 1 block type
  static const String header1 = 'header1';

  /// Header level 2 block type
  static const String header2 = 'header2';

  /// Header level 3 block type
  static const String header3 = 'header3';

  /// Header level 4 block type
  static const String header4 = 'header4';

  /// Header level 5 block type
  static const String header5 = 'header5';

  /// Header level 6 block type
  static const String header6 = 'header6';

  /// Paragraph block type (default)
  static const String paragraph = 'paragraph';

  // Collections

  /// List of all text formatting keys
  static const List<String> formattingKeys = [
    bold,
    italic,
    underline,
    strikethrough,
    superscript,
    subscript,
  ];

  /// List of all block type values
  static const List<String> blockTypes = [
    header1,
    header2,
    header3,
    header4,
    header5,
    header6,
    paragraph,
  ];
}
