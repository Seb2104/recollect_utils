part of '../../../recollect_utils.dart';

const List<int> magicBytes = [88, 84, 88, 0];

enum Attributions {
  header1,
  header2,
  header3,
  header4,
  header5,
  header6,
  paragraph,
  blockquote,
  bold,
  italics,
  underline,
  strikethrough,
  code,
  superscript,
  subscript,
}

enum TextAlignmentType { left, center, right, justify }

enum NodeType {
  text(0x00),
  code(0x01),
  table(0x02),
  reference(0x03),
  heading(0x04),
  list(0x05),
  custom(0xFF);

  final int value;

  const NodeType(this.value);

  static NodeType? fromU8(int value) {
    switch (value) {
      case 0x00:
        return NodeType.text;
      case 0x01:
        return NodeType.code;
      case 0x02:
        return NodeType.table;
      case 0x03:
        return NodeType.reference;
      case 0x04:
        return NodeType.heading;
      case 0x05:
        return NodeType.list;
      case 0xFF:
        return NodeType.custom;
      default:
        return null;
    }
  }

  Node createNode({required NodeType nodeType, required int id}) {
    return Node.create(nodeType, id);
  }
}

enum CompressionType {
  none(0x00),
  deflate(0x01),
  zstandard(0x03),
  lz4(0x02),
  custom(0xFF);

  final int value;

  const CompressionType(this.value);

  static CompressionType? fromU8(int value) {
    switch (value) {
      case 0x00:
        return CompressionType.none;
      case 0x01:
        return CompressionType.deflate;
      case 0x02:
        return CompressionType.lz4;
      case 0x03:
        return CompressionType.zstandard;
      case 0xFF:
        return CompressionType.custom;
      default:
        return null;
    }
  }
}
