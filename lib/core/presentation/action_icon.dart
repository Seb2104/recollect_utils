part of '../../recollect_utils.dart';

/// A compact, tooltip-enabled icon button with built-in active/disabled states.
///
/// [ActionIcon] is designed for toolbar-style UIs where you need a small
/// icon that responds to taps, shows a tooltip on hover, and visually
/// communicates whether it's currently active or disabled — all without
/// writing boilerplate.
///
/// ## Example
///
/// ```dart
/// ActionIcon(
///   icon: Icons.format_bold,
///   tooltip: 'Bold',
///   isActive: isBold,
///   onTap: () => toggleBold(),
/// )
/// ```
///
/// ## Visual Behaviour
///
/// - **Default** — The icon is rendered at 75% opacity.
/// - **Active** — A subtle sage-coloured background and border appear.
/// - **Disabled** — The icon fades to 40% opacity and ignores taps.
/// - **Hover** — An ink-splash effect using the current theme's hover colour.
class ActionIcon extends StatefulWidget {
  /// Creates an [ActionIcon] button.
  ///
  /// [icon] and [tooltip] are required. Everything else is optional.
  const ActionIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.enabled = true,
    this.isActive = false,
  });

  /// The icon glyph to display (e.g. `Icons.format_bold`).
  final IconData icon;

  /// The tooltip message shown on hover/long-press.
  final String tooltip;

  /// Called when the user taps the icon. Ignored when [enabled] is `false`.
  final VoidCallback? onTap;

  /// Whether this icon button is interactive. Defaults to `true`.
  final bool enabled;

  /// Whether this icon is in its "active" visual state (highlighted
  /// background). Defaults to `false`.
  final bool isActive;

  @override
  State<ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<ActionIcon> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Tooltip(
          message: widget.tooltip,
          preferBelow: false,
          waitDuration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            color: AppTheme.textPrimary(context),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            color: AppTheme.background(context),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.enabled ? widget.onTap : null,
              borderRadius: BorderRadius.circular(10),
              hoverColor: AppTheme.hover(context),
              splashColor: AppTheme.primarySage.withValues(alpha: 0.1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.isActive
                      ? AppTheme.primarySage.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: widget.isActive
                      ? Border.all(
                          color: AppTheme.primarySage.withValues(alpha: 0.3),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: 17,
                  color: widget.enabled
                      ? (widget.isActive
                            ? AppTheme.primarySage
                            : AppTheme.textPrimary(
                                context,
                              ).withValues(alpha: 0.75))
                      : AppTheme.textSecondary(context).withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
