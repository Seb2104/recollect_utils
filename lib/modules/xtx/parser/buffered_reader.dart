part of '../../../recollect_utils.dart';


/// Efficient buffered reader for binary file parsing
///
/// This class provides efficient byte-level reading from a [RandomAccessFile]
/// by using an internal buffer to reduce syscalls. It tracks the absolute
/// file position for detailed error reporting.
class BufferedReader {
  /// Default buffer size (8KB)
  static const int defaultBufferSize = 8192;

  final RandomAccessFile _file;
  final Uint8List _buffer;

  /// Current offset within the buffer
  int _bufferOffset = 0;

  /// Number of valid bytes in the buffer
  int _bufferLength = 0;

  /// Absolute position in the file
  int _absolutePosition = 0;

  /// Creates a buffered reader for the given file
  ///
  /// [file] The file to read from
  /// [bufferSize] Size of the internal buffer (default: 8KB)
  BufferedReader(this._file, {int bufferSize = defaultBufferSize})
    : _buffer = Uint8List(bufferSize) {
    assert(bufferSize > 0, 'Buffer size must be positive');
  }

  /// Current absolute position in the file
  int get position => _absolutePosition;

  /// Ensures at least [count] bytes are available in the buffer
  ///
  /// Refills the buffer from the file if necessary
  void _ensureBytes(int count) {
    if (_bufferOffset + count > _bufferLength) {
      _fillBuffer();
    }

    // Verify we have enough bytes
    if (_bufferOffset + count > _bufferLength) {
      throw StateError(
        'Unexpected end of file at position $_absolutePosition: '
        'requested $count bytes, but only ${_bufferLength - _bufferOffset} available',
      );
    }
  }

  /// Fills the buffer from the file
  void _fillBuffer() {
    final bytesRead = _file.readIntoSync(_buffer);
    _bufferLength = bytesRead;
    _bufferOffset = 0;
  }

  /// Reads a single unsigned 8-bit integer
  int readUint8() {
    _ensureBytes(1);
    final value = _buffer[_bufferOffset];
    _bufferOffset += 1;
    _absolutePosition += 1;
    return value;
  }

  /// Reads a signed 16-bit integer (little-endian)
  int readInt16() {
    _ensureBytes(2);

    // Read directly from buffer for efficiency
    final value = _buffer[_bufferOffset] | (_buffer[_bufferOffset + 1] << 8);

    _bufferOffset += 2;
    _absolutePosition += 2;

    // Convert to signed
    return value > 32767 ? value - 65536 : value;
  }

  /// Reads a signed 32-bit integer (little-endian)
  int readInt32() {
    _ensureBytes(4);

    final value =
        _buffer[_bufferOffset] |
        (_buffer[_bufferOffset + 1] << 8) |
        (_buffer[_bufferOffset + 2] << 16) |
        (_buffer[_bufferOffset + 3] << 24);

    _bufferOffset += 4;
    _absolutePosition += 4;

    // Convert to signed 32-bit
    return value > 2147483647 ? value - 4294967296 : value;
  }

  /// Reads a signed 64-bit integer (little-endian)
  int readInt64() {
    _ensureBytes(8);

    // Read as two 32-bit chunks for correct sign handling
    final low =
        _buffer[_bufferOffset] |
        (_buffer[_bufferOffset + 1] << 8) |
        (_buffer[_bufferOffset + 2] << 16) |
        (_buffer[_bufferOffset + 3] << 24);

    final high =
        _buffer[_bufferOffset + 4] |
        (_buffer[_bufferOffset + 5] << 8) |
        (_buffer[_bufferOffset + 6] << 16) |
        (_buffer[_bufferOffset + 7] << 24);

    _bufferOffset += 8;
    _absolutePosition += 8;

    // Combine into 64-bit value
    final value = (high << 32) | low;
    return value;
  }

  /// Reads [length] bytes and returns them as a new [Uint8List]
  ///
  /// For large reads that exceed the buffer size, this may require
  /// multiple buffer fills.
  Uint8List readBytes(int length) {
    if (length == 0) {
      return Uint8List(0);
    }

    final result = Uint8List(length);
    int resultOffset = 0;

    while (resultOffset < length) {
      // Fill buffer if needed
      if (_bufferOffset >= _bufferLength) {
        _fillBuffer();
      }

      // Copy available bytes from buffer
      final available = _bufferLength - _bufferOffset;
      final needed = length - resultOffset;
      final toCopy = available < needed ? available : needed;

      result.setRange(
        resultOffset,
        resultOffset + toCopy,
        _buffer,
        _bufferOffset,
      );

      _bufferOffset += toCopy;
      _absolutePosition += toCopy;
      resultOffset += toCopy;
    }

    return result;
  }

  /// Reads a UTF-8 encoded string of [length] bytes
  String readUtf8String(int length) {
    final bytes = readBytes(length);
    return utf8.decode(bytes);
  }

  /// Skips [count] bytes in the file
  ///
  /// This is more efficient than reading and discarding bytes
  void skip(int count) {
    if (count <= 0) {
      return;
    }

    // Try to skip within buffer first
    if (_bufferOffset + count <= _bufferLength) {
      _bufferOffset += count;
      _absolutePosition += count;
      return;
    }

    // Skip remaining bytes in buffer
    final remainingInBuffer = _bufferLength - _bufferOffset;
    final toSkipInFile = count - remainingInBuffer;

    _bufferOffset = _bufferLength;
    _absolutePosition += remainingInBuffer;

    // Seek in file for large skips
    if (toSkipInFile > 0) {
      _file.setPositionSync(_file.positionSync() + toSkipInFile);
      _absolutePosition += toSkipInFile;

      // Invalidate buffer
      _bufferOffset = 0;
      _bufferLength = 0;
    }
  }

  /// Seeks to an absolute position in the file
  ///
  /// This invalidates the buffer.
  void seek(int position) {
    if (position < 0) {
      throw ArgumentError.value(position, 'position', 'Must be non-negative');
    }

    _file.setPositionSync(position);
    _absolutePosition = position;

    // Invalidate buffer
    _bufferOffset = 0;
    _bufferLength = 0;
  }
}
