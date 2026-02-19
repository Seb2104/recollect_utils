part of '../../colour_picker.dart';

/// Paints the hue ring for [HueRingPicker].
///
/// Draws a circular stroke using a [SweepGradient] that cycles through all
/// 360 degrees of hue. A thumb (white circle with optional colour fill)
/// is positioned at the angle corresponding to the current [hsvColor.hue].
///
/// The [strokeWidth] controls the thickness of the ring. Hit testing limits
/// interaction to the annular region between 70% and 130% of the radius,
/// so taps in the centre or far outside the ring are ignored.
class HueRingPainter extends CustomPainter {
  const HueRingPainter(
    this.hsvColor, {
    this.displayThumbColor = true,
    this.strokeWidth = 5,
  });

  final HSVColour hsvColor;
  final bool displayThumbColor;
  final double strokeWidth;

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
    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..shader = SweepGradient(colors: colors).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final Offset offset = Offset(
      center.dx + radio * cos((hsvColor.hue * pi / 180)),
      center.dy - radio * sin((hsvColor.hue * pi / 180)),
    );
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: offset, radius: 12)),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
      offset,
      size.height * 0.04,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    if (displayThumbColor) {
      canvas.drawCircle(
        offset,
        size.height * 0.03,
        Paint()
          ..color = hsvColor.toColor()
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool hitTest(Offset position) {
    final dist =
        sqrt(pow(position.dx - 0.5, 2) + pow(position.dy - 0.5, 2)) * 2;
    return dist > 0.7 && dist < 1.3;
  }
}
