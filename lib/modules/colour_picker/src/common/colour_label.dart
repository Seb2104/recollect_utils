part of '../../colour_picker.dart';

/// A dropdown-driven colour value display that lets the user switch between
/// output formats on the fly.
///
/// Shows the current colour's value as text, with a [Menu] dropdown to pick
/// which format to display:
///
/// | Format | Example Output        |
/// |--------|-----------------------|
/// | b256   | 4-char base-256 string|
/// | HEX    | `FFFF0000`            |
/// | aRGB   | `255,255,0,0`         |
/// | HSL    | `1.0,0.0,1.0,0.5`    |
/// | HSV    | `1.0,120.0,1.0,0.8`  |
///
/// Used internally by the colour picker widgets to show the selected
/// colour's numeric representation.
class ColourLabel extends StatefulWidget {
  final Colour colour;
  final double height;
  final double width;

  const ColourLabel(
    this.colour, {
    super.key,
    this.height = 140,
    this.width = 300,
  });

  @override
  State<ColourLabel> createState() => _ColourLabelState();
}

class _ColourLabelState extends State<ColourLabel> {
  String b256() => widget.colour.b256;

  String hexView() => widget.colour.hex;

  String argbView() => widget.colour.argb;

  String hslView() => widget.colour.hsl.toString();

  String hsvView() => widget.colour.hsv.toString();

  String selectedFormat = 'b256';

  @override
  void initState() {
    super.initState();
  }

  String getViewForFormat(String format) {
    switch (format) {
      case 'b256':
        return b256();
      case 'hex':
        return hexView();
      case 'argb':
        return argbView();
      case 'hsl':
        return hslView();
      case 'hsv':
        return hsvView();
      default:
        return b256();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          Menu(
            height: 40,
            width: 100,
            // value: selectedFormat,
            items: [
              MenuItem(label: 'b256', value: 'b256'),
              MenuItem(label: 'HEX', value: 'hex'),
              MenuItem(label: 'aRGB', value: 'argb'),
              MenuItem(label: 'HSL', value: 'hsl'),
              MenuItem(label: 'HSV', value: 'hsv'),
            ],
          ),
          Spacer(),
          Word(getViewForFormat(selectedFormat), fontSize: 14),
        ],
      ),
    );
  }
}
