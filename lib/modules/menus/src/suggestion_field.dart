part of '../menus.dart';

class SuggestionField extends StatefulWidget {
  final double height;
  final double width;
  final List<dynamic> items;
  final Colour colour;

  const SuggestionField({
    super.key,
    required this.height,
    required this.width,
    required this.items,
    required this.colour,
  });

  @override
  State<SuggestionField> createState() => _SuggestionFieldState();
}

class _SuggestionFieldState extends State<SuggestionField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Row(
        children: [
          SizedBox(
            height: widget.height,
            width: widget.width * 0.75,
            child: TextField(controller: _controller),
          ),
          MenuDropDown(
            height: widget.height,
            width: widget.width * 0.25,
            colour: widget.colour,
            size: 16,
            items: widget.items,
            onSelected: (value) {
              _controller.text = value.toString();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
