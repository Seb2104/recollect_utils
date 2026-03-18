part of '../../../recollect_utils.dart';


class Asset {
  final int id;

  final Uint8List hash;

  final CompressionType compression;

  final String filename;

  final String mimeType;

  final Uint8List data;

  final int originalLength;

  const Asset({
    required this.id,
    required this.hash,
    required this.compression,
    required this.filename,
    required this.mimeType,
    required this.data,
    required this.originalLength,
  });

  Asset copyWith({
    int? id,
    Uint8List? hash,
    CompressionType? compression,
    String? filename,
    String? mimeType,
    Uint8List? data,
    int? originalLength,
  }) {
    return Asset(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      compression: compression ?? this.compression,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      data: data ?? this.data,
      originalLength: originalLength ?? this.originalLength,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Asset &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ByteReader.uint8ListEquals(hash, other.hash) &&
          compression == other.compression &&
          filename == other.filename &&
          mimeType == other.mimeType &&
          ByteReader.uint8ListEquals(data, other.data) &&
          originalLength == other.originalLength;

  @override
  int get hashCode =>
      id.hashCode ^
      hash.hashCode ^
      compression.hashCode ^
      filename.hashCode ^
      mimeType.hashCode ^
      data.hashCode ^
      originalLength.hashCode;

  void write(IOSink sink) {
    sink.add(ByteReader.int16ToBytes(id));

    sink.add(hash);

    sink.add([compression.value]);

    final filenameBytes = utf8.encode(filename);
    sink.add([filenameBytes.length]);
    sink.add(filenameBytes);

    final mimeBytes = utf8.encode(mimeType);
    sink.add([mimeBytes.length]);
    sink.add(mimeBytes);

    sink.add(ByteReader.int32ToBytes(data.length));

    sink.add(ByteReader.int32ToBytes(originalLength));

    sink.add(data);
  }
}
