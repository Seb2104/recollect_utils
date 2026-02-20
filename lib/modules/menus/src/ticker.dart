part of '../menus.dart';

class Ticker extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Colour colour;

  const Ticker({
    super.key,
    this.height = 30,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.colour = const Colour(alpha: 255, red: 100, green: 100, blue: 100),
  });

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: widget.colour,
      ),
    );
  }
}
