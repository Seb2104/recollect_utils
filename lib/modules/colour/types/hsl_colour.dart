part of '../colour.dart';

/// A colour represented in the **HSL** (Hue, Saturation, Lightness) colour
/// space.
///
/// HSL is a cylindrical model where:
/// - **Hue** (0-360) is the colour angle on the colour wheel.
/// - **Saturation** (0.0-1.0) is the intensity of the colour.
/// - **Lightness** (0.0-1.0) ranges from black (0) through the pure colour
///   (0.5) to white (1.0).
///
/// [HSLColour] implements Flutter's [HSLColor] interface, so you can use it
/// anywhere Flutter expects an [HSLColor].
///
/// ## Creating
///
/// ```dart
/// final hsl = HSLColour(hue: 200, saturation: 0.8, lightness: 0.5);
/// final fromColour = HSLColour.fromColour(someColour);
/// final fromFlutter = HSLColour.fromColor(Colors.blue);
/// ```
///
/// ## Converting
///
/// ```dart
/// final colour = hsl.toColour();  // → Colour (ARGB)
/// final hsv = hsl.toHSV();        // → HSVColour
/// final color = hsl.toColor();     // → Flutter Color
/// ```
class HSLColour extends ColourSpace implements HSLColor {
  const HSLColour.fromAHSL(
    this.alpha,
    this.hue,
    this.saturation,
    this.lightness,
  );

  const HSLColour({
    this.alpha = 1.0,
    this.hue = 360,
    this.saturation = 1.0,
    this.lightness = 1,
  });

  factory HSLColour.fromColor(Color color) {
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.alpha / 0xFF;
    final double hue = ColourSpace.getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    final double saturation = min == max
        ? 0.0
        : clampDouble(delta / (1.0 - (2.0 * lightness - 1.0).abs()), 0.0, 1.0);
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  factory HSLColour.fromColour(Colour color) => color.toHSL();

  factory HSLColour.fromHSVColour(HSVColour hsv) => hsv.toHSL();

  @override
  final double alpha;

  @override
  final double hue;

  @override
  final double saturation;

  @override
  final double lightness;

  @override
  HSLColour withAlpha(double alpha) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withHue(double hue) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withSaturation(double saturation) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  HSLColour withLightness(double lightness) {
    return HSLColour.fromAHSL(alpha, hue, saturation, lightness);
  }

  @override
  Colour toColour() {
    final double chroma = (1.0 - (2.0 * lightness - 1.0).abs()) * saturation;
    final double secondary =
        chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
    final double match = lightness - chroma / 2.0;

    return ColourSpace.colourFromHue(alpha, hue, chroma, secondary, match);
  }

  @override
  HSLColour toHSL() => this;

  @override
  HSVColour toHSV() {
    double s = 0.0;
    double v = 0.0;

    v = lightness + saturation * (lightness < 0.5 ? lightness : 1 - lightness);
    if (v != 0) s = 2 - 2 * lightness / v;

    return HSVColour.fromAHSV(alpha, hue, s.clamp(0.0, 1.0), v.clamp(0.0, 1.0));
  }

  @override
  Color toColor() {
    final double chroma = (1.0 - (2.0 * lightness - 1.0).abs()) * saturation;
    final double secondary =
        chroma * (1.0 - (((hue / 60.0) % 2.0) - 1.0).abs());
    final double match = lightness - chroma / 2.0;

    return ColourSpace.colorFromHue(alpha, hue, chroma, secondary, match);
  }

  HSLColour _scaleAlpha(double factor) {
    return withAlpha(alpha * factor);
  }

  static HSLColour? lerp(HSLColour? a, HSLColour? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b!._scaleAlpha(t);
    }
    if (b == null) {
      return a._scaleAlpha(1.0 - t);
    }
    return HSLColour.fromAHSL(
      clampDouble(lerpDouble(a.alpha, b.alpha, t)!, 0.0, 1.0),
      lerpDouble(a.hue, b.hue, t)! % 360.0,
      clampDouble(lerpDouble(a.saturation, b.saturation, t)!, 0.0, 1.0),
      clampDouble(lerpDouble(a.lightness, b.lightness, t)!, 0.0, 1.0),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HSLColour &&
        other.alpha == alpha &&
        other.hue == hue &&
        other.saturation == saturation &&
        other.lightness == lightness;
  }

  @override
  int get hashCode => Object.hash(alpha, hue, saturation, lightness);

  @override
  String toString() =>
      '${alpha.roundToPrecision(2)},${hue.roundToPrecision(2)},${saturation.roundToPrecision(2)},${lightness.roundToPrecision(2)}';
}

/// Convenience extension to convert a Flutter [HSLColor] to an [HSLColour].
extension Hslcolour on HSLColor {
  /// Returns this [HSLColor] as a Collect [HSLColour].
  HSLColour get toHSLColour {
    return HSLColour(
      alpha: alpha,
      hue: hue,
      lightness: lightness,
      saturation: saturation,
    );
  }
}
