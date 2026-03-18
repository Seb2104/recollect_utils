part of "../../recollect_utils.dart";

class xtxFile {
  final Header header;
  final List<Node> nodes;
  final List<Asset> assets;
  final String path;

  const xtxFile.create({
    required this.header,
    this.nodes = const [],
    this.assets = const [],
    this.path = r'C:\Users\Public',
  });

  const xtxFile({
    required this.header,
    this.nodes = const [],
    this.assets = const [],
    required this.path,
  });

  xtxFile.at({required String path})
    : header = Header.defaultHeader(),
      nodes = [],
      assets = [],
      path = path;

  String get name => basenameWithoutExtension(path);

  String get extension => basename(path).split('.').last;

  xtxFile copyWith({
    Header? header,
    List<Node>? nodes,
    List<Asset>? assets,
    String? path,
  }) {
    return xtxFile(
      header: header ?? this.header,
      nodes: nodes ?? List.from(this.nodes),
      assets: assets ?? List.from(this.assets),
      path: path ?? this.path,
    );
  }

  Future<void> write() async {
    final tempFile = File('$path.tmp');

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final updatedHeader = header.copyWith(modified: now);

    final sink = tempFile.openWrite();

    try {
      updatedHeader.write(sink);

      sink.add(ByteReader.int16ToBytes(nodes.length));

      sink.add(ByteReader.int16ToBytes(assets.length));

      for (final node in nodes) {
        node.write(sink);
      }

      for (final asset in assets) {
        asset.write(sink);
      }

      await sink.flush();
      await sink.close();

      await tempFile.rename(path);
    } catch (e) {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      rethrow;
    }
  }

  static xtxFile read(String path) {
    final file = File(path);
    final raf = file.openSync(mode: FileMode.read);

    try {
      final parser = XtxParser(raf);
      final result = parser.parse();

      return xtxFile(
        header: result.header,
        nodes: result.nodes,
        assets: result.assets,
        path: path,
      );
    } finally {
      raf.closeSync();
    }
  }

  /// Reads an XTX file with performance metrics
  ///
  /// Returns a [ParseResult] containing the parsed file and metrics report.
  /// This is useful for performance analysis and optimization.
  ///
  /// Example:
  /// ```dart
  /// final result = xtxFile.readWithMetrics('document.xtx');
  /// print(result.metrics);
  /// final file = result.file;
  /// ```
  static ParseResult readWithMetrics(String path) {
    final file = File(path);
    final raf = file.openSync(mode: FileMode.read);

    try {
      final parser = XtxParser(raf, enableMetrics: true);
      final result = parser.parse();

      return ParseResult(
        file: xtxFile(
          header: result.header,
          nodes: result.nodes,
          assets: result.assets,
          path: path,
        ),
        metrics: parser.metrics.generateReport(),
      );
    } finally {
      raf.closeSync();
    }
  }

  /// Opens an XTX file for streaming/lazy loading
  ///
  /// Returns a [XtxFileHandle] that allows on-demand loading of nodes and
  /// assets. This is useful for large files where you don't want to load
  /// everything into memory at once.
  ///
  /// The caller is responsible for closing the handle when done.
  ///
  /// Example:
  /// ```dart
  /// final handle = await xtxFile.readStreaming('large.xtx');
  /// try {
  ///   final node = await handle.getNode(5);
  ///   await for (final asset in handle.assets) {
  ///     // Process asset...
  ///   }
  /// } finally {
  ///   await handle.close();
  /// }
  /// ```
  static Future<XtxFileHandle> readStreaming(String path) {
    return StreamingParser.open(path);
  }

  xtxFile setIcon({required String icon}) {
    return copyWith(header: header.copyWith(icon: icon));
  }

  xtxFile appendTag({required String tag}) {
    final updatedTags = List<String>.from(header.tags)..add(tag);
    return copyWith(header: header.copyWith(tags: updatedTags));
  }

  xtxFile appendNode({required Node node}) {
    final updatedNodes = List<Node>.from(nodes)..add(node);
    return copyWith(nodes: updatedNodes);
  }

  xtxFile appendAsset({required Asset asset}) {
    final updatedAssets = List<Asset>.from(assets)..add(asset);
    return copyWith(assets: updatedAssets);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is xtxFile &&
          runtimeType == other.runtimeType &&
          header == other.header &&
          ByteReader.listEquals(nodes, other.nodes) &&
          ByteReader.listEquals(assets, other.assets);

  @override
  int get hashCode => header.hashCode ^ nodes.hashCode ^ assets.hashCode;
}
