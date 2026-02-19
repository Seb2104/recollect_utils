part of '../../recollect_utils.dart';

/// Extensions on nullable [Iterable] for safe access, indexed iteration,
/// and aggregate calculations.
///
/// All methods are null-safe — if the iterable is `null`, you get sensible
/// defaults (empty list, zero sum, etc.) instead of a crash.
///
/// ```dart
/// List<int>? scores;
/// scores.validate();                  // []
/// [1, 3, 7].sumBy((n) => n);         // 11
/// [10, 20, 30].averageBy((n) => n);  // 20.0
/// ```
extension ListExtensions<T> on Iterable<T>? {
  /// Returns this iterable as a [List], or an empty list if `null`.
  ///
  /// This is your go-to null-safety net for list parameters. Note: this
  /// creates a new list each time, so don't use it to "clear" an existing one.
  List<T> validate() {
    if (this == null) {
      return [];
    } else {
      return this!.toList();
    }
  }

  /// Like [forEach], but the callback also receives the current [index].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].forEachIndexed((element, index) {
  ///   print('$index: $element'); // 0: a, 1: b, 2: c
  /// });
  /// ```
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (var element in this!) {
      action(element!, index++);
    }
  }

  /// Example:
  /// ```dart
  /// [1, 3, 7].sumBy((n) => n);                 // 11
  /// ['hello', 'world'].sumBy((s) => s.length); // 10
  /// ```
  int sumBy(int Function(T) selector) {
    return validate().map(selector).fold(0, (prev, curr) => prev + curr);
  }

  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) {
    return validate().map(selector).fold(0.0, (prev, curr) => prev + curr);
  }

  /// Example:
  /// ```dart
  /// [1, 2, 3].averageBy((n) => n);               // 2.0
  /// ['cat', 'horse'].averageBy((s) => s.length); // 4.0
  /// ```
  double? averageBy(num Function(T) selector) {
    if (validate().isEmpty) {
      return null;
    }

    return sumByDouble(selector) / this!.length;
  }
}
