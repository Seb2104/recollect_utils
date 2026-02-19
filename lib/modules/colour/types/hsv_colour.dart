part of '../colour.dart';

/// A colour represented in the **HSV** (Hue, Saturation, Value) colour space.
///
/// HSV is a cylindrical model where:
/// - **Hue** (0-360) is the colour angle on the colour wheel.
/// - **Saturation** (0.0-1.0) is the purity/intensity of the colour.
/// - **Value** (0.0-1.0) is the brightness, from black (0) to full colour (1).
///
/// HSV is often preferred for colour pickers because it maps intuitively
/// to how humans think about colour selection — pick a hue, then adjust
/// how vivid and how bright it should be.
///
/// [HSVColour] implements Flutter's [HSVColor] interface, so it works
/// anywhere Flutter expects an [HSVColor].
///
/// ## Creating
///
/// ```dart
/// final hsv = HSVColour(hue: 120, saturation: 1.0, value: 0.8);
/// final fromColour = HSVColour.fromColour(someColour);
/// final fromFlutter = HSVColour.fromColor(Colors.green);
/// ```
///
/// ## Converting
///
/// ```dart
/// final colour = hsv.toColour();  // → Colour (ARGB)
/// final hsl = hsv.toHSL();        // → HSLColour
/// final color = hsv.toColor();     // → Flutter Color
/// ```
class HSVColour extends ColourSpace implements HSVColor {
  @override
  final double alpha;

  @override
  final double hue;

  @override
  final double saturation;

  @override
  final double value;

  const HSVColour({
    this.alpha = 1.0,
    this.hue = 360,
    this.saturation = 1.0,
    this.value = 1,
  });

  const HSVColour.fromAHSV(this.alpha, this.hue, this.saturation, this.value)
    : assert(alpha >= 0.0),
      assert(alpha <= 1.0),
      assert(hue >= 0.0),
      assert(hue <= 360.0),
      assert(saturation >= 0.0),
      assert(saturation <= 1.0),
      assert(value >= 0.0),
      assert(value <= 1.0);

  factory HSVColour.fromColor(Color color) {
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final double alpha = color.alpha / 0xFF;
    final double hue = ColourSpace.getHue(red, green, blue, max, delta);
    final double saturation = max == 0.0 ? 0.0 : delta / max;

    return HSVColour.fromAHSV(alpha, hue, saturation, max);
  }

  HSVColour.fromHSVColor(HSVColor hsvColor)
    : alpha = hsvColor.alpha,
      hue = hsvColor.hue,
      saturation = hsvColor.saturation,
      value = hsvColor.value;

  factory HSVColour.fromColour(Colour colour) => colour.toHSV();

  factory HSVColour.fromHSLColour(HSLColour hsl) => hsl.toHSV();

  @override
  Colour toColour() {
    double red, green, blue;

    if (saturation == 0) {
      red = green = blue = value;
    } else {
      final double sector = hue / 60;
      final int i = sector.floor();
      final double f = sector - i;
      final double p = value * (1 - saturation);
      final double q = value * (1 - saturation * f);
      final double t = value * (1 - saturation * (1 - f));

      switch (i % 6) {
        case 0:
          red = value;
          green = t;
          blue = p;
          break;
        case 1:
          red = q;
          green = value;
          blue = p;
          break;
        case 2:
          red = p;
          green = value;
          blue = t;
          break;
        case 3:
          red = p;
          green = q;
          blue = value;
          break;
        case 4:
          red = t;
          green = p;
          blue = value;
          break;
        case 5:
          red = value;
          green = p;
          blue = q;
          break;
        default:
          red = green = blue = 0;
      }
    }

    return Colour(
      alpha: (alpha * 255).round(),
      red: (red * 255).round(),
      green: (green * 255).round(),
      blue: (blue * 255).round(),
    );
  }

  @override
  HSLColour toHSL() {
    double s = 0.0;
    double l = 0.0;
    l = (2 - saturation) * value / 2;
    if (l != 0) {
      if (l == 1) {
        s = 0.0;
      } else if (l < 0.5) {
        s = saturation * value / (l * 2);
      } else {
        s = saturation * value / (2 - l * 2);
      }
    }
    return HSLColour.fromAHSL(alpha, hue, s.clamp(0.0, 1.0), l.clamp(0.0, 1.0));
  }

  @override
  HSVColour toHSV() => this;

  @override
  Color toColor() {
    return toColour().color;
  }

  @override
  HSVColour withAlpha(double alpha) {
    return HSVColour.fromAHSV(alpha, hue, saturation, value);
  }

  @override
  HSVColour withHue(double hue) {
    return HSVColour.fromAHSV(alpha, hue, saturation, value);
  }

  @override
  HSVColour withSaturation(double saturation) {
    return HSVColour.fromAHSV(alpha, hue, saturation, value);
  }

  @override
  HSVColour withValue(double value) {
    return HSVColour.fromAHSV(alpha, hue, saturation, value);
  }

  @override
  String toString() =>
      '${alpha.roundToPrecision(2)},${hue.roundToPrecision(2)},${saturation.roundToPrecision(2)},${value.roundToPrecision(2)}';
}

/// Convenience extension to convert a Flutter [HSVColor] to an [HSVColour].
extension Hsvcolour on HSVColor {
  /// Returns this [HSVColor] as a Collect [HSVColour].
  HSVColour get toHSVColour {
    return HSVColour(
      alpha: alpha,
      hue: hue,
      saturation: saturation,
      value: value,
    );
  }
}
