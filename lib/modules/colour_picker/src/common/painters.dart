part of '../../colour_picker.dart';

/// Paints a checkerboard pattern, commonly used as a transparency background.
///
/// The checkerboard tile size is calculated as 1/6 of the available height,
/// alternating between light grey (`#CCCCCC`) and white. This is the
/// standard visual cue that lets users see what the alpha channel of a
/// colour actually looks like.
class CheckerPainter extends CustomPainter {
  const CheckerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.height / 6, size.height / 6);
    Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
    Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.width * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// A circular swatch that previews the current colour.
///
/// Draws a checkerboard background behind a filled circle so that semi-
/// transparent colours are clearly visible. Used in pickers to show the
/// currently selected colour or items in the colour history strip.
class ColorIndicator extends StatelessWidget {
  const ColorIndicator(
    this.hsvColor, {
    super.key,
    this.width = 50.0,
    this.height = 50.0,
  });

  final HSVColour hsvColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
        border: Border.all(color: const Color(0xffdddddd)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(1000.0)),
        child: CustomPaint(painter: IndicatorPainter(hsvColor.toColor())),
      ),
    );
  }
}

/// Painter that renders a checkerboard background with a solid colour circle
/// on top — the canvas-level implementation behind [ColorIndicator].
class IndicatorPainter extends CustomPainter {
  const IndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.width / 10, size.height / 10);
    final Paint chessPaintB = Paint()..color = const Color(0xFFCCCCCC);
    final Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.height * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints the gradient track for a [ColourPickerSlider].
///
/// The gradient rendered depends on the [trackType]:
///
/// | Track Type       | Gradient                                    |
/// |------------------|---------------------------------------------|
/// | hue              | Full rainbow (0-360 degrees)                 |
/// | saturation       | Desaturated → fully saturated at current hue |
/// | saturationForHSL | Same range but in HSL space                  |
/// | value            | Black → full brightness at current hue        |
/// | lightness        | Black → pure colour → white                  |
/// | red / green / blue | 0 → 255 for that channel                  |
/// | alpha            | Transparent → opaque (over a checkerboard)   |
class TrackPainter extends CustomPainter {
  const TrackPainter(this.trackType, this.hsvColor);

  final TrackType trackType;
  final HSVColour hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    if (trackType == TrackType.alpha) {
      final Size chessSize = Size(size.height / 2, size.height / 2);
      Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
      Paint chessPaintW = Paint()..color = Colors.white;
      List.generate((size.height / chessSize.height).round(), (int y) {
        List.generate((size.width / chessSize.width).round(), (int x) {
          canvas.drawRect(
            Offset(chessSize.width * x, chessSize.width * y) & chessSize,
            (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
          );
        });
      });
    }

    switch (trackType) {
      case TrackType.hue:
        final List<Color> colors = [
          const HSVColour.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
          const HSVColour.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturation:
        final List<Color> colors = [
          HSVColour.fromAHSV(1.0, hsvColor.hue, 0.0, 1.0).toColor(),
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.saturationForHSL:
        final List<Color> colors = [
          HSLColour.fromAHSL(1.0, hsvColor.hue, 0.0, 0.5).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColour(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.value:
        final List<Color> colors = [
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 0.0).toColor(),
          HSVColour.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.lightness:
        final List<Color> colors = [
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.0).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 0.5).toColour(),
          HSLColour.fromAHSL(1.0, hsvColor.hue, 1.0, 1.0).toColour(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.red:
        final List<Color> colors = [
          hsvColor.toColor().withRed(0).withOpacity(1.0),
          hsvColor.toColor().withRed(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.green:
        final List<Color> colors = [
          hsvColor.toColor().withGreen(0).withOpacity(1.0),
          hsvColor.toColor().withGreen(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.blue:
        final List<Color> colors = [
          hsvColor.toColor().withBlue(0).withOpacity(1.0),
          hsvColor.toColor().withBlue(255).withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.alpha:
        final List<Color> colors = [
          hsvColor.toColor().withOpacity(0.0),
          hsvColor.toColor().withOpacity(1.0),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints the draggable thumb indicator for a [ColourPickerSlider].
///
/// Renders a white circle with a drop shadow. When [thumbColor] is provided,
/// an inner circle is filled with that colour to preview the slider's current
/// position. Set [fullThumbColor] to `true` to fill the entire thumb rather
/// than just the inner 65%.
class ThumbPainter extends CustomPainter {
  const ThumbPainter({this.thumbColor, this.fullThumbColor = false});

  final Color? thumbColor;
  final bool fullThumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      Path()..addOval(
        Rect.fromCircle(
          center: const Offset(0.5, 2.0),
          radius: size.width * 1.8,
        ),
      ),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
      Offset(0.0, size.height * 0.4),
      size.height,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    if (thumbColor != null) {
      canvas.drawCircle(
        Offset(0.0, size.height * 0.4),
        size.height * (fullThumbColor ? 1.0 : 0.65),
        Paint()
          ..color = thumbColor!
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
