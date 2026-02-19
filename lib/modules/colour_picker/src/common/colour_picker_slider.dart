part of '../../colour_picker.dart';

/// A single-axis colour slider for one channel of a colour model.
///
/// Renders a gradient track appropriate for the given [trackType] (hue,
/// saturation, value, lightness, red, green, blue, or alpha) and a
/// draggable thumb that reports colour changes through [onColorChanged].
///
/// The track gradient updates to reflect the current [hsvColor], so each
/// slider always shows the range of values that are available given the
/// other channels' current settings.
///
/// Set [displayThumbColor] to `true` to fill the thumb with the colour it
/// represents, or leave it `false` for a plain white thumb.
class ColourPickerSlider extends StatelessWidget {
  const ColourPickerSlider(
    this.trackType,
    this.hsvColor,
    this.onColorChanged, {
    super.key,
    this.displayThumbColor = false,
    this.fullThumbColor = false,
  });

  final TrackType trackType;
  final HSVColour hsvColor;
  final ValueChanged<HSVColour> onColorChanged;
  final bool displayThumbColor;
  final bool fullThumbColor;

  void slideEvent(RenderBox getBox, BoxConstraints box, Offset globalPosition) {
    double localDx = getBox.globalToLocal(globalPosition).dx - 15.0;
    double progress =
        localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0);
    switch (trackType) {
      case TrackType.hue:
        onColorChanged(hsvColor.withHue(progress * 359));
        break;
      case TrackType.saturation:
        onColorChanged(hsvColor.withSaturation(progress));
        break;
      case TrackType.saturationForHSL:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withSaturation(progress)));
        break;
      case TrackType.value:
        onColorChanged(hsvColor.withValue(progress));
        break;
      case TrackType.lightness:
        onColorChanged(hslToHsv(hsvToHsl(hsvColor).withLightness(progress)));
        break;
      case TrackType.red:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor.toColor().withRed((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.green:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor.toColor().withGreen((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.blue:
        onColorChanged(
          HSVColour.fromColor(
            hsvColor.toColor().withBlue((progress * 0xff).round()),
          ),
        );
        break;
      case TrackType.alpha:
        onColorChanged(
          hsvColor
              .withAlpha(
                localDx.clamp(0.0, box.maxWidth - 30.0) / (box.maxWidth - 30.0),
              )
              .toHSVColour,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        double thumbOffset = 15.0;
        Color thumbColor;
        switch (trackType) {
          case TrackType.hue:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.hue / 360;
            thumbColor = HSVColour.fromAHSV(
              1.0,
              hsvColor.hue,
              1.0,
              1.0,
            ).toColor();
            break;
          case TrackType.saturation:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.saturation;
            thumbColor = HSVColour.fromAHSV(
              1.0,
              hsvColor.hue,
              hsvColor.saturation,
              1.0,
            ).toColor();
            break;
          case TrackType.saturationForHSL:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvToHsl(hsvColor).saturation;
            thumbColor = HSLColour.fromAHSL(
              1.0,
              hsvColor.hue,
              hsvToHsl(hsvColor).saturation,
              0.5,
            ).toColour();
            break;
          case TrackType.value:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.value;
            thumbColor = HSVColour.fromAHSV(
              1.0,
              hsvColor.hue,
              1.0,
              hsvColor.value,
            ).toColor();
            break;
          case TrackType.lightness:
            thumbOffset += (box.maxWidth - 30.0) * hsvToHsl(hsvColor).lightness;
            thumbColor = HSLColour.fromAHSL(
              1.0,
              hsvColor.hue,
              1.0,
              hsvToHsl(hsvColor).lightness,
            ).toColour();
            break;
          case TrackType.red:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().red / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.green:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().green / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.blue:
            thumbOffset +=
                (box.maxWidth - 30.0) * hsvColor.toColor().blue / 0xff;
            thumbColor = hsvColor.toColor().withOpacity(1.0);
            break;
          case TrackType.alpha:
            thumbOffset += (box.maxWidth - 30.0) * hsvColor.toColor().opacity;
            thumbColor = hsvColor.toColor().withOpacity(hsvColor.alpha);
            break;
        }

        return CustomMultiChildLayout(
          delegate: SliderLayout(),
          children: <Widget>[
            LayoutId(
              id: SliderLayout.track,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                child: CustomPaint(painter: TrackPainter(trackType, hsvColor)),
              ),
            ),
            LayoutId(
              id: SliderLayout.thumb,
              child: Transform.translate(
                offset: Offset(thumbOffset, 0.0),
                child: CustomPaint(
                  painter: ThumbPainter(
                    thumbColor: displayThumbColor ? thumbColor : null,
                    fullThumbColor: fullThumbColor,
                  ),
                ),
              ),
            ),
            LayoutId(
              id: SliderLayout.gestureContainer,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints box) {
                  RenderBox? getBox = context.findRenderObject() as RenderBox?;
                  return GestureDetector(
                    onPanDown: (DragDownDetails details) => getBox != null
                        ? slideEvent(getBox, box, details.globalPosition)
                        : null,
                    onPanUpdate: (DragUpdateDetails details) => getBox != null
                        ? slideEvent(getBox, box, details.globalPosition)
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
