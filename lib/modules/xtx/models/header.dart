part of '../../../recollect_utils.dart';

class Header {
  final int created;

  final int modified;

  final int flags;

  final String icon;

  final List<String> tags;

  const Header({
    required this.created,
    required this.modified,
    required this.flags,
    required this.icon,
    required this.tags,
  });

  factory Header.defaultHeader() {
    return Header(
      created: (Moment.now().millisecondsSinceEpoch ~/ 1000),
      modified: (Moment.now().millisecondsSinceEpoch ~/ 1000),
      flags: 0,
      icon: '',
      tags: [],
    );
  }

  Header copyWith({
    int? created,
    int? modified,
    int? flags,
    String? icon,
    List<String>? tags,
  }) {
    return Header(
      created: created ?? this.created,
      modified: modified ?? this.modified,
      flags: flags ?? this.flags,
      icon: icon ?? this.icon,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Header &&
          runtimeType == other.runtimeType &&
          created == other.created &&
          modified == other.modified &&
          flags == other.flags &&
          icon == other.icon &&
          ByteReader.listEquals(tags, other.tags);

  @override
  int get hashCode =>
      created.hashCode ^
      modified.hashCode ^
      flags.hashCode ^
      icon.hashCode ^
      tags.hashCode;

  void write(IOSink sink) {
    sink.add(magicBytes);

    sink.add(ByteReader.int64ToBytes(created));

    sink.add(ByteReader.int64ToBytes(modified));

    sink.add(ByteReader.int32ToBytes(flags));

    final iconBytes = utf8.encode(icon);
    sink.add([iconBytes.length]);
    sink.add(iconBytes);

    sink.add([tags.length]);
    for (final tag in tags) {
      final tagBytes = utf8.encode(tag);
      sink.add([tagBytes.length]);
      sink.add(tagBytes);
    }
  }
}
