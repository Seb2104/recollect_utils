part of '../../../../recollect_utils.dart';

/// Parser for node metadata
///
/// Handles parsing of key-value metadata pairs stored in nodes.
class MetadataParser {
  // Prevent instantiation
  MetadataParser._();

  /// Parses metadata from the buffered reader
  ///
  /// Metadata consists of a count followed by key-value pairs where:
  /// - Keys are uint8-length-prefixed UTF-8 strings
  /// - Values are int16-length-prefixed UTF-8 strings
  static Map<String, String> parse(BufferedReader reader) {
    final count = reader.readUint8();
    final metadata = <String, String>{};

    for (int i = 0; i < count; i++) {
      // Parse key
      final keyLen = reader.readUint8();
      final key = reader.readUtf8String(keyLen);

      // Parse value
      final valueLen = reader.readInt16();
      if (valueLen < 0) {
        throw XtxCorruptedException(
          message: 'Invalid metadata value length: $valueLen for key "$key"',
          position: reader.position - 2,
          operation: 'parsing metadata value length',
          component: 'metadata',
        );
      }

      final value = reader.readUtf8String(valueLen);

      metadata[key] = value;
    }

    return metadata;
  }

  /// Validates range format used in formatting metadata
  ///
  /// Valid format: "0-5,10-15,20-23"
  /// Returns true if the format is valid, false otherwise.
  static bool validateRangeFormat(String ranges) {
    if (ranges.isEmpty) return false;

    final regex = RegExp(r'^\d+-\d+(,\d+-\d+)*$');
    return regex.hasMatch(ranges);
  }

  /// Parses range format into list of range pairs
  ///
  /// Input: "0-5,10-15"
  /// Output: [(0, 5), (10, 15)]
  ///
  /// Returns null if the format is invalid.
  static List<(int, int)>? parseRanges(String ranges) {
    if (!validateRangeFormat(ranges)) {
      return null;
    }

    final result = <(int, int)>[];
    final rangeParts = ranges.split(',');

    for (final rangePart in rangeParts) {
      final parts = rangePart.split('-');
      if (parts.length != 2) return null;

      final start = int.tryParse(parts[0].trim());
      final end = int.tryParse(parts[1].trim());

      if (start == null || end == null) return null;
      if (start < 0 || end < start) return null;

      result.add((start, end));
    }

    return result;
  }
}
