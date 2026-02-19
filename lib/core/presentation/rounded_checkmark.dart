part of '../../recollect_utils.dart';

/// A circular, animated checkbox with an optional text label.
///
/// Unlike Flutter's built-in [Checkbox], this one is fully round and comes
/// with smooth colour transitions out of the box. It's a good fit for
/// task lists, settings toggles, or anywhere you want a friendlier check.
///
/// ## Example
///
/// ```dart
/// RoundedCheckBox(
///   isChecked: true,
///   text: 'I agree to the terms',
///   checkedColor: Colors.green,
///   onTap: (value) => print('Checked: $value'),
/// )
/// ```
///
/// ## Customisation
///
/// | Property            | What it controls                              |
/// |---------------------|-----------------------------------------------|
/// | [checkedColor]      | Fill colour when checked (default: green)     |
/// | [uncheckedColor]    | Fill colour when unchecked (default: null)     |
/// | [checkedWidget]     | Widget shown when checked (default: checkmark) |
/// | [uncheckedWidget]   | Widget shown when unchecked (default: empty)   |
/// | [size]              | Diameter of the circle (default: 24)           |
/// | [animationDuration] | Transition duration (default: 500ms)           |
/// | [text]              | Optional label displayed to the right          |
class RoundedCheckBox extends StatefulWidget {
  /// Creates a [RoundedCheckBox].
  const RoundedCheckBox({
    super.key,
    this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.disabledColor,
    this.border,
    this.borderColor,
    this.size,
    this.animationDuration,
    this.onTap,
    this.text = '',
    this.textStyle,
  });

  /// Whether the checkbox starts in a checked state. Defaults to `false`.
  final bool? isChecked;

  /// The widget displayed inside the circle when checked.
  /// Defaults to a white checkmark icon.
  final Widget? checkedWidget;

  /// The widget displayed inside the circle when unchecked.
  /// Defaults to an empty [SizedBox].
  final Widget? uncheckedWidget;

  /// The fill colour when the checkbox is checked. Defaults to green.
  final Color? checkedColor;

  /// The fill colour when unchecked. Defaults to transparent.
  final Color? uncheckedColor;

  /// The fill colour when the checkbox is disabled (not currently wired).
  final Color? disabledColor;

  /// An optional custom border around the circle.
  final Border? border;

  /// The border colour. Defaults to grey.
  final Color? borderColor;

  /// The diameter of the checkbox circle. Defaults to `24.0`.
  final double? size;

  /// An optional text label shown to the right of the checkbox.
  final String text;

  /// The [TextStyle] for the text label.
  final TextStyle? textStyle;

  /// Called when the user taps the checkbox. Receives the new checked state.
  final Function(bool?)? onTap;

  /// How long the checked/unchecked colour transition takes.
  /// Defaults to 500 milliseconds.
  final Duration? animationDuration;

  @override
  _RoundedCheckBoxState createState() => _RoundedCheckBoxState();
}

class _RoundedCheckBoxState extends State<RoundedCheckBox> {
  bool? isChecked;
  late Duration animationDuration;
  double? size;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  Color? checkedColor;
  Color? uncheckedColor;
  Color? disabledColor;
  late Color borderColor;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 24.0;
    checkedColor = widget.checkedColor ?? Colors.green;
    uncheckedColor = widget.uncheckedColor;
    borderColor = widget.borderColor ?? Colors.grey;
    checkedWidget =
        widget.checkedWidget ??
        Icon(Icons.check, color: Colors.white, size: size! - 6);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null
          ? () {
              setState(() => isChecked = !isChecked!);
              widget.onTap?.call(isChecked);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size! / 2),
            child: AnimatedContainer(
              duration: animationDuration,
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: isChecked! ? checkedColor : uncheckedColor,
                border: widget.border ?? Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(size! / 2),
              ),
              child: isChecked! ? checkedWidget! : uncheckedWidget!,
            ),
          ),
          if (widget.text.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8),
                Text(
                  widget.text,
                  style: widget.textStyle ?? AppTheme.baseTextStyle,
                ).flexible(),
              ],
            ).flexible(),
        ],
      ),
    );
  }
}
