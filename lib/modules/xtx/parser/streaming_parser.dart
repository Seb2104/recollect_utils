part of '../../../recollect_utils.dart';


/// Index of node and asset locations in an XTX file
///
/// Used by [XtxFileHandle] for lazy loading of nodes and assets.
class XtxFileIndex {
  /// Parsed file header (always loaded)
  final Header header;

  /// Total number of nodes in the file
  final int nodeCount;

  /// Total number of assets in the file
  final int assetCount;

  /// Map of node index to byte offset in file
  final Map<int, int> nodeOffsets;

  /// Map of asset index to byte offset in file
  final Map<int, int> assetOffsets;

  const XtxFileIndex({
    required this.header,
    required this.nodeCount,
    required this.assetCount,
    required this.nodeOffsets,
    required this.assetOffsets,
  });
}

/// Handle to an open XTX file with lazy loading support
///
/// This class provides on-demand loading of nodes and assets, which is
/// useful for large files where you don't want to load everything into memory.
///
/// Example usage:
/// ```dart
/// final handle = await xtxFile.readStreaming('large.xtx');
/// try {
///   print(handle.header.icon);
///
///   // Load specific node
///   final node = await handle.getNode(5);
///
///   // Stream all nodes
///   await for (final node in handle.nodes) {
///     print(node.id);
///   }
/// } finally {
///   await handle.close();
/// }
/// ```
class XtxFileHandle {
  /// File index containing header and offsets
  final XtxFileIndex index;

  /// Underlying file (kept open for lazy loading)
  final RandomAccessFile _file;

  /// Path to the file
  final String path;

  XtxFileHandle({
    required this.index,
    required RandomAccessFile file,
    required this.path,
  }) : _file = file;

  /// File header (always available)
  Header get header => index.header;

  /// Number of nodes in the file
  int get nodeCount => index.nodeCount;

  /// Number of assets in the file
  int get assetCount => index.assetCount;

  /// Loads a specific node by index
  ///
  /// [nodeIndex] The zero-based index of the node (0 to nodeCount-1)
  ///
  /// Throws [ArgumentError] if the index is out of range.
  Future<Node> getNode(int nodeIndex) async {
    final offset = index.nodeOffsets[nodeIndex];
    if (offset == null) {
      throw ArgumentError.value(
        nodeIndex,
        'nodeIndex',
        'Node index out of range (0-${index.nodeCount - 1})',
      );
    }

    _file.setPositionSync(offset);
    final reader = BufferedReader(_file);
    return NodeParser.parse(reader);
  }

  /// Loads a specific asset by index
  ///
  /// [assetIndex] The zero-based index of the asset (0 to assetCount-1)
  ///
  /// Throws [ArgumentError] if the index is out of range.
  Future<Asset> getAsset(int assetIndex) async {
    final offset = index.assetOffsets[assetIndex];
    if (offset == null) {
      throw ArgumentError.value(
        assetIndex,
        'assetIndex',
        'Asset index out of range (0-${index.assetCount - 1})',
      );
    }

    _file.setPositionSync(offset);
    final reader = BufferedReader(_file);
    return AssetParser.parse(reader);
  }

  /// Streams all nodes in the file
  ///
  /// Nodes are loaded on-demand as they are consumed from the stream.
  Stream<Node> get nodes async* {
    for (int i = 0; i < index.nodeCount; i++) {
      yield await getNode(i);
    }
  }

  /// Streams all assets in the file
  ///
  /// Assets are loaded on-demand as they are consumed from the stream.
  Stream<Asset> get assets async* {
    for (int i = 0; i < index.assetCount; i++) {
      yield await getAsset(i);
    }
  }

  /// Closes the file handle
  ///
  /// The handle cannot be used after calling this method.
  Future<void> close() async {
    await _file.close();
  }
}

/// Parser for streaming/lazy loading of XTX files
///
/// This parser reads only the header and builds an index of node and asset
/// locations, allowing them to be loaded on-demand later.
class StreamingParser {
  // Prevent instantiation
  StreamingParser._();

  /// Opens an XTX file for streaming/lazy loading
  ///
  /// [path] Path to the XTX file
  ///
  /// Returns a [XtxFileHandle] that can be used to load nodes and assets
  /// on-demand. The caller is responsible for closing the handle when done.
  ///
  /// Throws parsing exceptions if the file format is invalid.
  static Future<XtxFileHandle> open(String path) async {
    final file = File(path);
    final raf = file.openSync(mode: FileMode.read);

    try {
      final reader = BufferedReader(raf);

      // Parse header immediately
      final header = HeaderParser.parse(reader);

      // Read counts
      final nodeCount = reader.readInt16();
      final assetCount = reader.readInt16();

      if (nodeCount < 0 || assetCount < 0) {
        throw XtxCorruptedException(
          message: 'Invalid counts: nodes=$nodeCount, assets=$assetCount',
          position: reader.position,
          operation: 'reading counts',
        );
      }

      // Build node index by skipping through nodes
      final nodeOffsets = <int, int>{};
      for (int i = 0; i < nodeCount; i++) {
        nodeOffsets[i] = reader.position;
        _skipNode(reader);
      }

      // Build asset index
      final assetOffsets = <int, int>{};
      for (int i = 0; i < assetCount; i++) {
        assetOffsets[i] = reader.position;
        _skipAsset(reader);
      }

      final index = XtxFileIndex(
        header: header,
        nodeCount: nodeCount,
        assetCount: assetCount,
        nodeOffsets: nodeOffsets,
        assetOffsets: assetOffsets,
      );

      return XtxFileHandle(index: index, file: raf, path: path);
    } catch (e) {
      // Close file on error
      try {
        raf.closeSync();
      } catch (_) {}
      rethrow;
    }
  }

  /// Skips over a node without parsing its contents
  ///
  /// This is more efficient than parsing when we only need to know the offset.
  static void _skipNode(BufferedReader reader) {
    reader.readUint8(); // type
    reader.readInt16(); // id
    reader.readInt16(); // parentId

    final contentLen = reader.readInt32();
    reader.skip(contentLen); // content

    // Skip metadata
    final metadataCount = reader.readUint8();
    for (int i = 0; i < metadataCount; i++) {
      final keyLen = reader.readUint8();
      reader.skip(keyLen);

      final valueLen = reader.readInt16();
      reader.skip(valueLen);
    }
  }

  /// Skips over an asset without parsing its contents
  ///
  /// This is more efficient than parsing when we only need to know the offset.
  static void _skipAsset(BufferedReader reader) {
    reader.readInt16(); // id
    reader.skip(32); // hash
    reader.readUint8(); // compression

    final filenameLen = reader.readUint8();
    reader.skip(filenameLen);

    final mimeLen = reader.readUint8();
    reader.skip(mimeLen);

    final compressedLen = reader.readInt32();
    reader.readInt32(); // originalLen
    reader.skip(compressedLen); // data
  }
}
