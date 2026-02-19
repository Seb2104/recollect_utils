part of '../colour_picker.dart';

/// A rectangular 2D palette colour picker with a configurable colour model.
///
/// The palette axes change depending on the selected [paletteType]. For
/// example, `PaletteType.hsvWithHue` shows saturation horizontally and value
/// vertically, while a separate slider adjusts hue.
///
/// Features include:
/// - Support for HSV, HSL, and RGB palette modes.
/// - Optional alpha slider.
/// - Colour history strip (tap the indicator to save, long-press to remove).
/// - Colour label display in multiple formats.
///
/// This widget is not typically created directly — use
/// [ColourPicker.square] instead.
class SquarePicker extends StatefulWidget {
  const SquarePicker({
    super.key,
    required this.currentColour,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.paletteType = PaletteType.hsvWithHue,
    this.enableAlpha = true,
    this.showLabel = true,
    this.labelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hsv,
      ColorLabelType.hsl,
    ],
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.colorPickerWidth = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.colorHistory,
    this.onHistoryChanged,
  });

  final Color currentColour;
  final ValueChanged<Color> onColorChanged;
  final HSVColour? pickerHsvColor;
  final ValueChanged<HSVColour>? onHsvColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final bool showLabel;
  final List<ColorLabelType> labelTypes;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double colorPickerWidth;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final List<Color>? colorHistory;
  final ValueChanged<List<Color>>? onHistoryChanged;

  @override
  State<SquarePicker> createState() => _SquarePickerState();
}

class _SquarePickerState extends BaseColourPicker<SquarePicker> {
  @override
  Color getInitialColor() => widget.currentColour;

  @override
  HSVColour? getInitialHsvColor() => widget.pickerHsvColor;

  @override
  List<Color>? getColorHistory() => widget.colorHistory;

  @override
  ValueChanged<List<Color>>? getHistoryChangedCallback() =>
      widget.onHistoryChanged;

  @override
  void notifyColorChanged(HSVColour color) {
    widget.onColorChanged(color.toColor());
    if (widget.onHsvColorChanged != null) {
      widget.onHsvColorChanged!(color);
    }
  }

  Widget colorPicker() {
    return ClipRRect(
      borderRadius: widget.pickerAreaBorderRadius,
      child: RectanglePaletteGestureDetector(
        onColorChanged: onColorChanging,
        paletteType: widget.paletteType,
        hsvColor: currentHsvColor,
        child: CustomPaint(painter: _getPainterForPaletteType()),
      ),
    );
  }

  CustomPainter _getPainterForPaletteType() {
    switch (widget.paletteType) {
      case PaletteType.hsv:
      case PaletteType.hsvWithHue:
        return HSVWithHueColorPainter(currentHsvColor);
      case PaletteType.hsvWithSaturation:
        return HSVWithSaturationColorPainter(currentHsvColor);
      case PaletteType.hsvWithValue:
        return HSVWithValueColorPainter(currentHsvColor);
      case PaletteType.hsl:
      case PaletteType.hslWithHue:
        return HSLWithHueColorPainter(hsvToHsl(currentHsvColor));
      case PaletteType.hslWithSaturation:
        return HSLWithSaturationColorPainter(hsvToHsl(currentHsvColor));
      case PaletteType.hslWithLightness:
        return HSLWithLightnessColorPainter(hsvToHsl(currentHsvColor));
      case PaletteType.rgbWithRed:
        return RGBWithRedColorPainter(currentHsvColor.toColor());
      case PaletteType.rgbWithGreen:
        return RGBWithGreenColorPainter(currentHsvColor.toColor());
      case PaletteType.rgbWithBlue:
        return RGBWithBlueColorPainter(currentHsvColor.toColor());
      default:
        return HSVWithHueColorPainter(currentHsvColor);
    }
  }

  Widget sliderByPaletteType() {
    TrackType trackType;
    switch (widget.paletteType) {
      case PaletteType.hsv:
      case PaletteType.hsvWithHue:
      case PaletteType.hsl:
      case PaletteType.hslWithHue:
        trackType = TrackType.hue;
        break;
      case PaletteType.hsvWithValue:
        trackType = TrackType.value;
        break;
      case PaletteType.hsvWithSaturation:
        trackType = TrackType.saturation;
        break;
      case PaletteType.hslWithLightness:
        trackType = TrackType.lightness;
        break;
      case PaletteType.hslWithSaturation:
        trackType = TrackType.saturationForHSL;
        break;
      case PaletteType.rgbWithBlue:
        trackType = TrackType.blue;
        break;
      case PaletteType.rgbWithGreen:
        trackType = TrackType.green;
        break;
      case PaletteType.rgbWithRed:
        trackType = TrackType.red;
        break;
      default:
        return const SizedBox();
    }
    return buildColorPickerSlider(
      trackType,
      displayThumbColor: widget.displayThumbColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context, widget.portraitOnly)) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: widget.colorPickerWidth,
            height: widget.colorPickerWidth * widget.pickerAreaHeightPercent,
            child: colorPicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: addToHistory,
                  child: ColorIndicator(currentHsvColor),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: widget.colorPickerWidth - 75.0,
                        child: sliderByPaletteType(),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: 40.0,
                          width: widget.colorPickerWidth - 75.0,
                          child: buildColorPickerSlider(
                            TrackType.alpha,
                            displayThumbColor: widget.displayThumbColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (colorHistory.isNotEmpty)
            SizedBox(
              width: widget.colorPickerWidth,
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (Color color in colorHistory)
                    Padding(
                      key: Key(color.hashCode.toString()),
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>
                              onColorChanging(HSVColour.fromColor(color)),
                          child: ColorIndicator(
                            HSVColour.fromColor(color),
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          if (widget.showLabel && widget.labelTypes.isNotEmpty)
            FittedBox(child: ColourLabel(currentHsvColor.toColour())),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: widget.colorPickerWidth,
            height: widget.colorPickerWidth * widget.pickerAreaHeightPercent,
            child: colorPicker(),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: addToHistory,
                    child: ColorIndicator(currentHsvColor),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: 260.0,
                        child: sliderByPaletteType(),
                      ),
                      if (widget.enableAlpha)
                        SizedBox(
                          height: 40.0,
                          width: 260.0,
                          child: buildColorPickerSlider(
                            TrackType.alpha,
                            displayThumbColor: widget.displayThumbColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
              if (colorHistory.isNotEmpty)
                SizedBox(
                  width: widget.colorPickerWidth,
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (Color color in colorHistory)
                        Padding(
                          key: Key(color.hashCode.toString()),
                          padding: const EdgeInsets.fromLTRB(15, 18, 0, 0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () =>
                                  onColorChanging(HSVColour.fromColor(color)),
                              onLongPress: () => removeFromHistory(color),
                              child: ColorIndicator(
                                HSVColour.fromColor(color),
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              if (widget.showLabel && widget.labelTypes.isNotEmpty)
                FittedBox(child: ColourLabel(currentHsvColor.toColour())),
            ],
          ),
        ],
      );
    }
  }
}
