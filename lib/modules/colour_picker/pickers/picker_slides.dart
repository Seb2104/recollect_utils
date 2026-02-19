part of '../colour_picker.dart';

/// A slider-based colour picker that breaks colour into individual channels.
///
/// Depending on the selected [colorModel], three or four sliders are shown:
///
/// | Model | Sliders                    |
/// |-------|----------------------------|
/// | RGB   | Red, Green, Blue (+Alpha)  |
/// | HSV   | Hue, Saturation, Value (+Alpha) |
/// | HSL   | Hue, Saturation, Lightness (+Alpha) |
///
/// An optional comparison indicator shows the original colour beside the
/// currently selected colour so users can see the difference at a glance.
///
/// This widget is not typically created directly — use
/// [ColourPicker.slides] instead.
class SlidePicker extends StatefulWidget {
  const SlidePicker({
    super.key,
    required this.currentColour,
    required this.onColorChanged,
    this.colorModel = ColorModel.rgb,
    this.enableAlpha = true,
    this.sliderSize = const Size(260, 40),
    this.showSliderText = true,
    this.sliderTextStyle,
    this.showParams = true,
    this.showLabel = true,
    this.labelTypes = const [],
    this.labelTextStyle,
    this.showIndicator = true,
    this.indicatorSize = const Size(280, 50),
    this.indicatorAlignmentBegin = const Alignment(-1.0, -3.0),
    this.indicatorAlignmentEnd = const Alignment(1.0, 3.0),
    this.displayThumbColor = true,
    this.indicatorBorderRadius = const BorderRadius.all(Radius.zero),
  });

  final Color currentColour;
  final ValueChanged<Color> onColorChanged;
  final ColorModel colorModel;
  final bool enableAlpha;
  final Size sliderSize;
  final bool showSliderText;
  final TextStyle? sliderTextStyle;
  final bool showLabel;
  final bool showParams;
  final List<ColorLabelType> labelTypes;
  final TextStyle? labelTextStyle;
  final bool showIndicator;
  final Size indicatorSize;
  final AlignmentGeometry indicatorAlignmentBegin;
  final AlignmentGeometry indicatorAlignmentEnd;
  final bool displayThumbColor;
  final BorderRadius indicatorBorderRadius;

  @override
  State<StatefulWidget> createState() => _SlidePickerState();
}

class _SlidePickerState extends BaseColourPicker<SlidePicker> {
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

  Widget colorPickerSlider(TrackType trackType) {
    return buildColorPickerSlider(
      trackType,
      displayThumbColor: widget.displayThumbColor,
    );
  }

  Widget indicator() {
    return ClipRRect(
      borderRadius: widget.indicatorBorderRadius,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () {
          setState(
            () => currentHsvColor = HSVColour.fromColor(widget.currentColour),
          );
          widget.onColorChanged(currentHsvColor.toColor());
        },
        child: Container(
          width: widget.indicatorSize.width,
          height: widget.indicatorSize.height,
          margin: const EdgeInsets.only(bottom: 15.0),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.currentColour,
                widget.currentColour,
                currentHsvColor.toColor(),
                currentHsvColor.toColor(),
              ],
              begin: widget.indicatorAlignmentBegin,
              end: widget.indicatorAlignmentEnd,
            ),
          ),
        ),
      ),
    );
  }

  String getColorParams(int pos) {
    assert(pos >= 0 && pos < 4);
    if (widget.colorModel == ColorModel.rgb) {
      final Color color = currentHsvColor.toColor();
      return [
        color.red.toString(),
        color.green.toString(),
        color.blue.toString(),
        '${(color.opacity * 100).round()}',
      ][pos];
    } else if (widget.colorModel == ColorModel.hsv) {
      return [
        currentHsvColor.hue.round().toString(),
        (currentHsvColor.saturation * 100).round().toString(),
        (currentHsvColor.value * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else if (widget.colorModel == ColorModel.hsl) {
      HSLColour hslColor = hsvToHsl(currentHsvColor);
      return [
        hslColor.hue.round().toString(),
        (hslColor.saturation * 100).round().toString(),
        (hslColor.lightness * 100).round().toString(),
        (currentHsvColor.alpha * 100).round().toString(),
      ][pos];
    } else {
      return '??';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = widget.labelTextStyle?.fontSize ?? 14;

    final List<TrackType> trackTypes = [
      if (widget.colorModel == ColorModel.hsv) ...[
        TrackType.hue,
        TrackType.saturation,
        TrackType.value,
      ],
      if (widget.colorModel == ColorModel.hsl) ...[
        TrackType.hue,
        TrackType.saturationForHSL,
        TrackType.lightness,
      ],
      if (widget.colorModel == ColorModel.rgb) ...[
        TrackType.red,
        TrackType.green,
        TrackType.blue,
      ],
      if (widget.enableAlpha) ...[TrackType.alpha],
    ];
    List<SizedBox> sliders = [
      for (TrackType trackType in trackTypes)
        SizedBox(
          width: widget.sliderSize.width,
          height: widget.sliderSize.height,
          child: Row(
            children: <Widget>[
              if (widget.showSliderText)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    trackType.toString().split('.').last[0].toUpperCase(),
                    style:
                        widget.sliderTextStyle ??
                        Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              Expanded(child: colorPickerSlider(trackType)),
              if (widget.showParams)
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: fontSize * 2 + 5),
                  child: Text(
                    getColorParams(trackTypes.indexOf(trackType)),
                    style:
                        widget.sliderTextStyle ??
                        Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.showIndicator) indicator(),
        if (!widget.showIndicator) const SizedBox(height: 20),
        ...sliders,
        const SizedBox(height: 20.0),
        if (widget.showLabel && widget.labelTypes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ColourLabel(currentHsvColor.toColour()),
          ),
      ],
    );
  }
}
