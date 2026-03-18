part of '../../../../recollect_utils.dart';

/// Parser for XTX file headers
///
/// Handles parsing of the header section which includes magic bytes,
/// timestamps, flags, icon, and tags.
class HeaderParser {
  // Prevent instantiation
  HeaderParser._();

  /// Parses a header from the buffered reader
  ///
  /// Throws [XtxFormatException] if the magic bytes are invalid.
  static Header parse(BufferedReader reader) {
    final startPos = reader.position;

    // Parse and validate magic bytes
    final magic = reader.readBytes(4);
    if (!_validateMagic(magic)) {
      throw XtxFormatException(
        message:
            'Invalid magic bytes: expected [88, 84, 88, 0], got [${magic.join(', ')}]',
        position: startPos,
        operation: 'parsing header magic bytes',
      );
    }

    // Parse timestamps
    final created = reader.readInt64();
    final modified = reader.readInt64();

    // Parse flags
    final flags = reader.readInt32();

    // Parse icon (length-prefixed UTF-8 string)
    final iconLen = reader.readUint8();
    final icon = reader.readUtf8String(iconLen);

    // Parse tags (count, then length-prefixed strings)
    final tagCount = reader.readUint8();
    final tags = <String>[];
    for (int i = 0; i < tagCount; i++) {
      final tagLen = reader.readUint8();
      tags.add(reader.readUtf8String(tagLen));
    }

    return Header(
      created: created,
      modified: modified,
      flags: flags,
      icon: icon,
      tags: tags,
    );
  }

  /// Validates magic bytes
  static bool _validateMagic(Uint8List magic) {
    if (magic.length != 4) return false;
    return magic[0] == 88 && magic[1] == 84 && magic[2] == 88 && magic[3] == 0;
  }
}
