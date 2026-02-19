part of '../../recollect_utils.dart';

/// A [TextInputFormatter] that forces all input text to uppercase.
///
/// Handy for hex colour input fields where you want consistent casing
/// (e.g. `#FF00AA` instead of `#ff00aa`). Just attach it to a `TextField`:
///
/// ```dart
/// TextField(
///   inputFormatters: [UpperCaseTextFormatter()],
/// )
/// ```
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
}

/// A [PanGestureRecognizer] that always wins the gesture arena.
///
/// Normal pan recognizers can lose to competing gestures (like scrolling).
/// This one immediately claims victory, which is exactly what you want for
/// colour picker drag interactions — the picker should always respond to
/// the user's finger or cursor, no matter what else is going on.
class AlwaysWinPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'alwaysWin';
}

/// Describes the type of gradient palette to render in a colour picker.
///
/// Each value maps to a specific combination of colour channels and colour
/// space that determines how the 2D palette gradient is painted. The picker
/// uses this to know which axes to vary and which channel to hold fixed.
///
/// ## HSV Palette Types
/// - [hsv] — Standard saturation (x) vs value (y) palette.
/// - [hsvWithHue] — HSV palette with a fixed hue channel.
/// - [hsvWithValue] — HSV palette with a fixed value (brightness) channel.
/// - [hsvWithSaturation] — HSV palette with a fixed saturation channel.
///
/// ## HSL Palette Types
/// - [hsl] — Standard HSL palette.
/// - [hslWithHue] — HSL palette with a fixed hue channel.
/// - [hslWithLightness] — HSL palette with a fixed lightness channel.
/// - [hslWithSaturation] — HSL palette with a fixed saturation channel.
///
/// ## RGB Palette Types
/// - [rgbWithBlue] / [rgbWithGreen] / [rgbWithRed] — RGB palette holding
///   one channel fixed while the other two vary across the axes.
///
/// ## Wheel
/// - [hueWheel] — A circular hue wheel (0-360 degrees around the ring).
enum PaletteType {
  hsv,
  hsvWithHue,
  hsvWithValue,
  hsvWithSaturation,
  hsl,
  hslWithHue,
  hslWithLightness,
  hslWithSaturation,
  rgbWithBlue,
  rgbWithGreen,
  rgbWithRed,
  hueWheel,
}

/// Identifies which colour channel a slider track controls.
///
/// Used by the colour picker's slider widgets to determine what gradient
/// to draw and which value to update when the user drags the thumb.
///
/// - [hue] — The hue channel (0-360 degrees).
/// - [saturation] — Saturation in the HSV colour space.
/// - [saturationForHSL] — Saturation in the HSL colour space (different
///   visual behaviour than HSV saturation).
/// - [value] — Brightness/value in HSV.
/// - [lightness] — Lightness in HSL.
/// - [red] / [green] / [blue] — Individual RGB channels (0-255).
/// - [alpha] — Opacity (0.0-1.0).
enum TrackType {
  hue,
  saturation,
  saturationForHSL,
  value,
  lightness,
  red,
  green,
  blue,
  alpha,
}

/// The display format for the colour value label shown alongside the picker.
///
/// - [hex] — Hexadecimal string (e.g. `#FF5733`).
/// - [rgb] — Red, green, blue components (e.g. `rgb(255, 87, 51)`).
/// - [hsv] — Hue, saturation, value components.
/// - [hsl] — Hue, saturation, lightness components.
enum ColorLabelType { hex, rgb, hsv, hsl }

/// The colour model used for internal calculations and UI display.
///
/// - [rgb] — Red, Green, Blue model (additive colour mixing).
/// - [hsv] — Hue, Saturation, Value model (intuitive for colour selection).
/// - [hsl] — Hue, Saturation, Lightness model (perceptually balanced).
enum ColorModel { rgb, hsv, hsl }
