part of '../../colour_picker.dart';


/// Paints an HSV palette where **hue is the free variable** (controlled by
/// an external slider).
///
/// The square gradient maps **saturation** along the X-axis (left = 0,
/// right = 1) and **value** along the Y-axis (top = 1, bottom = 0). A small
/// circle pointer marks the current colour position. The pointer colour
/// adapts between white and black for readability against the background.
class HSVWithHueColorPainter extends CustomPainter {
  const HSVWithHueColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.black],
    );
    final Gradient gradientH = LinearGradient(
      colors: [
        Colors.white,
        HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = gradientH.createShader(rect),
    );

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.saturation,
        size.height * (1 - hsvColor.value),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..blendMode = BlendMode.luminosity
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an HSV palette where **saturation is the free variable**.
///
/// Maps **hue** (0-360) along the X-axis and **value** (0-1) along the
/// Y-axis. A horizontal rainbow gradient at the current saturation level
/// is overlaid with a vertical transparent-to-black gradient.
class HSVWithSaturationColorPainter extends CustomPainter {
  const HSVWithSaturationColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    );
    final List<Color> colors = [
      HSVColour.fromAHSV(1.0, 0.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 60.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 120.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 180.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 240.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 300.0, hsvColor.saturation, 1.0).toColor(),
      HSVColour.fromAHSV(1.0, 360.0, hsvColor.saturation, 1.0).toColor(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.hue / 360,
        size.height * (1 - hsvColor.value),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an HSV palette where **value (brightness) is the free variable**.
///
/// Maps **hue** (0-360) along the X-axis and **saturation** (0-1) along the
/// Y-axis. A black overlay with opacity `(1 - value)` dims the palette to
/// reflect the current brightness level.
class HSVWithValueColorPainter extends CustomPainter {
  const HSVWithValueColorPainter(this.hsvColor, {this.pointerColor});

  final HSVColour hsvColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.white],
    );
    final List<Color> colors = [
      const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()..color = Colors.black.withOpacity(1 - hsvColor.value),
    );

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.hue / 360,
        size.height * (1 - hsvColor.saturation),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an HSL palette where **hue is the free variable**.
///
/// Maps **saturation** (0-1) along the X-axis and **lightness** (0-1) along
/// the Y-axis. A four-stop vertical gradient (white → transparent →
/// transparent → black) creates the characteristic HSL lightness ramp.
class HSLWithHueColorPainter extends CustomPainter {
  const HSLWithHueColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        const Color(0xff808080),
        HSLColour.fromAHSL(1.0, hslColor.hue, 1.0, 0.5).toColour(),
      ],
    );
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.white,
        Color(0x00ffffff),
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hslColor.saturation,
        size.height * (1 - hslColor.lightness),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an HSL palette where **saturation is the free variable**.
///
/// Maps **hue** (0-360) along the X-axis and **lightness** (0-1) along the
/// Y-axis. The horizontal rainbow is rendered at the current saturation,
/// with the same four-stop lightness overlay as [HSLWithHueColorPainter].
class HSLWithSaturationColorPainter extends CustomPainter {
  const HSLWithSaturationColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final List<Color> colors = [
      HSLColour.fromAHSL(1.0, 0.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 60.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 120.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 180.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 240.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 300.0, hslColor.saturation, 0.5).toColour(),
      HSLColour.fromAHSL(1.0, 360.0, hslColor.saturation, 0.5).toColour(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.white,
        Color(0x00ffffff),
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));

    canvas.drawCircle(
      Offset(
        size.width * hslColor.hue / 360,
        size.height * (1 - hslColor.lightness),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an HSL palette where **lightness is the free variable**.
///
/// Maps **hue** (0-360) along the X-axis and **saturation** (0-1) along the
/// Y-axis. Black and white overlays are applied with opacity derived from
/// the current lightness to simulate the effect of the lightness channel.
class HSLWithLightnessColorPainter extends CustomPainter {
  const HSLWithLightnessColorPainter(this.hslColor, {this.pointerColor});

  final HSLColour hslColor;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final List<Color> colors = [
      const HSLColour.fromAHSL(1.0, 0.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 60.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 120.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 180.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 240.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 300.0, 1.0, 0.5).toColour(),
      const HSLColour.fromAHSL(1.0, 360.0, 1.0, 0.5).toColour(),
    ];
    final Gradient gradientH = LinearGradient(colors: colors);
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Color(0xFF808080)],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.black.withOpacity(
          (1 - hslColor.lightness * 2).clamp(0, 1),
        ),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white.withOpacity(
          ((hslColor.lightness - 0.5) * 2).clamp(0, 1),
        ),
    );

    canvas.drawCircle(
      Offset(
        size.width * hslColor.hue / 360,
        size.height * (1 - hslColor.saturation),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(hslColor.toColour())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an RGB palette where **red is the free variable**.
///
/// Maps **blue** (0-255) along the X-axis and **green** (0-255) along the
/// Y-axis. Two linear gradients are blended with [BlendMode.multiply] to
/// produce the correct 2D colour field at the current red level.
class RGBWithRedColorPainter extends CustomPainter {
  const RGBWithRedColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(color.red, 255, 0, 1.0),
        Color.fromRGBO(color.red, 255, 255, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(color.red, 255, 255, 1.0),
        Color.fromRGBO(color.red, 0, 255, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.blue / 255,
        size.height * (1 - color.green / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an RGB palette where **green is the free variable**.
///
/// Maps **blue** (0-255) along the X-axis and **red** (0-255) along the
/// Y-axis, using multiply-blended gradients at the current green level.
class RGBWithGreenColorPainter extends CustomPainter {
  const RGBWithGreenColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(255, color.green, 0, 1.0),
        Color.fromRGBO(255, color.green, 255, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, color.green, 255, 1.0),
        Color.fromRGBO(0, color.green, 255, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.blue / 255,
        size.height * (1 - color.red / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an RGB palette where **blue is the free variable**.
///
/// Maps **red** (0-255) along the X-axis and **green** (0-255) along the
/// Y-axis, using multiply-blended gradients at the current blue level.
class RGBWithBlueColorPainter extends CustomPainter {
  const RGBWithBlueColorPainter(this.color, {this.pointerColor});

  final Color color;
  final Color? pointerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradientH = LinearGradient(
      colors: [
        Color.fromRGBO(0, 255, color.blue, 1.0),
        Color.fromRGBO(255, 255, color.blue, 1.0),
      ],
    );
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 255, color.blue, 1.0),
        Color.fromRGBO(255, 0, color.blue, 1.0),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientH.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = gradientV.createShader(rect)
        ..blendMode = BlendMode.multiply,
    );

    canvas.drawCircle(
      Offset(
        size.width * color.red / 255,
        size.height * (1 - color.green / 255),
      ),
      size.height * 0.04,
      Paint()
        ..color =
            pointerColor ??
            (useWhiteForeground(color) ? Colors.white : Colors.black)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
