part of '../../../../recollect_utils.dart';

/// Parser for XTX assets
///
/// Handles parsing of asset sections which include ID, hash, compression type,
/// filename, MIME type, and compressed data.
class AssetParser {
  // Prevent instantiation
  AssetParser._();

  /// Parses an asset from the buffered reader
  ///
  /// Throws [XtxFormatException] if the compression type is invalid.
  /// Throws [XtxCorruptedException] if the asset structure is corrupted.
  static Asset parse(BufferedReader reader) {
    // Parse asset ID
    final id = reader.readInt16();

    // Parse hash (fixed 32 bytes)
    final hash = reader.readBytes(32);

    // Parse and validate compression type
    final compressionByte = reader.readUint8();
    final compression = CompressionType.fromU8(compressionByte);
    if (compression == null) {
      throw XtxFormatException(
        message:
            'Invalid compression type: 0x${compressionByte.toRadixString(16).padLeft(2, '0')}',
        position: reader.position - 1,
        operation: 'parsing asset compression type',
      );
    }

    // Parse filename (length-prefixed UTF-8 string)
    final filenameLen = reader.readUint8();
    final filename = reader.readUtf8String(filenameLen);

    // Parse MIME type (length-prefixed UTF-8 string)
    final mimeLen = reader.readUint8();
    final mimeType = reader.readUtf8String(mimeLen);

    // Parse data lengths
    final compressedLen = reader.readInt32();
    if (compressedLen < 0) {
      throw XtxCorruptedException(
        message: 'Invalid compressed data length: $compressedLen',
        position: reader.position - 4,
        operation: 'parsing asset compressed length',
        component: 'asset',
      );
    }

    final originalLength = reader.readInt32();
    if (originalLength < 0) {
      throw XtxCorruptedException(
        message: 'Invalid original length: $originalLength',
        position: reader.position - 4,
        operation: 'parsing asset original length',
        component: 'asset',
      );
    }

    // Parse compressed data
    final data = reader.readBytes(compressedLen);

    return Asset(
      id: id,
      hash: hash,
      compression: compression,
      filename: filename,
      mimeType: mimeType,
      data: data,
      originalLength: originalLength,
    );
  }
}
