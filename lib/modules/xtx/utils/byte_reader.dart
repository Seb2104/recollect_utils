part of '../../../recollect_utils.dart';

class ByteReader {
  static bool uint8ListEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static Uint8List int16ToBytes(int value) {
    return Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.little);
  }

  static Uint8List int32ToBytes(int value) {
    return Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little);
  }

  static Uint8List int64ToBytes(int value) {
    return Uint8List(8)..buffer.asByteData().setInt64(0, value, Endian.little);
  }

  static int readInt16(RandomAccessFile file) {
    final bytes = file.readSync(2);
    return ByteData.sublistView(
      Uint8List.fromList(bytes),
    ).getInt16(0, Endian.little);
  }

  static int readInt32(RandomAccessFile file) {
    final bytes = file.readSync(4);
    return ByteData.sublistView(
      Uint8List.fromList(bytes),
    ).getInt32(0, Endian.little);
  }

  static int readInt64(RandomAccessFile file) {
    final bytes = file.readSync(8);
    return ByteData.sublistView(
      Uint8List.fromList(bytes),
    ).getInt64(0, Endian.little);
  }

  static bool listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
