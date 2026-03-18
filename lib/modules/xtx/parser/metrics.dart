part of '../../../recollect_utils.dart';


/// Tracks performance metrics during parsing
///
/// This class records timing information, byte counts, and memory usage
/// to help identify performance bottlenecks.
class ParserMetrics {
  final bool _enabled;
  final Map<String, Stopwatch> _timers = {};
  final Map<String, Duration> _timings = {};
  int _bytesRead = 0;
  int _peakMemoryUsage = 0;
  int _nodeCount = 0;
  int _assetCount = 0;

  /// Creates a new metrics tracker
  ///
  /// [enabled] Whether metrics collection is enabled (default: true)
  ParserMetrics({bool enabled = true}) : _enabled = enabled;

  /// Creates a disabled metrics tracker (no overhead)
  ParserMetrics.disabled() : _enabled = false;

  /// Whether metrics collection is enabled
  bool get enabled => _enabled;

  /// Starts timing an operation
  ///
  /// Call [stopTimer] with the same operation name to complete the measurement.
  void startTimer(String operation) {
    if (!_enabled) return;

    final timer = Stopwatch()..start();
    _timers[operation] = timer;
  }

  /// Stops timing an operation and records the elapsed time
  void stopTimer(String operation) {
    if (!_enabled) return;

    final timer = _timers[operation];
    if (timer == null) {
      return; // Timer wasn't started or already stopped
    }

    timer.stop();
    _timings[operation] = timer.elapsed;
    _timers.remove(operation);
  }

  /// Gets the recorded time for an operation
  ///
  /// Returns null if the operation wasn't timed or hasn't completed yet.
  Duration? getTime(String operation) {
    if (!_enabled) return null;
    return _timings[operation];
  }

  /// Records bytes read from the file
  void recordBytesRead(int bytes) {
    if (!_enabled) return;
    _bytesRead += bytes;
  }

  /// Records memory usage in bytes
  void recordMemoryUsage(int bytes) {
    if (!_enabled) return;
    if (bytes > _peakMemoryUsage) {
      _peakMemoryUsage = bytes;
    }
  }

  /// Records the number of nodes parsed
  void recordNodeCount(int count) {
    if (!_enabled) return;
    _nodeCount = count;
  }

  /// Records the number of assets parsed
  void recordAssetCount(int count) {
    if (!_enabled) return;
    _assetCount = count;
  }

  /// Generates a comprehensive metrics report
  ParserMetricsReport generateReport() {
    if (!_enabled) {
      return ParserMetricsReport.empty();
    }

    return ParserMetricsReport(
      totalTime: _timings['total'] ?? Duration.zero,
      headerParseTime: _timings['header'] ?? Duration.zero,
      nodesParseTime: _timings['nodes'] ?? Duration.zero,
      assetsParseTime: _timings['assets'] ?? Duration.zero,
      validationTime: _timings['validation'] ?? Duration.zero,
      bytesRead: _bytesRead,
      peakMemoryBytes: _peakMemoryUsage,
      nodeCount: _nodeCount,
      assetCount: _assetCount,
    );
  }
}

/// Comprehensive report of parsing performance metrics
class ParserMetricsReport {
  /// Total parsing time
  final Duration totalTime;

  /// Time spent parsing the header
  final Duration headerParseTime;

  /// Time spent parsing nodes
  final Duration nodesParseTime;

  /// Time spent parsing assets
  final Duration assetsParseTime;

  /// Time spent on validation
  final Duration validationTime;

  /// Total bytes read from file
  final int bytesRead;

  /// Peak memory usage in bytes
  final int peakMemoryBytes;

  /// Number of nodes parsed
  final int nodeCount;

  /// Number of assets parsed
  final int assetCount;

  const ParserMetricsReport({
    required this.totalTime,
    required this.headerParseTime,
    required this.nodesParseTime,
    required this.assetsParseTime,
    required this.validationTime,
    required this.bytesRead,
    required this.peakMemoryBytes,
    required this.nodeCount,
    required this.assetCount,
  });

  /// Creates an empty report (for disabled metrics)
  const ParserMetricsReport.empty()
    : totalTime = Duration.zero,
      headerParseTime = Duration.zero,
      nodesParseTime = Duration.zero,
      assetsParseTime = Duration.zero,
      validationTime = Duration.zero,
      bytesRead = 0,
      peakMemoryBytes = 0,
      nodeCount = 0,
      assetCount = 0;

  @override
  String toString() {
    if (totalTime == Duration.zero) {
      return 'Parsing Metrics: (disabled)';
    }

    return '''
Parsing Metrics:
  Total Time: ${totalTime.inMilliseconds}ms
  Header: ${headerParseTime.inMilliseconds}ms
  Nodes: ${nodesParseTime.inMilliseconds}ms ($nodeCount nodes)
  Assets: ${assetsParseTime.inMilliseconds}ms ($assetCount assets)
  Validation: ${validationTime.inMilliseconds}ms
  Bytes Read: $bytesRead bytes
  Peak Memory: ${(peakMemoryBytes / 1024 / 1024).toStringAsFixed(2)} MB''';
  }
}
