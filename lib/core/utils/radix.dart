part of '../../recollect_utils.dart';

/// Converts integers between numeral bases — from binary (base-2) all the
/// way up to base-256.
///
/// Under the hood, the conversion works by treating each base as a custom
/// alphabet. The [_base] string defines 256+ unique symbols (digits, letters,
/// punctuation, Greek, and Cyrillic characters) and the algorithm maps
/// between source and destination alphabets using long division.
///
/// ## Common Conversions
///
/// ```dart
/// Radix.hex(255);         // 'FF'
/// Radix.bin(42);          // '101010'
/// Radix.oct(8);           // '10'
/// Radix.base(100, Base.b36); // base-36 representation
/// ```
///
/// ## Colour Helpers
///
/// [Radix] also includes a few helpers for clamping values into the 0-255
/// colour range:
///
/// ```dart
/// Radix.colourValue(128.7);            // 129
/// Radix.fractionToColourValue(0.5);    // 128
/// Radix.percentToColourValue(50.0);    // 128
/// ```
class Radix {
  @Deprecated('Use base instead')
  static dynamic change(dynamic data, Base radix) {
    return data is int
        ? _crypt(
            data: data.toString(),
            from: _base.substring(0, 10),
            to: _base.substring(0, radix.value),
          )
        : int.parse(
            _crypt(
              data: data,
              from: _base.substring(0, radix.value),
              to: _base.substring(0, 10),
            ),
          );
  }

  /// Converts an integer [data] to its string representation in the given
  /// [radix] base.
  ///
  /// ```dart
  /// Radix.base(255, Base.hexadecimal); // 'FF'
  /// Radix.base(42, Base.binary);       // '101010'
  /// ```
  static String base(int data, Base radix) {
    return _crypt(
      data: data,
      from: _base.substring(0, Bases.decimal.value),
      to: _base.substring(0, radix.value),
    );
  }

  /// Converts a string [data] from [currentRadix] back to its decimal
  /// (base-10) string representation.
  static String getDecimal(String data, Base currentRadix) {
    return _crypt(
      data: data,
      from: _base.substring(0, currentRadix.value),
      to: _base.substring(0, Bases.decimal.value),
    );
  }

  /// Shorthand for octal (base-8) conversion.
  static String oct(int data) => base(data, Bases.b8);

  /// Shorthand for binary (base-2) conversion, uppercase.
  static String bin(int data) => base(data, Bases.b2).toUpperCase();

  /// Shorthand for hexadecimal (base-16) conversion, uppercase.
  static String hex(int data) => base(data, Bases.b16).toUpperCase();

  /// Shorthand for decimal (base-10) conversion.
  static String dec(int data) => base(data, Bases.b10);

  /// Shorthand for base-256 conversion.
  static String b256(int data) => base(data, Bases.b256);

  static String _crypt({
    dynamic data,
    required String from,
    required String to,
  }) {
    data = data.toString();
    final int sourceBase = from.length;
    final int destinationBase = to.length;
    final Map<int, int> numberMap = {};
    int divide = 0;
    int newLength = 0;
    int length = data.toString().length;
    String result = '';

    for (int i = 0; i < length; i++) {
      final index = from.indexOf(data[i]);
      if (index == -1) {
        throw FormatException(
          'Source "$data" contains character '
          '"${data[i]}" which is outside of the defined source alphabet '
          '"$from"',
        );
      }
      numberMap[i] = from.indexOf(data[i]);
    }

    do {
      divide = 0;
      newLength = 0;
      for (int i = 0; i < length; i++) {
        divide = divide * sourceBase + (numberMap[i] as int);
        if (divide >= destinationBase) {
          numberMap[newLength++] = divide ~/ destinationBase;
          divide = divide % destinationBase;
        } else if (newLength > 0) {
          numberMap[newLength++] = 0;
        }
      }
      length = newLength;
      result = to[divide] + result;
    } while (newLength != 0);
    return result;
  }

  /// Clamps [data] to the 0-255 range and rounds to the nearest integer.
  ///
  /// Useful for ensuring a raw double stays within valid RGB bounds.
  static int colourValue(double data) {
    return data.clamp(0, 255).round();
  }

  /// Converts a 0.0-1.0 fraction to a 0-255 colour value.
  static int fractionToColourValue(double data) {
    return (data.clamp(0.0, 1.0) * 255).round();
  }

  /// Converts a 0-100 percentage to a 0-255 colour value.
  static int percentToColourValue(double data) {
    return ((data.clamp(0.0, 100.0) / 100) * 255).round();
  }

  static const String _base =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@%^\$&*()-_=[]{}|;:,.<>?~`\'"\\ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿЀЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя#';
}
