part of '../colour_picker.dart';

/// A circular colour wheel picker with value/alpha sliders.
///
/// The wheel maps the full hue spectrum around its circumference and
/// saturation from the centre outward. A draggable pointer lets the user
/// pick any hue/saturation combination, while separate sliders control
/// brightness (value) and opacity (alpha).
///
/// Supports both portrait (vertical) and landscape (horizontal) layouts,
/// controlled by [orientation]. In portrait mode the wheel sits above the
/// sliders; in landscape mode they sit side by side.
///
/// This widget is not typically created directly — use
/// [ColourPicker.wheel] instead.
class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.currentColour,
    required this.onColourChanged,
    required this.size,
    required this.style,
    required this.showLabel,
    required this.displayThumbColor,
    required this.orientation,

    this.pickerHsvColour,
    this.onHsvColourChanged,
    this.colourHistory,
    this.onHistoryChanged,
  });

  final double size;
  final Colour currentColour;
  final ValueChanged<Colour> onColourChanged;
  final HSVColour? pickerHsvColour;
  final ValueChanged<HSVColour>? onHsvColourChanged;
  final bool showLabel;
  final bool displayThumbColor;
  final Orientation orientation;
  final List<Colour>? colourHistory;
  final ValueChanged<List<Colour>>? onHistoryChanged;
  final PickerStyle style;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends BaseColourPicker<WheelPicker> {
  @override
  Color getInitialColor() => widget.currentColour;

  @override
  HSVColour? getInitialHsvColor() => widget.pickerHsvColour;

  @override
  List<Color>? getColorHistory() => widget.colourHistory?.cast<Color>();

  @override
  ValueChanged<List<Color>>? getHistoryChangedCallback() {
    if (widget.onHistoryChanged == null) return null;
    return (List<Color> colors) {
      widget.onHistoryChanged!(colors.cast<Colour>());
    };
  }

  @override
  void notifyColorChanged(HSVColour color) {
    widget.onColourChanged(color.toColour());
    if (widget.onHsvColourChanged != null) {
      widget.onHsvColourChanged!(color);
    }
  }

  void onColourChange(HSVColour colour) {
    widget.onColourChanged(colour.toColour());
    if (widget.onHsvColourChanged != null) {
      widget.onHsvColourChanged!(colour);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == Orientation.portrait) {
      return Container(
        height: widget.size,
        width: widget.size / 2,
        decoration: widget.style.decoration,
        padding: widget.style.padding,
        margin: widget.style.margin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size / 2,
              child: WheelGestureDetector(
                onColorChanged: onColorChanging,
                hsvColor: currentHsvColor,
                child: CustomPaint(
                  painter: HUEColorWheelPainter(currentHsvColor),
                ),
              ),
            ),
            Indicator(
              colour: currentHsvColor,
              size:
                  (widget.size / 2) -
                  widget.style.padding.along(Axis.horizontal),
              displayThumbColour: widget.displayThumbColor,
              onChanged: onColourChange,
              portrait: true,
            ),
            if (widget.showLabel) ColourLabel(currentHsvColor.toColour()),
          ],
        ),
      );
    } else {
      return Container(
        height: widget.size / 2,
        width: widget.size,
        decoration: widget.style.decoration,
        padding: widget.style.padding,
        margin: widget.style.margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height:
                  (widget.size / 2) - widget.style.padding.along(Axis.vertical),
              width:
                  (widget.size / 2) -
                  widget.style.padding.along(Axis.horizontal),
              child: WheelGestureDetector(
                onColorChanged: onColorChanging,
                hsvColor: currentHsvColor,
                child: CustomPaint(
                  painter: HUEColorWheelPainter(currentHsvColor),
                ),
              ),
            ),
            VerticalDivider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  colour: currentHsvColor,
                  size:
                      (widget.size / 2) -
                      (widget.style.padding.along(Axis.horizontal)).positive,
                  displayThumbColour: widget.displayThumbColor,
                  onChanged: onColourChange,
                  portrait: false,
                ),
                if (widget.showLabel)
                  ColourLabel(
                    width:
                        ((widget.size / 2) -
                                widget.style.padding.along(Axis.horizontal))
                            .positive,
                    currentHsvColor.toColour(),
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
