part of '../../../recollect_utils.dart';

class Node {
  final NodeType nodeType;

  final int id;

  final int parentId;

  final Uint8List content;

  final Map<String, String> metadata;

  const Node({
    required this.nodeType,
    required this.id,
    required this.parentId,
    required this.content,
    required this.metadata,
  });

  factory Node.create(NodeType nodeType, int id) {
    return Node(
      nodeType: nodeType,
      id: id,
      parentId: 0xFFFF,
      content: Uint8List(0),
      metadata: {},
    );
  }

  Node copyWith({
    NodeType? nodeType,
    int? id,
    int? parentId,
    Uint8List? content,
    Map<String, String>? metadata,
  }) {
    return Node(
      nodeType: nodeType ?? this.nodeType,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node &&
          runtimeType == other.runtimeType &&
          nodeType == other.nodeType &&
          id == other.id &&
          parentId == other.parentId &&
          ByteReader.uint8ListEquals(content, other.content) &&
          ByteReader.mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      nodeType.hashCode ^
      id.hashCode ^
      parentId.hashCode ^
      content.hashCode ^
      metadata.hashCode;

  void write(IOSink sink) {
    sink.add([nodeType.value]);

    sink.add(ByteReader.int16ToBytes(id));

    sink.add(ByteReader.int16ToBytes(parentId));

    sink.add(ByteReader.int32ToBytes(content.length));

    sink.add(content);

    sink.add([metadata.length]);

    for (final entry in metadata.entries) {
      final keyBytes = utf8.encode(entry.key);
      final valueBytes = utf8.encode(entry.value);

      sink.add([keyBytes.length]);
      sink.add(keyBytes);

      sink.add(ByteReader.int16ToBytes(valueBytes.length));
      sink.add(valueBytes);
    }
  }

  Node nodeSetContent({required Uint8List content}) {
    return copyWith(content: content);
  }

  Node nodeSetParent({required int parentId}) {
    return copyWith(parentId: parentId);
  }

  Node nodeAddMetadata({required String key, required String value}) {
    final updatedMetadata = Map<String, String>.from(metadata);
    updatedMetadata[key] = value;
    return copyWith(metadata: updatedMetadata);
  }
}
