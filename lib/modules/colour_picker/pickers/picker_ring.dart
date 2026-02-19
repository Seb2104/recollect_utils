part of '../colour_picker.dart';

/// A hue ring colour picker with an inner saturation/value palette.
///
/// Displays a circular ring of the full hue spectrum. The user drags around
/// the ring to select a hue, then drags inside the inner square to adjust
/// saturation and value. Optionally includes an alpha slider.
///
/// Adapts between portrait and landscape layouts — in portrait the palette
/// and ring are stacked; in landscape they are placed side by side.
///
/// This widget is not typically created directly — use
/// [ColourPicker.ring] instead.
class HueRingPicker extends StatefulWidget {
  const HueRingPicker({
    super.key,
    required this.currentColour,
    required this.onColorChanged,
    this.portraitOnly = false,
    this.colorPickerHeight = 250.0,
    this.hueRingStrokeWidth = 20.0,
    this.enableAlpha = false,
    this.displayThumbColor = true,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.displayLabel = true,
  });

  final Color currentColour;
  final ValueChanged<Color> onColorChanged;
  final bool portraitOnly;
  final double colorPickerHeight;
  final double hueRingStrokeWidth;
  final bool enableAlpha;
  final bool displayThumbColor;
  final BorderRadius pickerAreaBorderRadius;
  final bool displayLabel;

  @override
  State<HueRingPicker> createState() => _HueRingPickerState();
}

class _HueRingPickerState extends BaseColourPicker<HueRingPicker> {
  @override
  Color getInitialColor() => widget.currentColour;

  @override
  HSVColour? getInitialHsvColor() => null;

  @override
  List<Color>? getColorHistory() => null;

  @override
  ValueChanged<List<Color>>? getHistoryChangedCallback() => null;

  @override
  void notifyColorChanged(HSVColour color) {
    widget.onColorChanged(color.toColor());
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context, widget.portraitOnly)) {
      return Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: widget.pickerAreaBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    width: widget.colorPickerHeight,
                    height: widget.colorPickerHeight,
                    child: HueRingGestureDetector(
                      onColorChanged: onColorChanging,
                      hsvColor: currentHsvColor,
                      child: CustomPaint(
                        painter: HueRingPainter(
                          currentHsvColor,
                          displayThumbColor: widget.displayThumbColor,
                          strokeWidth: widget.hueRingStrokeWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.colorPickerHeight / 1.6,
                    height: widget.colorPickerHeight / 1.6,
                    child: SimpleHSVGestureDetector(
                      onColorChanged: onColorChanging,
                      hsvColor: currentHsvColor,
                      child: CustomPaint(
                        painter: HSVWithHueColorPainter(currentHsvColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.enableAlpha)
            SizedBox(
              height: 40.0,
              width: widget.colorPickerHeight,
              child: buildColorPickerSlider(
                TrackType.alpha,
                displayThumbColor: widget.displayThumbColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                ColorIndicator(currentHsvColor),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ClipRRect(
            borderRadius: widget.pickerAreaBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: widget.colorPickerHeight * 0.4,
                height: widget.colorPickerHeight * 0.4,
                child: SimpleHSVGestureDetector(
                  onColorChanged: onColorChanging,
                  hsvColor: currentHsvColor,
                  child: CustomPaint(
                    painter: HSVWithHueColorPainter(currentHsvColor),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: widget.colorPickerHeight / 6),
              ColorIndicator(currentHsvColor),
            ],
          ),
          Column(
            children: [
              SizedBox(height: widget.colorPickerHeight / 8.5),
              SizedBox(
                height: 40.0,
                width: 200.0,
                child: buildColorPickerSlider(
                  TrackType.value,
                  displayThumbColor: true,
                ),
              ),
              if (widget.enableAlpha) const SizedBox(height: 5),
              if (widget.enableAlpha)
                SizedBox(
                  height: 40.0,
                  width: 200.0,
                  child: buildColorPickerSlider(
                    TrackType.alpha,
                    displayThumbColor: true,
                  ),
                ),
              if (widget.displayLabel)
                FittedBox(child: ColourLabel(currentHsvColor.toColour())),
            ],
          ),
          SizedBox(
            width: widget.colorPickerHeight - widget.hueRingStrokeWidth * 3,
            height: widget.colorPickerHeight - widget.hueRingStrokeWidth * 3,
            child: HueRingGestureDetector(
              onColorChanged: onColorChanging,
              hsvColor: currentHsvColor,
              child: CustomPaint(
                painter: HueRingPainter(
                  currentHsvColor,
                  strokeWidth: widget.hueRingStrokeWidth,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
