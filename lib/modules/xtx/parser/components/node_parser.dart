part of '../../../../recollect_utils.dart';

/// Parser for XTX nodes
///
/// Handles parsing of node sections which include type, ID, parent ID,
/// content, and metadata.
class NodeParser {
  // Prevent instantiation
  NodeParser._();

  /// Parses a node from the buffered reader
  ///
  /// Throws [XtxFormatException] if the node type is invalid.
  /// Throws [XtxCorruptedException] if the node structure is corrupted.
  static Node parse(BufferedReader reader) {
    final startPos = reader.position;

    // Parse and validate node type
    final nodeTypeByte = reader.readUint8();
    final nodeType = NodeType.fromU8(nodeTypeByte);
    if (nodeType == null) {
      throw XtxFormatException(
        message:
            'Invalid node type: 0x${nodeTypeByte.toRadixString(16).padLeft(2, '0')}',
        position: startPos,
        operation: 'parsing node type',
      );
    }

    // Parse node identifiers
    final id = reader.readInt16();
    final parentId = reader.readInt16();

    // Parse content (length-prefixed bytes)
    final contentLen = reader.readInt32();
    if (contentLen < 0) {
      throw XtxCorruptedException(
        message: 'Invalid content length: $contentLen',
        position: reader.position - 4,
        operation: 'parsing node content length',
        component: 'node',
      );
    }

    final content = reader.readBytes(contentLen);

    // Parse metadata
    final metadata = MetadataParser.parse(reader);

    return Node(
      nodeType: nodeType,
      id: id,
      parentId: parentId,
      content: content,
      metadata: metadata,
    );
  }
}
