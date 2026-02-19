/// The Collect Colour system — a multi-format colour class that goes beyond
/// Flutter's [Color].
///
/// This library provides [Colour], a drop-in replacement for [Color] that
/// adds support for multiple colour spaces (RGB, HSL, HSV), numerous input
/// formats (hex, percentage, fraction, base-256), and seamless conversion
/// between them.
///
/// ## Colour Spaces
///
/// - [Colour] — The primary ARGB colour class (implements [Color]).
/// - [HSVColour] — Hue, Saturation, Value representation (implements [HSVColor]).
/// - [HSLColour] — Hue, Saturation, Lightness representation (implements [HSLColor]).
/// - [ColourSpace] — The sealed base class that defines the conversion contract.
///
/// ## Quick Start
///
/// ```dart
/// // From hex
/// final red = Colour.fromHex(hexString: '#FF0000');
///
/// // From RGB components
/// final blue = Colour.fromRGB(red: 0, green: 0, blue: 255);
///
/// // From HSV values
/// final green = Colour.fromHSV(h: 120, s: 1.0, v: 1.0);
///
/// // Convert between spaces
/// final hsv = red.toHSV();
/// final hsl = red.toHSL();
///
/// // Output in different formats
/// print(red.hex);   // 'FFFF0000'
/// print(red.rgb);   // '255,0,0'
/// print(red.b256);  // base-256 encoded
/// ```
library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:recollect_utils/recollect_utils.dart';
import 'package:flutter/material.dart';

part 'types/colour_space.dart';
part 'types/hsl_colour.dart';
part 'types/hsv_colour.dart';

/// A rich colour class that implements Flutter's [Color] interface while
/// adding multi-format input/output and colour space conversions.
///
/// [Colour] stores colour as ARGB integer components (0-255 each) and
/// can be created from hex strings, RGB/ARGB values, HSV/HSL values,
/// percentages, fractions, base-256 strings, or existing [Color] objects.
///
/// ## Constructors
///
/// | Constructor              | Input Format                             |
/// |--------------------------|------------------------------------------|
/// | `Colour()`               | Raw ARGB integers (0-255)                |
/// | `Colour.fromRGB()`       | RGB integers with full opacity           |
/// | `Colour.fromARGB()`      | RGB integers with opacity as percentage  |
/// | `Colour.fromHex()`       | Hex string (`#FF0000`, `#F00`, `FF0000`) |
/// | `Colour.fromHSV()`       | Hue (0-360), Saturation, Value (0-1)     |
/// | `Colour.fromHSL()`       | Hue (0-360), Saturation, Lightness (0-1) |
/// | `Colour.fromPercent()`   | ARGB as percentages (0-100)              |
/// | `Colour.fromFraction()`  | ARGB as fractions (0.0-1.0)              |
/// | `Colour.fromB256()`      | 4-character base-256 encoded string      |
/// | `Colour.fromColor()`     | Existing Flutter [Color]                 |
///
/// ## Output Formats
///
/// | Getter  | Example Output    |
/// |---------|-------------------|
/// | [hex]   | `'FFFF0000'`      |
/// | [rgb]   | `'255,0,0'`       |
/// | [argb]  | `'255,255,0,0'`   |
/// | [b256]  | Base-256 string   |
class Colour extends ColourSpace implements Color {
  /// The alpha (opacity) channel, 0-255.
  @override
  final int alpha;

  /// The red channel, 0-255.
  @override
  final int red;

  /// The green channel, 0-255.
  @override
  final int green;

  /// The blue channel, 0-255.
  @override
  final int blue;

  /// This colour converted to the HSV colour space.
  HSVColour get hsv => toHSV();

  /// This colour converted to the HSL colour space.
  HSLColour get hsl => toHSL();

  @override
  Colour toColour() => this;

  @override
  HSVColour toHSV() {
    final double red = color.r / 0xFF;
    final double green = color.g / 0xFF;
    final double blue = color.b / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.a / 0xFF;
    final double hue = ColourSpace.getHue(red, green, blue, max, delta);
    final double saturation = max == 0.0 ? 0.0 : delta / max;

    return HSVColour.fromAHSV(alpha, hue, saturation, max);
  }

  @override
  HSLColour toHSL() {
    final double red = color.r / 0xFF;
    final double green = color.g / 0xFF;
    final double blue = color.b / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.a / 0xFF;
    final double hue = ColourSpace.getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    final double saturation = min == max
        ? 0.0
        : delta /
              (1.0 - (2.0 * lightness - 1.0).abs()).clamp(0.0, double.infinity);
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  int toARGB32() {
    return _floatToInt8(a) << 24 |
        _floatToInt8(r) << 16 |
        _floatToInt8(g) << 8 |
        _floatToInt8(b) << 0;
  }

  @override
  int get hashCode => value;

  @override
  int get value =>
      ((alpha & 0xff) << 24) |
      ((red & 0xff) << 16) |
      ((green & 0xff) << 8) |
      ((blue & 0xff) << 0);

  int _floatToInt8(double x) {
    return (x * 255.0).round().clamp(0, 255);
  }

  @override
  double computeLuminance() {
    return 0;
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  double get r => red / 255;

  @override
  double get g => green / 255;

  @override
  double get b => blue / 255;

  /// Returns this [Colour] as a standard Flutter [Color].
  Color get color => Color.fromARGB(alpha, red, green, blue);

  /// The ARGB value as an 8-character hex string (e.g. `'FFFF0000'`).
  String get hex =>
      Radix.hex(alpha) + Radix.hex(red) + Radix.hex(green) + Radix.hex(blue);

  /// The ARGB value as a 4-character base-256 encoded string.
  String get b256 => alpha.b256 + red.b256 + green.b256 + blue.b256;

  /// Comma-separated ARGB string (e.g. `'255,255,0,0'`).
  String get argb => '$alpha,$red,$green,$blue';

  /// Comma-separated RGB string (e.g. `'255,0,0'`).
  String get rgb => '$red,$green,$blue';

  @override
  double get opacity => alpha / 255;

  @override
  double get a => alpha / 255;

  double get hue => hsv.hue;

  double get saturation => hsv.saturation;

  double get hsvValue => hsv.value;

  double get lightness => hsl.lightness;

  const Colour({
    this.alpha = 255,
    this.red = 255,
    this.green = 255,
    this.blue = 255,
  });

  const Colour.fromRGB({
    required this.red,
    required this.green,
    required this.blue,
  }) : alpha = 255,
       assert(red >= 0, red <= 255),
       assert(green >= 0, green <= 255),
       assert(blue >= 0, blue <= 255);

  factory Colour.fromARGB({
    double opacity = 100,
    int red = 255,
    int green = 255,
    int blue = 255,
  }) {
    return Colour(
      alpha: Radix.percentToColourValue(opacity.clamp(0, 100)),
      red: red.clamp(0, 255),
      green: green.clamp(0, 255),
      blue: blue.clamp(0, 255),
    );
  }

  Colour.fromB256(String data)
    : alpha = Radix.getDecimal(data[0], Bases.b256) as int,
      red = Radix.getDecimal(data[1], Bases.b256) as int,
      green = Radix.getDecimal(data[2], Bases.b256) as int,
      blue = Radix.getDecimal(data[3], Bases.b256) as int;

  Colour.fromPercent({
    double a = 100,
    double r = 100,
    double g = 100,
    double b = 100,
  }) : alpha = Radix.percentToColourValue(a.clamp(0, 100)),
       red = Radix.percentToColourValue(r.clamp(0, 100)),
       green = Radix.percentToColourValue(g.clamp(0, 100)),
       blue = Radix.percentToColourValue(b.clamp(0, 100));

  Colour.fromFraction({
    double alpha = 1.0,
    double red = 1.0,
    double green = 1.0,
    double blue = 1.0,
  }) : alpha = Radix.fractionToColourValue(alpha.clamp(0.0, 1.0)),
       red = Radix.fractionToColourValue(red.clamp(0.0, 1.0)),
       green = Radix.fractionToColourValue(green.clamp(0.0, 1.0)),
       blue = Radix.fractionToColourValue(blue.clamp(0.0, 1.0));

  factory Colour.fromHex({required String hexString}) {
    String hex = hexString.replaceAll('#', '').toUpperCase();

    if (hex.length == 6) {
      hex = 'FF$hex';
    } else if (hex.length == 3) {
      hex = 'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    } else if (hex.length == 4) {
      hex =
          '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
    }

    return Colour(
      alpha: int.parse(Radix.getDecimal(hex.substring(0, 2), Bases.b16)),
      red: int.parse(Radix.getDecimal(hex.substring(2, 4), Bases.b16)),
      green: int.parse(Radix.getDecimal(hex.substring(4, 6), Bases.b16)),
      blue: int.parse(Radix.getDecimal(hex.substring(6, 8), Bases.b16)),
    );
  }

  Colour.fromColor(Color color)
    : alpha = Radix.fractionToColourValue(color.a),
      red = Radix.fractionToColourValue(color.r),
      green = Radix.fractionToColourValue(color.g),
      blue = Radix.fractionToColourValue(color.b);

  factory Colour.fromHSL({
    required double h,
    required double s,
    required double l,
  }) {
    double red, green, blue;

    double normalizedH = h / 360.0;

    if (s == 0) {
      red = green = blue = l;
    } else {
      double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      double p = 2 * l - q;

      red = _hueToRgb(p, q, normalizedH + 1 / 3);
      green = _hueToRgb(p, q, normalizedH);
      blue = _hueToRgb(p, q, normalizedH - 1 / 3);
      return Colour(
        alpha: 255,
        red: red.round(),
        green: green.round(),
        blue: blue.round(),
      );
    }

    return Colour.fromARGB(
      opacity: 100.0,
      red: (red * 255).round(),
      green: (green * 255).round(),
      blue: (blue * 255).round(),
    );
  }

  factory Colour.fromHSVColour(HSVColour hsvColour) => hsvColour.toColour();

  factory Colour.fromHSLColour(HSLColour hslColour) => hslColour.toColour();

  factory Colour.fromHSV({
    double a = 1.0,
    required double h,
    required double s,
    required double v,
  }) {
    double red, green, blue;

    if (s == 0) {
      red = green = blue = v;
    } else {
      final double sector = h / 60;
      final int i = sector.floor();
      final double f = sector - i;
      final double p = v * (1 - s);
      final double q = v * (1 - s * f);
      final double t = v * (1 - s * (1 - f));

      switch (i % 6) {
        case 0:
          red = v;
          green = t;
          blue = p;
          break;
        case 1:
          red = q;
          green = v;
          blue = p;
          break;
        case 2:
          red = p;
          green = v;
          blue = t;
          break;
        case 3:
          red = p;
          green = q;
          blue = v;
          break;
        case 4:
          red = t;
          green = p;
          blue = v;
          break;
        case 5:
          red = v;
          green = p;
          blue = q;
          break;
        default:
          red = green = blue = 0;
      }
    }

    return Colour(
      alpha: (a * 255).round(),
      red: (red * 255).round(),
      green: (green * 255).round(),
      blue: (blue * 255).round(),
    );
  }

  @override
  Colour withAlpha(int alpha) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withRed(int red) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withGreen(int green) =>
      Colour(alpha: alpha, red: red, green: green, blue: blue);

  @override
  Colour withBlue(int blue) {
    return Colour(alpha: alpha, red: red, green: green, blue: blue);
  }

  Colour withHue(double hue) {
    return Colour.fromHSVColour(
      HSVColour.fromAHSV(a, hue, saturation, hsvValue),
    );
  }

  Colour withSaturation(double saturation) {
    return Colour.fromHSVColour(
      HSVColour.fromAHSV(a, hue, saturation, hsvValue),
    );
  }

  Colour withHsvValue(double value) {
    return Colour.fromHSVColour(HSVColour.fromAHSV(a, hue, saturation, value));
  }

  Colour withLightness(double lightness) {
    return Colour.fromHSLColour(
      HSLColour.fromAHSL(a, hue, saturation, lightness),
    );
  }

  HSVColor toHSVColor() => hsv;

  HSLColor toHSLColor() => hsl;

  String print() => b256;

  @override
  String toString() {
    return '${Radix.base(alpha, Bases.decimal)}${Radix.base(red, Bases.decimal)}${Radix.base(green, Bases.decimal)}${Radix.base(blue, Bases.decimal)}';
  }

  static double _hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }

  @override
  Colour withOpacity(double opacity) => withAlpha((255.0 * opacity).round());

  @override
  ColorSpace get colorSpace => ColorSpace.sRGB;

  @override
  Colour withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) {
    return Colour();
  }
}

/// Convenience extension to convert any Flutter [Color] to a [Colour].
///
/// ```dart
/// final colour = Colors.blue.colour;
/// print(colour.hex); // 'FF2196F3'
/// ```
extension c on Color {
  /// Converts this [Color] to a [Colour] instance.
  Colour get colour => Colour.fromColor(this);
}
