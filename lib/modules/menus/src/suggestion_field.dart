part of '../menus.dart';

class SuggestionField extends StatefulWidget {
  final double height;
  final double width;
  final List<dynamic> items;
  final Function(dynamic value) onSelected;
  final BoxDecoration decoration;
  final AlignType alignDropdown;
  final TextAlign alignDropdownText;

  const SuggestionField({
    super.key,
    required this.items,
    required this.onSelected,
    this.height = 30,
    this.width = 100,
    this.decoration = const BoxDecoration(color: Colours.white),
    this.alignDropdown = AlignType.fill,
    this.alignDropdownText = TextAlign.left,
  });

  @override
  State<SuggestionField> createState() => _SuggestionFieldState();
}

class _SuggestionFieldState extends State<SuggestionField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration.copyWith(
        color: AppTheme.surface(context).colour,
      ),
      child: Row(
        children: [
          SizedBox(
            width: widget.width * 0.75,
            child: Center(
              child: TextField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colours.transparent,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hoverColor: Colours.transparent,
                  focusColor: Colours.transparent,
                ),
                controller: _controller,
                onSubmitted: (value) {
                  widget.onSelected.call(value);
                },
              ),
            ),
          ),
          MenuDropDown(
            height: widget.height,
            dropdownWidth: widget.width,
            width: widget.width * 0.25,
            iconSize: 16,
            items: widget.items,
            alignDropdown: widget.alignDropdown,
            alignText: widget.alignDropdownText,
            onSelected: (value) {
              _controller.text = value.toString();
              widget.onSelected.call(value.toString());
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
