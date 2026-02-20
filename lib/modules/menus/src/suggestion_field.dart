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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Row(
        children: [
          MenuDropDown(
            height: widget.height,
            width: widget.width,
            colour: widget.colour,
            size: 16,
            items: widget.items,
            onSelected: (value) {

            },
          ),
        ],
      ),
    );
  }
}
