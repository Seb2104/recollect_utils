part of '../../recollect_utils.dart';

/// A builder function that receives the current hover state.
///
/// Return a different widget depending on whether [isHovering] is `true`
/// or `false`.
typedef BoolWidgetBuilder =
    Widget Function(BuildContext context, bool isHovering);

/// A simple wrapper that tracks whether the mouse is hovering over its
/// child and rebuilds via a [BoolWidgetBuilder].
///
/// Especially useful on web and desktop where hover states are a key part
/// of the interaction model. On mobile, the widget still works — it just
/// won't trigger unless a mouse is attached.
///
/// ```dart
/// HoverWidget(
///   builder: (context, isHovering) {
///     return Container(
///       color: isHovering ? Colors.blue.shade50 : Colors.white,
///       child: Text('Hover me!'),
///     );
///   },
/// )
/// ```
class HoverWidget extends StatefulWidget {
  /// The builder that receives the hover state and returns the child widget.
  final BoolWidgetBuilder builder;

  /// Whether the [MouseRegion] is opaque to hit testing. Defaults to `true`.
  final bool? opaque;

  /// Creates a [HoverWidget] with the given [builder].
  const HoverWidget({required this.builder, this.opaque, super.key});

  @override
  HoverWidgetState createState() => HoverWidgetState();
}

class HoverWidgetState extends State<HoverWidget> {
  bool isHovering = false;

  void onEvent(bool value) {
    isHovering = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEvent(true),
      onExit: (event) => onEvent(false),
      onHover: (event) => onEvent(true),
      opaque: widget.opaque ?? true,
      child: widget.builder.call(context, isHovering),
    );
  }
}
