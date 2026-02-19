part of '../colour.dart';

/// The sealed base class for all colour space representations in Collect.
///
/// Every colour space ([Colour], [HSVColour], [HSLColour]) extends
/// [ColourSpace] and implements the three conversion methods, so you can
/// freely convert between any pair of colour spaces.
///
/// ```dart
/// ColourSpace anyColour = someHSVColour;
/// final rgb = anyColour.toColour();
/// final hsl = anyColour.toHSL();
/// ```
sealed class ColourSpace {
  const ColourSpace();

  /// Converts this colour to its [Colour] (ARGB) representation.
  Colour toColour();

  /// Converts this colour to its [HSLColour] representation.
  HSLColour toHSL();

  /// Converts this colour to its [HSVColour] representation.
  HSVColour toHSV();

  /// Calculates the hue (0-360 degrees) from normalised RGB components.
  ///
  /// This is a shared helper used by all colour space conversion methods.
  static double getHue(
    double red,
    double green,
    double blue,
    double max,
    double delta,
  ) {
    late double hue;
    if (max == 0.0) {
      hue = 0.0;
    } else if (max == red) {
      hue = 60.0 * (((green - blue) / delta) % 6);
    } else if (max == green) {
      hue = 60.0 * (((blue - red) / delta) + 2);
    } else if (max == blue) {
      hue = 60.0 * (((red - green) / delta) + 4);
    }

    hue = hue.isNaN ? 0.0 : hue;
    return hue;
  }

  /// Constructs a [Colour] from hue, chroma, secondary component, and
  /// match offset values. This is the core algorithm that maps HSL/HSV
  /// parameters back to RGB.
  static Colour colourFromHue(
    double alpha,
    double hue,
    double chroma,
    double secondary,
    double match,
  ) {
    final (double red, double green, double blue) = switch (hue) {
      < 60.0 => (chroma, secondary, 0.0),
      < 120.0 => (secondary, chroma, 0.0),
      < 180.0 => (0.0, chroma, secondary),
      < 240.0 => (0.0, secondary, chroma),
      < 300.0 => (secondary, 0.0, chroma),
      _ => (chroma, 0.0, secondary),
    };
    return Colour.fromColor(
      Color.fromARGB(
        (alpha * 0xFF).round(),
        ((red + match) * 0xFF).round(),
        ((green + match) * 0xFF).round(),
        ((blue + match) * 0xFF).round(),
      ),
    );
  }

  /// Same as [colourFromHue] but returns a Flutter [Color] instead of a
  /// [Colour]. Used internally where the Flutter type is needed directly.
  static Color colorFromHue(
    double alpha,
    double hue,
    double chroma,
    double secondary,
    double match,
  ) {
    final (double red, double green, double blue) = switch (hue) {
      < 60.0 => (chroma, secondary, 0.0),
      < 120.0 => (secondary, chroma, 0.0),
      < 180.0 => (0.0, chroma, secondary),
      < 240.0 => (0.0, secondary, chroma),
      < 300.0 => (secondary, 0.0, chroma),
      _ => (chroma, 0.0, secondary),
    };
    return Color.fromARGB(
      (alpha * 0xFF).round(),
      ((red + match) * 0xFF).round(),
      ((green + match) * 0xFF).round(),
      ((blue + match) * 0xFF).round(),
    );
  }
}

/// Returns `true` if white text should be used on the given
/// [backgroundColor] for readability.
///
/// Uses a weighted luminance formula (ITU-R BT.601) to decide. Pass a
/// positive [bias] to make the function favour white more aggressively.
///
/// ```dart
/// useWhiteForeground(Colors.black);  // true
/// useWhiteForeground(Colors.white);  // false
/// ```
bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
  int v = math
      .sqrt(
        math.pow(backgroundColor.red, 2) * 0.299 +
            math.pow(backgroundColor.green, 2) * 0.587 +
            math.pow(backgroundColor.blue, 2) * 0.114,
      )
      .round();
  return v < 130 + bias ? true : false;
}

/// Converts an [HSVColor] to an [HSLColour].
HSLColour hsvToHsl(HSVColor color) {
  double s = 0.0;
  double l = 0.0;
  l = (2 - color.saturation) * color.value / 2;
  if (l != 0) {
    if (l == 1) {
      s = 0.0;
    } else if (l < 0.5) {
      s = color.saturation * color.value / (l * 2);
    } else {
      s = color.saturation * color.value / (2 - l * 2);
    }
  }
  return HSLColour.fromAHSL(
    color.alpha,
    color.hue,
    s.clamp(0.0, 1.0),
    l.clamp(0.0, 1.0),
  );
}

/// Converts an [HSLColor] to an [HSVColour].
HSVColour hslToHsv(HSLColor color) {
  double s = 0.0;
  double v = 0.0;

  v =
      color.lightness +
      color.saturation *
          (color.lightness < 0.5 ? color.lightness : 1 - color.lightness);
  if (v != 0) s = 2 - 2 * color.lightness / v;

  return HSVColour.fromAHSV(
    color.alpha,
    color.hue,
    s.clamp(0.0, 1.0),
    v.clamp(0.0, 1.0),
  );
}

/// Regex pattern that matches partial hex colour strings (1-8 hex chars,
/// optional leading `#`).
const String kValidHexPattern = r'^#?[0-9a-fA-F]{1,8}';

/// Regex pattern that matches complete, valid hex colour strings (3, 6, or
/// 8 hex chars, optional leading `#`).
const String kCompleteValidHexPattern =
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';

/// Parses a hex colour string into a Flutter [Color], or returns `null`
/// if the string is invalid.
///
/// Supports 3-digit (`#F00`), 6-digit (`#FF0000`), and 8-digit
/// (`#FFFF0000`) hex strings, with or without the leading `#`.
///
/// Set [enableAlpha] to `false` to force full opacity regardless of any
/// alpha component in the input.
Color? colorFromHex(String inputString, {bool enableAlpha = true}) {
  final RegExp hexValidator = RegExp(kCompleteValidHexPattern);
  if (!hexValidator.hasMatch(inputString)) return null;
  String hexToParse = inputString.replaceFirst('#', '').toUpperCase();
  if (!enableAlpha && hexToParse.length == 8) {
    hexToParse = 'FF${hexToParse.substring(2)}';
  }
  if (hexToParse.length == 3) {
    hexToParse = hexToParse.split('').expand((i) => [i * 2]).join();
  }
  if (hexToParse.length == 6) hexToParse = 'FF$hexToParse';
  final intColorValue = int.tryParse(hexToParse, radix: 16);
  if (intColorValue == null) return null;
  final color = Color(intColorValue);
  return enableAlpha ? color : color.withAlpha(255);
}

/// Converts a Flutter [Color] to a hex string.
///
/// Options:
/// - [includeHashSign] — Prepend `#` to the output.
/// - [enableAlpha] — Include the alpha channel in the output.
/// - [toUpperCase] — Return the hex in uppercase (default: `true`).
String colorToHex(
  Color color, {
  bool includeHashSign = false,
  bool enableAlpha = true,
  bool toUpperCase = true,
}) {
  final String hex =
      (includeHashSign ? '#' : '') +
      (enableAlpha ? _padRadix(color.alpha) : '') +
      _padRadix(color.red) +
      _padRadix(color.green) +
      _padRadix(color.blue);
  return toUpperCase ? hex.toUpperCase() : hex;
}

String _padRadix(int value) => value.toRadixString(16).padLeft(2, '0');
