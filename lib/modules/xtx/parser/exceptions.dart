part of '../../../recollect_utils.dart';


/// Base exception for all XTX parsing errors
///
/// Includes context information about where the error occurred
/// for easier debugging and error reporting.
abstract class XtxParseException implements Exception {
  /// Human-readable error message
  final String message;

  /// Absolute byte position in the file where the error occurred
  final int position;

  /// Description of what operation was being performed
  final String operation;

  const XtxParseException({
    required this.message,
    required this.position,
    required this.operation,
  });

  /// Detailed error message with position and context
  String get detailedMessage =>
      'Parse error at byte $position while $operation: $message';

  @override
  String toString() => detailedMessage;
}

/// Exception thrown when the file format is invalid
///
/// Examples:
/// - Invalid magic bytes
/// - Invalid node type byte
/// - Invalid compression type
class XtxFormatException extends XtxParseException {
  const XtxFormatException({
    required super.message,
    required super.position,
    required super.operation,
  });
}

/// Exception thrown when validation fails
///
/// Examples:
/// - Created timestamp after modified timestamp
/// - Invalid metadata format
/// - Out-of-range values
class XtxValidationException extends XtxParseException {
  /// The field that failed validation
  final String? field;

  /// The invalid value
  final Object? value;

  const XtxValidationException({
    required super.message,
    required super.position,
    required super.operation,
    this.field,
    this.value,
  });

  @override
  String get detailedMessage {
    final baseMessage = super.detailedMessage;
    if (field != null && value != null) {
      return '$baseMessage (field: $field, value: $value)';
    } else if (field != null) {
      return '$baseMessage (field: $field)';
    }
    return baseMessage;
  }
}

/// Exception thrown when the file appears corrupted
///
/// Examples:
/// - Unexpected end of file
/// - Invalid data structure
/// - Failed to parse component
class XtxCorruptedException extends XtxParseException {
  /// The component that appears corrupted
  final String? component;

  const XtxCorruptedException({
    required super.message,
    required super.position,
    required super.operation,
    this.component,
  });

  @override
  String get detailedMessage {
    final baseMessage = super.detailedMessage;
    if (component != null) {
      return '$baseMessage (component: $component)';
    }
    return baseMessage;
  }
}

/// Exception thrown when the file version is not supported
///
/// This allows for future format versioning
class XtxVersionException extends XtxParseException {
  /// The version found in the file
  final int fileVersion;

  /// The version supported by this parser
  final int supportedVersion;

  const XtxVersionException({
    required this.fileVersion,
    required this.supportedVersion,
    required super.position,
    required super.operation,
  }) : super(
         message:
             'Unsupported file version $fileVersion (supported: $supportedVersion)',
       );
}
