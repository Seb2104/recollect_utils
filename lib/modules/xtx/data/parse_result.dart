part of '../../../recollect_utils.dart';

/// Result of parsing with metrics enabled
///
/// Contains both the parsed file and performance metrics.
class ParseResult {
  /// The parsed XTX file
  final xtxFile file;

  /// Performance metrics from parsing
  final ParserMetricsReport metrics;

  const ParseResult({required this.file, required this.metrics});
}
