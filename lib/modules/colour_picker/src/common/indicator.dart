part of '../../colour_picker.dart';

/// A compound indicator widget used by the wheel picker to display the
/// selected colour alongside value and alpha sliders.
///
/// Shows a [ColorIndicator] swatch next to two [ColourPickerSlider]s — one
/// for brightness (value) and one for opacity (alpha). Adapts its internal
/// layout for both portrait and landscape orientations while keeping the
/// same logical structure.
class Indicator extends StatefulWidget {
  final double size;
  final HSVColour colour;
  final bool displayThumbColour;
  final ValueChanged<HSVColour> onChanged;
  final bool portrait;

  const Indicator({
    super.key,
    required this.colour,
    required this.size,
    required this.displayThumbColour,
    required this.onChanged,
    required this.portrait,
  });

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    HSVColour currentHSVColour = widget.colour.toHSVColour;
    return widget.portrait
        ? SizedBox(
            width: widget.size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ColorIndicator(
                  currentHSVColour,
                  height: (widget.size / 2) * 0.3,
                  width: (widget.size / 2) * 0.3,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: (widget.size / 2) * 0.2,
                      width: widget.size * 0.85,
                      child: ColourPickerSlider(
                        TrackType.value,
                        currentHSVColour,
                        (colour) {
                          widget.onChanged(colour);
                        },
                        displayThumbColor: widget.displayThumbColour,
                      ),
                    ),
                    SizedBox(
                      height: (widget.size / 2) * 0.2,
                      width: widget.size * 0.85,
                      child: ColourPickerSlider(
                        TrackType.alpha,
                        currentHSVColour,
                        (colour) {
                          widget.onChanged(colour);
                        },
                        displayThumbColor: widget.displayThumbColour,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox(
            width: widget.size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ColorIndicator(
                  currentHSVColour,
                  height: (widget.size / 2) * 0.3,
                  width: (widget.size / 2) * 0.3,
                ),
                // Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: (widget.size / 2) * 0.2,
                      width: widget.size * 0.85,
                      child: ColourPickerSlider(
                        TrackType.value,
                        currentHSVColour,
                        (colour) {
                          widget.onChanged(colour);
                        },
                        displayThumbColor: widget.displayThumbColour,
                      ),
                    ),
                    SizedBox(
                      height: (widget.size / 2) * 0.2,
                      width: widget.size * 0.85,
                      child: ColourPickerSlider(
                        TrackType.alpha,
                        currentHSVColour,
                        (colour) {
                          widget.onChanged(colour);
                        },
                        displayThumbColor: widget.displayThumbColour,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
