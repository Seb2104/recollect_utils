/// The Collect Colour Picker — a family of interactive colour selection widgets.
///
/// This library provides four distinct picker styles, each suited to different
/// use cases and visual preferences:
///
/// | Picker     | Best For                                   |
/// |------------|--------------------------------------------|
/// | [wheel]    | Intuitive hue/saturation selection          |
/// | [square]   | Precise colour space exploration (HSV/HSL/RGB) |
/// | [ring]     | Compact hue selection with SV palette       |
/// | [slides]   | Channel-by-channel slider control           |
///
/// All pickers are accessed through the static factory methods on
/// [ColourPicker]. They share common features like alpha support, colour
/// history, label display, and thumb colour previews.
///
/// ```dart
/// ColourPicker.wheel(
///   currentColour: myColour,
///   onColourChanged: (colour) => setState(() => myColour = colour),
/// )
/// ```
library;

import 'dart:math';

import 'package:recollect_utils/recollect_utils.dart';
import 'package:recollect_utils/modules/colour_picker/src/common/constant.dart';
import 'package:flutter/material.dart';

part 'pickers/picker_ring.dart';
part 'pickers/picker_slides.dart';
part 'pickers/picker_square.dart';
part 'pickers/picker_wheel.dart';
part 'src/base/base_colour_picker.dart';
part 'src/common/colour_label.dart';
part 'src/common/colour_picker_slider.dart';
part 'src/common/indicator.dart';
part 'src/common/painters.dart';
part 'src/gestures/colour_picker_gesture_detector.dart';
part 'src/painters/palette_painters.dart';
part 'src/painters/ring_painter.dart';
part 'src/painters/wheel_painter.dart';

/// Central factory for creating colour picker widgets.
///
/// Rather than instantiating picker classes directly, use the static methods
/// on this class to get the picker style you need:
///
/// - [ColourPicker.wheel] — A circular hue wheel with saturation mapped
///   radially, plus value/alpha sliders.
/// - [ColourPicker.square] — A rectangular palette that supports multiple
///   colour models (HSV, HSL, RGB) with configurable axes.
/// - [ColourPicker.ring] — A hue ring surrounding a compact SV palette.
/// - [ColourPicker.slides] — Individual channel sliders (R/G/B, H/S/V, or
///   H/S/L) with optional comparison indicator.
///
/// Each method returns a ready-to-use [Widget] that you can drop into your
/// widget tree.
class ColourPicker {
  /// Creates a colour wheel picker.
  ///
  /// The wheel maps hue around the circle and saturation from centre to edge.
  /// A separate value slider controls brightness. Supports both portrait and
  /// landscape orientations.
  ///
  /// - [currentColour] is the starting colour.
  /// - [onColourChanged] fires whenever the user selects a new colour.
  /// - [size] controls the overall dimension of the picker area.
  /// - [style] wraps the picker in custom padding, margin, and decoration.
  /// - [orientation] forces a portrait or landscape layout.
  static Widget wheel({
    required Colour currentColour,
    required ValueChanged<Colour> onColourChanged,
    double size = 700,
    PickerStyle style = const PickerStyle(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    bool enableAlpha = true,
    bool showLabel = true,
    bool displayThumbColor = true,
    Orientation orientation = Orientation.landscape,

    HSVColour? pickerHsvColour,
    ValueChanged<HSVColor>? onHsvColourChanged,
    List<Colour>? colourHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return WheelPicker(
      currentColour: currentColour,
      onColourChanged: onColourChanged,
      size: size,
      style: style,
      showLabel: showLabel,
      displayThumbColor: displayThumbColor,
      orientation: orientation,
      pickerHsvColour: pickerHsvColour,
      onHsvColourChanged: onHsvColourChanged,
      colourHistory: colourHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  /// Creates a square palette colour picker.
  ///
  /// The square renders a 2D gradient based on the chosen [paletteType]. For
  /// instance, `PaletteType.hsvWithHue` shows saturation on the X-axis and
  /// value on the Y-axis, with a separate hue slider alongside.
  ///
  /// - [paletteType] selects which two components are shown on the square
  ///   axes and which one gets its own slider.
  /// - [colorPickerWidth] sets the width (and, via [pickerAreaHeightPercent],
  ///   the height) of the palette area.
  /// - [colorHistory] and [onHistoryChanged] enable a tappable history strip
  ///   of previously selected colours.
  static Widget square({
    required Color currentColour,
    required ValueChanged<Color> onColorChanged,
    HSVColour? pickerHsvColor,
    ValueChanged<HSVColor>? onHsvColorChanged,
    PaletteType paletteType = PaletteType.hueWheel,
    bool enableAlpha = true,
    bool showLabel = true,
    List<ColorLabelType> labelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hex,
    ],
    bool displayThumbColor = true,
    bool portraitOnly = false,
    double colorPickerWidth = 300,
    double pickerAreaHeightPercent = 1.0,
    bool hexInputBar = false,
    TextEditingController? hexInputController,
    BorderRadius? pickerAreaBorderRadius,
    List<Color>? colorHistory,
    ValueChanged<List<Color>>? onHistoryChanged,
  }) {
    return SquarePicker(
      currentColour: currentColour,
      onColorChanged: onColorChanged,
      pickerHsvColor: pickerHsvColor,
      onHsvColorChanged: onHsvColorChanged,
      paletteType: paletteType,
      enableAlpha: enableAlpha,
      showLabel: showLabel,
      labelTypes: labelTypes,
      displayThumbColor: displayThumbColor,
      portraitOnly: portraitOnly,
      colorPickerWidth: colorPickerWidth,
      pickerAreaHeightPercent: pickerAreaHeightPercent,
      colorHistory: colorHistory,
      onHistoryChanged: onHistoryChanged,
    );
  }

  /// Creates a slider-based colour picker.
  ///
  /// Presents individual channel sliders for the selected [colorModel] (RGB,
  /// HSV, or HSL). Optionally shows a comparison indicator that splits the
  /// original and current colour side by side.
  ///
  /// - [sliderSize] controls the width and height of each slider track.
  /// - [showIndicator] toggles the before/after colour comparison bar.
  /// - [showParams] displays the numeric value next to each slider.
  static Widget slides({
    required Color currentColour,
    required ValueChanged<Color> onColorChanged,
    ColorModel colorModel = ColorModel.rgb,
    bool enableAlpha = true,
    Size sliderSize = const Size(260, 40),
    bool showSliderText = true,
    TextStyle? sliderTextStyle,
    bool showLabel = true,
    bool showParams = true,
    List<ColorLabelType> labelTypes = const [],
    TextStyle? labelTextStyle,
    bool showIndicator = true,
    Size indicatorSize = const Size(280, 50),
    AlignmentGeometry indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    AlignmentGeometry indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    bool displayThumbColor = true,
    BorderRadius indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  }) {
    return SlidePicker(
      currentColour: currentColour,
      onColorChanged: onColorChanged,
      colorModel: colorModel,
      enableAlpha: enableAlpha,
      sliderSize: sliderSize,
      showSliderText: showSliderText,
      sliderTextStyle: sliderTextStyle,
      showLabel: showLabel,
      showParams: showParams,
      labelTypes: labelTypes,
      labelTextStyle: labelTextStyle,
      showIndicator: showIndicator,
      indicatorSize: indicatorSize,
      indicatorAlignmentBegin: indicatorAlignmentBegin,
      indicatorAlignmentEnd: indicatorAlignmentEnd,
      displayThumbColor: displayThumbColor,
      indicatorBorderRadius: indicatorBorderRadius,
    );
  }

  /// Creates a hue ring colour picker.
  ///
  /// Displays a circular hue ring with a square HSV palette in the centre.
  /// Dragging around the ring changes the hue; dragging inside the square
  /// adjusts saturation and value.
  ///
  /// - [hueRingStrokeWidth] controls the thickness of the hue ring.
  /// - [colorPickerHeight] sets the overall size of the picker.
  static Widget ring({
    required Color currentColour,
    required ValueChanged<Color> onColorChanged,
    bool portraitOnly = false,
    double colorPickerHeight = 250.0,
    double hueRingStrokeWidth = 20.0,
    bool enableAlpha = false,
    bool displayThumbColor = true,
    BorderRadius pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  }) {
    return HueRingPicker(
      currentColour: currentColour,
      onColorChanged: onColorChanged,
      portraitOnly: portraitOnly,
      colorPickerHeight: colorPickerHeight,
      hueRingStrokeWidth: hueRingStrokeWidth,
    );
  }
}
