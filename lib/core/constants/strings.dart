part of '../../recollect_utils.dart';

// ---------------------------------------------------------------------------
// ASCII & Unicode Character Classification Constants
// ---------------------------------------------------------------------------
//
// These constants power the low-level string utilities in Collect. They define
// character ranges and bitmask categories so the string processing functions
// can quickly classify characters without relying on regex.
// ---------------------------------------------------------------------------

/// The code point of the last ASCII character (DEL, `0x7F`).
const int asciiEnd = 0x7f;

/// The code point of the first ASCII character (NUL, `0x00`).
const int asciiStart = 0x0;

/// The last code point in the C0 control character range (`0x1F`).
const int c0End = 0x1f;

/// The first code point in the C0 control character range (`0x00`).
const int c0Start = 0x00;

/// The highest valid Unicode code point (`U+10FFFF`).
const int unicodeEnd = 0x10ffff;

/// Bitmask for digit characters (`0`-`9`).
const int digitMask = 0x1;

/// Bitmask for lowercase ASCII letters (`a`-`z`).
const int lowerMask = 0x2;

/// Bitmask for the underscore character (`_`).
const int underscoreMask = 0x4;

/// Bitmask for uppercase ASCII letters (`A`-`Z`).
const int upperMask = 0x8;

/// Combined bitmask matching any alphabetic character (upper or lower).
const int alphaMask = lowerMask | upperMask;

/// Combined bitmask matching any alphanumeric character (letters or digits).
const int alphaNumMask = alphaMask | digitMask;

/// A lookup table mapping each ASCII code point (0-127) to its character
/// category bitmask.
///
/// Each index corresponds to an ASCII code point. The value at that index
/// is a combination of [digitMask], [lowerMask], [upperMask], and
/// [underscoreMask] flags that describe what kind of character it is.
///
/// For example, `ascii[65]` (the letter 'A') contains [upperMask],
/// while `ascii[48]` (the digit '0') contains [digitMask].
const List<int> ascii = <int>[
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  digitMask,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  upperMask,
  0,
  0,
  0,
  0,
  underscoreMask,
  0,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  lowerMask,
  0,
  0,
  0,
  0,
  0,
];
