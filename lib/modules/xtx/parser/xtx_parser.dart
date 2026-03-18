part of '../../../recollect_utils.dart';

/// Result of parsing an XTX file
///
/// Contains the parsed data structures (header, nodes, assets)
class _ParseResult {
  final Header header;
  final List<Node> nodes;
  final List<Asset> assets;

  const _ParseResult({
    required this.header,
    required this.nodes,
    required this.assets,
  });
}

/// Main parser for XTX files
///
/// Coordinates the parsing of XTX file components using a buffered reader
/// for efficiency. Provides detailed error context and optional performance
/// metrics.
///
/// Example usage:
/// ```dart
/// final file = File('document.xtx').openSync();
/// try {
///   final parser = XtxParser(file, enableMetrics: true);
///   final xtxFile = parser.parse();
///   print(parser.metrics.generateReport());
/// } finally {
///   file.closeSync();
/// }
/// ```
class XtxParser {
  final BufferedReader _reader;

  /// Performance metrics (only tracked if enabled)
  final ParserMetrics metrics;

  /// Creates a new parser for the given file
  ///
  /// [file] The file to parse (must be opened in read mode)
  /// [enableMetrics] Whether to track performance metrics (default: false)
  /// [bufferSize] Size of the read buffer in bytes (default: 8192)
  XtxParser(
    RandomAccessFile file, {
    bool enableMetrics = false,
    int bufferSize = BufferedReader.defaultBufferSize,
  }) : _reader = BufferedReader(file, bufferSize: bufferSize),
       metrics = enableMetrics ? ParserMetrics() : ParserMetrics.disabled();

  /// Parses the entire XTX file
  ///
  /// Returns the parsed file structure with header, nodes, and assets.
  ///
  /// Throws:
  /// - [XtxFormatException] if the file format is invalid
  /// - [XtxCorruptedException] if the file appears corrupted
  /// - [XtxValidationException] if validation fails
  _ParseResult parse() {
    metrics.startTimer('total');

    try {
      // Parse header
      metrics.startTimer('header');
      final header = _parseHeader();
      metrics.stopTimer('header');

      // Parse counts
      final nodeCount = _reader.readInt16();
      final assetCount = _reader.readInt16();

      // Parse nodes
      metrics.startTimer('nodes');
      final nodes = _parseNodes(nodeCount);
      metrics.recordNodeCount(nodeCount);
      metrics.stopTimer('nodes');

      // Parse assets
      metrics.startTimer('assets');
      final assets = _parseAssets(assetCount);
      metrics.recordAssetCount(assetCount);
      metrics.stopTimer('assets');

      metrics.stopTimer('total');

      return _ParseResult(header: header, nodes: nodes, assets: assets);
    } on XtxParseException {
      // Re-throw our own exceptions as-is
      rethrow;
    } catch (e) {
      // Wrap unexpected errors with context
      throw XtxCorruptedException(
        message: 'Unexpected error during parsing: $e',
        position: _reader.position,
        operation: 'parsing file',
      );
    }
  }

  /// Parses the file header
  Header _parseHeader() {
    try {
      return HeaderParser.parse(_reader);
    } catch (e) {
      if (e is XtxParseException) {
        rethrow;
      }
      throw XtxCorruptedException(
        message: 'Failed to parse header: $e',
        position: _reader.position,
        operation: 'parsing header',
        component: 'header',
      );
    }
  }

  /// Parses all nodes
  List<Node> _parseNodes(int count) {
    if (count < 0) {
      throw XtxCorruptedException(
        message: 'Invalid node count: $count',
        position: _reader.position,
        operation: 'reading node count',
        component: 'nodes',
      );
    }

    final nodes = <Node>[];
    for (int i = 0; i < count; i++) {
      try {
        nodes.add(NodeParser.parse(_reader));
      } catch (e) {
        if (e is XtxParseException) {
          // Add context about which node failed
          throw XtxCorruptedException(
            message: 'Failed to parse node $i of $count: ${e.message}',
            position: _reader.position,
            operation: 'parsing node $i',
            component: 'node',
          );
        }
        throw XtxCorruptedException(
          message: 'Failed to parse node $i of $count: $e',
          position: _reader.position,
          operation: 'parsing node $i',
          component: 'node',
        );
      }
    }
    return nodes;
  }

  /// Parses all assets
  List<Asset> _parseAssets(int count) {
    if (count < 0) {
      throw XtxCorruptedException(
        message: 'Invalid asset count: $count',
        position: _reader.position,
        operation: 'reading asset count',
        component: 'assets',
      );
    }

    final assets = <Asset>[];
    for (int i = 0; i < count; i++) {
      try {
        assets.add(AssetParser.parse(_reader));
      } catch (e) {
        if (e is XtxParseException) {
          // Add context about which asset failed
          throw XtxCorruptedException(
            message: 'Failed to parse asset $i of $count: ${e.message}',
            position: _reader.position,
            operation: 'parsing asset $i',
            component: 'asset',
          );
        }
        throw XtxCorruptedException(
          message: 'Failed to parse asset $i of $count: $e',
          position: _reader.position,
          operation: 'parsing asset $i',
          component: 'asset',
        );
      }
    }
    return assets;
  }
}
