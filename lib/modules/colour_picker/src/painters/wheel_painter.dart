part of '../../colour_picker.dart';


/// Paints the full colour wheel for [WheelPicker].
///
/// Three layers are composited to create the wheel:
///
/// 1. A [SweepGradient] fills a circle with the full hue spectrum.
/// 2. A [RadialGradient] from white to transparent reduces saturation
///    toward the centre.
/// 3. A black overlay with opacity `(1 - value)` controls brightness.
///
/// A small circle pointer is drawn at the position corresponding to the
/// current hue (angle) and saturation (distance from centre). The pointer
/// colour automatically switches between white and black for readability.
class HUEColorWheelPainter extends CustomPainter {
  const HUEColorWheelPainter(this.hsvColour, {this.pointerColor});

  final HSVColour hsvColour;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = size.width <= size.height ? size.width / 2 : size.height / 2;

    final List<Color> colors = [
      const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    ];
    final Gradient gradientS = SweepGradient(colors: colors);
    const Gradient gradientR = RadialGradient(
      colors: [Colors.white, Color(0x00FFFFFF)],
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..shader = gradientS.createShader(rect),
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..shader = gradientR.createShader(rect),
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()..color = Colors.black.withOpacity(1 - hsvColour.value),
    );

    canvas.drawCircle(
      Offset(
        center.dx +
            hsvColour.saturation * radio * cos((hsvColour.hue * pi / 180)),
        center.dy -
            hsvColour.saturation * radio * sin((hsvColour.hue * pi / 180)),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColour.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
