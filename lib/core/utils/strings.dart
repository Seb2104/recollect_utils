part of '../../recollect_utils.dart';

/// Control the padding on functions that allow the result
/// to be padded.
enum Pad {
  /// Add the padding to the left of the String
  left,

  /// Add the padding to the right of the String
  right,

  /// Do not pad the String.
  none,
}

/// A set of String utility functions that aim to
/// extend the set of  functions available the core String class
/// as well as provding safe methods when working with nullable
/// Strings.
/// A Strings method will never thrown an NPE and aims to provide the
/// expected result by treating the null as an empty String or
/// a space filled String where a range access is applied.
///
/// The same approach is applied for non-null Strings when the strings
/// length would result in a RangeError; Instead we pad the String to ensure
/// code returns the expected length String and you code keesp running
/// rather than crashing.
///
/// e.g.
/// ```dart
/// Strings.substring(null, 2,3);
/// -> ' '
/// ```
class Strings {
  Strings._();

  /// Checks if [string] is a number by attempting to parse it
  /// as a double.
  /// INFINITY and NaN are not treated as numbers.
  static bool isNumeric(String? string) {
    if (string == null) {
      return false;
    }
    if (string == double.infinity.toString() ||
        string == double.nan.toString()) {
      return false;
    }

    return double.tryParse(string) != null;
  }

  /// returns true if [string] only contains
  /// ascii characters.
  static bool isAscii(String? string) {
    if (string == null) {
      return false;
    }
    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      if (runes.length != 1) {
        return false;
      }
      final c = runes.first;
      if (c < asciiStart || c > asciiEnd) {
        return false;
      }
    }
    return true;
  }

  /// Checks that the string only contains digits.
  ///
  static bool isDigits(String? string) {
    if (string == null) {
      return false;
    }
    var valid = true;

    for (var i = 0; i < string.length; i++) {
      final char = string[i];
      if (!'0123456789'.contains(char)) {
        valid = false;
        break;
      }
    }
    return valid;
  }

  /// toLowerCase
  static bool isLowerCase(String? string) {
    if (string == null) {
      return true;
    }
    if (string.isEmpty) {
      return true;
    }

    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        var flag = 0;
        if (c <= asciiEnd) {
          flag = ascii[c];
        }

        if (c <= asciiEnd) {
          if (flag & upperMask != 0) {
            return false;
          }
        } else {
          if (s == s.toUpperCase()) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// True if [character] is visible if printed
  /// to the console.
  static bool isPrintable(int? character) {
    if (character == null) {
      return false;
    }
    switch (unicode.generalCategories[character]) {
      case unicode.control:
      case unicode.format:
      case unicode.lineSeparator:
      case unicode.notAssigned:
      case unicode.paragraphSeparator:
      case unicode.privateUse:
      case unicode.surrogate:
        return false;
      default:
        return true;
    }
  }

  /// True if the passed character is a whitespace character.
  /// Our definition of whitespace matches the [String.trim]
  /// functions set of whitespace characters which goes
  /// beyond the standard space, tab and newline to include
  /// unicode characters.
  ///
  static bool isWhitespace(String string) {
    for (final element in string.runes) {
      if (!isWhitespaceRune(element)) {
        return false;
      }
    }
    return true;
  }

  /// True if the passed rune is a whitespace character.
  /// Our definition of whitespace matches the [String.trim]
  /// functions set of whitespace characters which goes
  /// beyond the standard space, tab and newline to include
  /// unicode characters.
  static bool isWhitespaceRune(int rune) =>
      (rune >= 0x0009 && rune <= 0x000D) ||
      rune == 0x0020 ||
      rune == 0x0085 ||
      rune == 0x00A0 ||
      rune == 0x1680 ||
      rune == 0x180E ||
      (rune >= 0x2000 && rune <= 0x200A) ||
      rune == 0x2028 ||
      rune == 0x2029 ||
      rune == 0x202F ||
      rune == 0x205F ||
      rune == 0x3000 ||
      rune == 0xFEFF;

  /// Returns true if the string does not contain lower case letters
  ///
  /// Example:
  ///     print(isUpperCase("CamelCase"));
  ///     => false
  ///
  ///     print(isUpperCase("DART"));
  ///     => true
  ///
  ///     print(isUpperCase(""));
  ///     => false
  static bool isUpperCase(String? string) {
    if (string == null) {
      return true;
    }
    if (string.isEmpty) {
      return true;
    }

    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        var flag = 0;
        if (c <= asciiEnd) {
          flag = ascii[c];
        }

        if (c <= asciiEnd) {
          if (flag & lowerMask != 0) {
            return false;
          }
        } else {
          if (s == s.toLowerCase()) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Returns true if the string starts with the lower case character; otherwise
  /// false;
  ///
  /// Example:
  ///     print(startsWithLowerCase("camelCase"));
  ///     => true
  ///
  ///     print(startsWithLowerCase(""));
  ///     => false
  static bool startsWithLowerCase(String? string) {
    if (string == null) {
      return false;
    }
    if (string.isEmpty) {
      return false;
    }

    final characters = Characters(string);
    final s = characters.first;
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      var flag = 0;
      if (c <= asciiEnd) {
        flag = ascii[c];
      }

      if (c <= asciiEnd) {
        if (flag & lowerMask != 0) {
          return true;
        }
      } else {
        if (s == s.toLowerCase()) {
          return true;
        }
      }
    }

    return false;
  }

  /// Returns true if [string]] starts with the upper case character; otherwise
  /// false;
  ///
  /// Example:
  ///     print(startsWithUpperCase("Dart"));
  ///     => true
  ///
  ///     print(startsWithUpperCase(""));
  ///     => false
  static bool startsWithUpperCase(String? string) {
    if (string == null) {
      return false;
    }
    if (string.isEmpty) {
      return false;
    }

    final characters = Characters(string);
    final s = characters.first;
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      var flag = 0;
      if (c <= asciiEnd) {
        flag = ascii[c];
      }

      if (c <= asciiEnd) {
        if (flag & upperMask != 0) {
          return true;
        }
      } else {
        if (s == s.toUpperCase()) {
          return true;
        }
      }
    }

    return false;
  }

  /// Returns a string in the form "UpperCamelCase" or "lowerCamelCase".
  ///
  /// Example:
  ///      print(camelize("dart_vm"));
  ///      => DartVm
  static String toCamelCase(String? string, {bool lower = false}) {
    if (string == null) {
      return '';
    }
    if (string.isEmpty) {
      return string;
    }

    string = string.toLowerCase();
    var capitlize = true;
    var position = 0;
    var remove = false;
    final sb = StringBuffer();
    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      var flag = 0;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= asciiEnd) {
          flag = ascii[c];
        }
      }

      if (capitlize && flag & alphaMask != 0) {
        if (lower && position == 0) {
          sb.write(s);
        } else {
          sb.write(s.toUpperCase());
        }

        capitlize = false;
        remove = true;
        position++;
      } else {
        if (flag & underscoreMask != 0) {
          if (!remove) {
            sb.write(s);
            remove = true;
          }

          capitlize = true;
        } else {
          if (flag & alphaNumMask != 0) {
            capitlize = false;
            remove = true;
          } else {
            capitlize = true;
            remove = false;
            position = 0;
          }

          sb.write(s);
        }
      }
    }

    return sb.toString();
  }

  // toCapitalised
  static String toCapitalised(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  /// toPropoerCase
  static String toProperCase(String? sentence) {
    if (sentence == null) {
      return '';
    }
    final words = sentence.split(' ');
    var result = '';

    for (final word in words) {
      final lower = word.toLowerCase();
      if (lower.isNotEmpty) {
        final proper =
            '${lower.substring(0, 1).toUpperCase()}${lower.substring(1)}';
        result = result.isEmpty ? proper : '$result $proper';
      }
    }
    return result;
  }

  // toSnakeCase
  static String toSnakeCase(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    final sb = StringBuffer();
    var separate = false;
    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      var flag = 0;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= asciiEnd) {
          flag = ascii[c];
        }
      }

      if (separate && flag & upperMask != 0) {
        sb
          ..write('_')
          ..write(s.toLowerCase());
        separate = true;
      } else {
        if (flag & alphaNumMask != 0) {
          separate = true;
        } else if (flag & underscoreMask != 0 && separate) {
          separate = true;
        } else {
          separate = false;
        }

        sb.write(s.toLowerCase());
      }
    }

    return sb.toString();
  }

  /// reverse
  static String reverse(String? string) {
    if (string == null) {
      return '';
    }
    if (string.length < 2) {
      return string;
    }

    final characters = Characters(string);
    return characters.toList().reversed.join();
  }

  /// toEscape
  static String toEscape(
    String? string, {
    String Function(int charCode)? encode,
  }) {
    if (string == null || string.isEmpty) {
      return '';
    }

    encode ??= Strings.toUnicode;
    final sb = StringBuffer();
    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c >= c0Start && c <= c0End) {
          switch (c) {
            case 9:
              sb.write(r'\t');
            case 10:
              sb.write(r'\n');
            case 13:
              sb.write(r'\r');
            default:
              sb.write(encode(c));
          }
        } else if (c >= asciiStart && c <= asciiEnd) {
          switch (c) {
            case 34:
              sb.write(r'\"');
            case 36:
              sb.write(r'\$');
            case 39:
              sb.write(r"\'");
            case 92:
              sb.write(r'\\');
            default:
              sb.write(s);
          }
        } else if (isPrintable(c)) {
          sb.write(s);
        } else {
          sb.write(encode(c));
        }
      } else {
        // Experimental: Assumes that all clusters does not need to be escaped
        sb.write(s);
      }
    }

    return sb.toString();
  }

  /// Returns an unescaped printable string.
  ///
  /// Example:
  ///     print(toPrintable("Hello 'world' \n"));
  ///     => Hello 'world' \n
  static String toPrintable(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    final sb = StringBuffer();
    final characters = Characters(string);
    for (final s in characters) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c >= c0Start && c <= c0End) {
          switch (c) {
            case 9:
              sb.write(r'\t');
            case 10:
              sb.write(r'\n');
            case 13:
              sb.write(r'\r');
            default:
              sb.write(Strings.toUnicode(c));
          }
        } else if (isPrintable(c)) {
          sb.write(s);
        } else {
          sb.write(Strings.toUnicode(c));
        }
      } else {
        // Experimental: Assumes that all clusters can be printed
        sb.write(s);
      }
    }

    return sb.toString();
  }

  /// toUnicode
  static String toUnicode(int? charCode) {
    if (charCode == null) {
      return '';
    }
    if (charCode < 0 || charCode > unicodeEnd) {
      throw RangeError.range(charCode, 0, unicodeEnd, 'charCode');
    }

    var hex = charCode.toRadixString(16);
    final length = hex.length;
    if (length < 4) {
      hex = hex.padLeft(4, '0');
    }

    return '\\u$hex';
  }

  /// Concates a list by inserting [separator] between
  /// each item in the list, except for the last separator
  /// where [last] is used instead.
  static String conjuctionJoin(
    List<String> list, {
    String separator = ', ',
    String last = ' or ',
  }) {
    switch (list.length) {
      case 0:
        return '';
      case 1:
        return list.first;
      default:
        return '''${list.sublist(0, list.length - 1).join(separator)}$last${list.last}''';
    }
  }

  /// Refer to [String.length]
  ///
  /// If [string] is null then it is treated as an empty String
  static int length(String? string) => (string ?? '').length;

  /// Refer to [String.codeUnits]
  ///
  /// If [string] is null then it is treated as an empty String
  static List<int> codeUnits(String? string) => (string ?? '').codeUnits;

  /// Refer to [String.runes]
  ///
  /// If [string] is null then it is treated as an empty String
  static Runes runes(String? string) => (string ?? '').runes;

  /// Refer to [String.allMatches]
  ///
  /// If [string] is null then it is treated as an empty String
  static Iterable<Match> allMatches(
    String? pattern,
    String string, [
    int start = 0,
  ]) => (pattern ?? '').allMatches(string, start);

  /// Refer to [String.codeUnitAt]
  ///
  /// If [string] is null it is treated as an empty string which will result
  /// in an IndexOutOfBoundsException
  static int codeUnitAt(String? string, int index) =>
      (string ?? '').codeUnitAt(index);

  /// Refer to [String.compareTo]
  ///
  /// This method has special handling for a null [string] or [other].
  /// If both are null then we return -1
  /// If one of them is null then we use [nullIsLessThan] to determine if
  /// we return -1  or 1.
  static int compareTo(
    String? string,
    String? other, {
    bool nullIsLessThan = true,
  }) {
    if (string == other) {
      return 0;
    }
    if (string == null) {
      return nullIsLessThan ? -1 : 1;
    }
    if (other == null) {
      return nullIsLessThan ? 1 : -1;
    }
    return string.compareTo(other);
  }

  /// Refer to [String.contains]
  ///
  /// If [string] is null then it is treated as an empty String
  static bool contains(String? string, Pattern other, [int startIndex = 0]) =>
      (string ?? '').contains(other, startIndex);

  /// Refer to [String.endsWith]
  static bool endsWith(String? string, String? other) {
    if (string == null || other == null) {
      return false;
    }

    return string.endsWith(other);
  }

  /// Refer to [String.indexOf]
  ///
  /// If [string] is null then it is treated as an empty String
  static int indexOf(String? string, Pattern pattern, [int start = 0]) =>
      (string ?? '').indexOf(pattern, start);

  /// Refer to [String.lastIndexOf]
  ///
  /// If [string] is null then it is treated as an empty String
  static int lastIndexOf(String? string, Pattern pattern, [int? start]) =>
      (string ?? '').lastIndexOf(pattern, start);

  /// Refer to [String.matchAsPrefix]
  ///
  /// If [string] is null then it is treated as an empty String
  static Match? matchAsPrefix(
    String? pattern,
    String string, [
    int start = 0,
  ]) => (pattern ?? '').matchAsPrefix(string, start);

  /// Refer to [String.padLeft]
  ///
  /// If [string] is null then it is treated as an empty String
  static String padLeft(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padLeft(width, padding);

  /// Refer to [String.padRight]
  ///
  /// If [string] is null then it is treated as an empty String
  static String padRight(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padRight(width, padding);

  /// Refer to [String.replaceAll]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceAll(String? string, Pattern from, String replace) =>
      (string ?? '').replaceAll(from, replace);

  /// Refer to [String.replaceAllMapped]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceAllMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace,
  ) => (string ?? '').replaceAllMapped(from, replace);

  /// Refer to [String.replaceFirst]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceFirst(
    String? string,
    Pattern from,
    String to, [
    int startIndex = 0,
  ]) => (string ?? '').replaceFirst(from, to, startIndex);

  /// Refer to [String.replaceFirstMapped]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceFirstMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace, [
    int startIndex = 0,
  ]) => (string ?? '').replaceFirstMapped(from, replace, startIndex);

  /// Refer to [String.replaceRange]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceRange(
    String? string,
    int start,
    int? end,
    String replacement,
  ) => (string ?? '').replaceRange(start, end, replacement);

  /// Refer to [String.split]
  ///
  /// If [string] is null then it is treated as an empty String
  static List<String> split(String? string, Pattern pattern) =>
      (string ?? '').split(pattern);

  /// Refer to [String.splitMapJoin]
  ///
  /// If [string] is null then it is treated as an empty String
  static String splitMapJoin(
    String? string,
    Pattern pattern, {
    String Function(Match)? onMatch,
    String Function(String)? onNonMatch,
  }) => (string ?? '').splitMapJoin(
    pattern,
    onMatch: onMatch,
    onNonMatch: onNonMatch,
  );

  /// Refer to [String.startsWith]
  ///
  /// If [string] is null then it is treated as an empty String
  static bool startsWith(String? string, Pattern pattern, [int index = 0]) =>
      (string ?? '').startsWith(pattern, index);

  /// Refer to [String.substring]
  ///
  /// If [string] is null then it is treated as an empty String
  static String substring(String? string, int start, [int? end]) {
    if (string == null) {
      return ' ' * ((end ?? start + 1) - start);
    }
    return string.substring(start, end);
  }

  /// Refer to [String.toLowerCase]
  ///
  /// If [string] is null then it is treated as an empty String
  static String toLowerCase(String? string) => (string ?? '').toLowerCase();

  /// Refer to [String.toUpperCase]
  ///
  /// If [string] is null then it is treated as an empty String
  static String toUpperCase(String? string) => (string ?? '').toUpperCase();

  /// Refer to [String.trim]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trim(String? string) => (string ?? '').trim();

  /// Refer to [String.trimLeft]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trimLeft(String? string) => (string ?? '').trimLeft();

  /// Refer to [String.trimRight]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trimRight(String? string) => (string ?? '').trimRight();

  /// true if the [string] is null or Blank.
  /// A string that only contains whitespace is considered blank.
  /// See: [Empty.isEmpty] to check for a null or zero length string.
  static bool isBlank(String? string) {
    if (string == null) {
      return true;
    }
    return string.trim().isEmpty;
  }

  /// true if the [string] is not null and not Blank.
  /// A string containing only whitespace is considered blank.
  /// See: [Empty.isNotEmpty] to check for non-zero length string.
  static bool isNotBlank(String? string) => !isBlank(string);

  /// If the [string] is not blank then we return [string]
  /// otherwise we return [elseString]
  static String orElse(String? string, String elseString) =>
      isNotBlank(string) ? string! : elseString;

  /// Abbreviate a string to [maxWidth] by truncating the
  /// string and adding '...' to then truncated string.
  /// ```dart
  /// Strings.abbreviate('Hello World', 6) == 'Hel...'
  /// ```
  /// Pass an [offset] to to start the abbreviation from the given
  /// [offset].  The returned string will included everything before
  /// the offset plus as well as the abreviate text staring from the offset.
  /// If [maxWidth] is less than 4 then we just truncate the string
  /// to the given width.
  /// If [string] is shorter than maxWidth we just return [string].
  /// If [string] is null we return an empty string.
  static String abbreviate(String? string, int maxWidth, {int offset = 0}) {
    if (string == null) {
      return '';
    }
    final length = string.length;
    if (length <= maxWidth || maxWidth < 4) {
      return string;
    }
    if (offset > length) {
      offset = length;
    }
    if (length - offset < maxWidth - 3) {
      offset = length - (maxWidth - 3);
    }
    const abrevMarker = '...';
    if (offset <= 4) {
      return string.substring(0, maxWidth - 3) + abrevMarker;
    }

    if (offset + maxWidth - 3 < length) {
      return abrevMarker + abbreviate(string.substring(offset), maxWidth - 3);
    }
    return abrevMarker + string.substring(length - (maxWidth - 3));
  }

  /// Hides part of a string by replace the characters between
  /// [start] (inclusive) and [end] exclusive.
  /// If start is not passed then it is defaults to 0.
  /// If end is it defaults to the end of the string.
  ///
  /// By default characters are replaced with '*' however you can
  /// choose an alternate character(s) by passing [replaceWith].
  static String hidePart(
    String? string, {
    int start = 0,
    int? end,
    String replaceWith = '*',
  }) {
    if (string == null) {
      return '';
    }
    end ??= string.length;

    final characters = Characters(string);
    final sb = StringBuffer();
    var pos = 0;

    for (final ch in characters) {
      if (pos >= start && pos < end) {
        sb.write(replaceWith);
      } else {
        sb.write(ch);
      }

      pos++;
    }
    return sb.toString();
  }

  /// Returns the joined elements of the [list].
  /// If the [list] is null then an empty String is returned.
  /// If any element in [list] is null it is treated as an empty string
  /// but still included in the list.
  /// If [excludeEmpty] is true then any empty elements are not included.
  ///
  /// Example:
  ///     print(join(null));
  ///     => ''
  ///
  ///     print(join([1, 2]));
  ///     => 12
  ///     print(join([1, 2], separator: ','));
  ///     => 1,2
  static String join(
    List<Object?>? list, {
    String separator = '',
    bool excludeEmpty = false,
  }) {
    if (list == null) {
      return '';
    }

    if (excludeEmpty) {
      final nonEmptyElements = list.where(
        (element) =>
            element != null &&
            ((element is! String) || Strings.isNotBlank(element)),
      );
      return nonEmptyElements.map((element) => element ?? '').join(separator);
    }
    return list.map((element) => element ?? '').join(separator);
  }

  /// Returns the first [take] characters from [string]
  /// If [take] is longer than [string] then the result is padded
  /// according to [pad]
  static String left(String? string, int take, {Pad pad = Pad.none}) {
    string ??= '';

    final length = string.length;
    if (length >= take) {
      return string.substring(0, take);
    }

    final padLength = take - length;

    switch (pad) {
      case Pad.left:
        return "${' ' * padLength}$string";
      case Pad.right:
        return "$string${' ' * padLength}";
      case Pad.none:
        return string;
    }
  }

  /// Returns all characters from [string] starting at [take] inclusive.
  /// If [take] is outside the bounds of [string] then padding
  /// is applied according to [pad].
  static String right(String? string, int take, {Pad pad = Pad.none}) {
    string ??= '';

    final length = string.length;
    if (length >= take) {
      return string.substring(length - take);
    }

    final padLength = take - length;

    switch (pad) {
      case Pad.left:
        return "${' ' * padLength}$string";
      case Pad.right:
        return "$string${' ' * padLength}";
      case Pad.none:
        return string;
    }
  }

  /// Returns the string bounded by the left and right delimiters.
  /// Throws an exception if either of the delimiters are missing.
  /// If there are nested delimiters we return the outer most
  /// delimiters.
  static String within(String string, String left, String right) {
    final leftIndex = string.indexOf(left);
    final rightIndex = string.lastIndexOf(right);

    if (leftIndex == -1) {
      throw ArgumentError('The left bounding character was missing');
    }

    if (rightIndex == -1) {
      throw ArgumentError('The right bounding character was missing');
    }

    final within = string.substring(leftIndex + 1, rightIndex);
    return within;
  }

  /// Returns the left most part of a string upto,
  /// but not including, the [delimiter]
  ///
  /// If there is no [delimiter] found then the entire string
  /// is returned.
  ///
  static String upTo(String string, String delimiter) {
    var index = string.indexOf(delimiter);
    if (index == -1) {
      index = string.length;
    }
    return string.substring(0, index);
  }

  /// hide the default ctor as this is a collection of statics.
  /// true if the [string] is null, or is a zero length String
  static bool isEmpty(String? string) {
    if (string == null) {
      return true;
    }
    return string.isEmpty;
  }

  /// true if the [string] is not null and is not a zero length String
  static bool isNotEmpty(String? string) => !isEmpty(string);

  /// If [string] is not null, then return [string]
  /// If [string] is null call [elseValue] and return the result.
  /// Rather than using this function you could just call:
  /// value ?? elseValue();
  static String orElseCall(String? string, String Function() elseValue) =>
      string ?? elseValue();

  /// If [string] is null we return a zero length string
  /// otherwise we return [string].
  static String toEmpty(String? string) {
    if (string == null) {
      return '';
    } else {
      return string;
    }
  }

  /// If the [string] is not blank then we return [string]
  /// otherwise we return [elseString]
  static String orElseOnBlank(String? string, String elseString) =>
      isNotBlank(string) ? string! : elseString;

  /// Safely compares two nullable strings.
  ///
  /// If both are null returns false
  /// If one of them is null returns false
  /// if both are the same returns true.
  static bool equals(String? lhs, String? rhs) {
    if (lhs == null && rhs == null) {
      return true;
    }

    if (lhs == null) {
      return false;
    }
    if (rhs == null) {
      return false;
    }
    if (!(lhs == rhs)) {
      return false;
    }

    return true;
  }

  /// Compare two nullable strings ignoring case.
  ///
  /// If both are null returns false
  /// If one of them is null returns false
  /// if both are the same, ignoring case, returns true.
  static bool equalsIgnoreCase(String? lhs, String? rhs) {
    if (lhs == null && rhs == null) {
      return true;
    }
    if (lhs == null) {
      return false;
    }
    if (rhs == null) {
      return false;
    }

    return lhs.toLowerCase() == rhs.toLowerCase();
  }
}
