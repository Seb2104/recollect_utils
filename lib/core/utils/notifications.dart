part of '../../recollect_utils.dart';

/// A singleton toast-notification system that renders animated overlay
/// messages in the top-right corner of the screen.
///
/// Notifications slide in from the right, stack vertically, and auto-dismiss
/// after a configurable duration. They're backed by Flutter's [Overlay], so
/// they float above all other widgets.
///
/// ## Quick Usage
///
/// The easiest way to show notifications is through the [BuildContext]
/// extension methods:
///
/// ```dart
/// context.notify('Saved successfully');
/// context.warn('Disk space is low');
/// context.fail('Upload failed');
/// ```
///
/// ## Direct API
///
/// ```dart
/// NotificationManager().show(
///   context: context,
///   message: 'Custom notification',
///   type: NotificationType.info,
///   duration: Duration(seconds: 5),
/// );
/// ```
///
/// ## Auto-Dismiss
///
/// - **Error** notifications stay for 5 seconds by default.
/// - All other types stay for 3 seconds.
/// - Pass a custom [Duration] to override.
class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  /// Returns the singleton [NotificationManager] instance.
  factory NotificationManager() => _instance;

  NotificationManager._internal();

  OverlayEntry? _overlayEntry;
  final List<NotificationData> _notifications = [];
  final GlobalKey<NotificationOverlayState> _overlayKey = GlobalKey();

  /// Displays a toast notification with the given [message].
  ///
  /// The [type] controls the visual style (though the current implementation
  /// uses a uniform dark style). The notification auto-dismisses after
  /// [duration], which defaults to 3 seconds for info/warning and 5 seconds
  /// for errors.
  void show({
    required BuildContext context,
    required String message,
    NotificationType type = NotificationType.info,
    Duration? duration,
  }) {
    final notification = NotificationData(
      id: Moment.now().millisecondsSinceEpoch.toString(),
      message: message,
      type: type,
    );
    _notifications.add(notification);

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => NotificationOverlay(
          key: _overlayKey,
          notifications: _notifications,
          onDismiss: _removeNotification,
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayKey.currentState?.updateNotifications(_notifications);
    }

    final autoDismissDuration =
        duration ??
        (type == NotificationType.error
            ? const Duration(seconds: 5)
            : const Duration(seconds: 3));

    Future.delayed(autoDismissDuration, () {
      _removeNotification(notification.id);
    });
  }

  void _removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);

    if (_notifications.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayKey.currentState?.updateNotifications(_notifications);
    }
  }

  /// Immediately removes all active notifications and cleans up the overlay.
  void clear() {
    _notifications.clear();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// The overlay widget that renders the stacked notification cards.
///
/// You shouldn't need to use this directly — [NotificationManager] creates
/// and manages it for you.
class NotificationOverlay extends StatefulWidget {
  final List<NotificationData> notifications;
  final Function(String) onDismiss;

  const NotificationOverlay({
    super.key,
    required this.notifications,
    required this.onDismiss,
  });

  @override
  State<NotificationOverlay> createState() => NotificationOverlayState();
}

class NotificationOverlayState extends State<NotificationOverlay>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    for (final notification in widget.notifications) {
      if (!_controllers.containsKey(notification.id)) {
        final controller = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        final animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

        _controllers[notification.id] = controller;
        _animations[notification.id] = animation;
        controller.forward();
      }
    }
  }

  void updateNotifications(List<NotificationData> notifications) {
    setState(() {
      final currentIds = notifications.map((n) => n.id).toSet();
      final toRemove = _controllers.keys
          .where((id) => !currentIds.contains(id))
          .toList();

      for (final id in toRemove) {
        _controllers[id]?.dispose();
        _controllers.remove(id);
        _animations.remove(id);
      }

      _initializeAnimations();
    });
  }

  void _dismissNotification(String id) {
    final controller = _controllers[id];
    if (controller != null) {
      controller.reverse().then((_) {
        widget.onDismiss(id);
      });
    } else {
      widget.onDismiss(id);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widget.notifications.asMap().entries.map((entry) {
          final notification = entry.value;
          final animation = _animations[notification.id];

          if (animation == null) return const SizedBox.shrink();

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(300 * (1 - animation.value), 0),
                child: Opacity(
                  opacity: animation.value,
                  child: GestureDetector(
                    onTap: () => _dismissNotification,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        padding: const EdgeInsets.all(16),
                        margin: entry.key != 0
                            ? EdgeInsets.symmetric(vertical: 4)
                            : EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                child: Word(
                                  notification.message,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

/// The severity level of a notification, used to control auto-dismiss
/// duration and (potentially) visual styling.
enum NotificationType {
  /// A positive outcome (e.g. "File saved").
  success,

  /// Something went wrong (e.g. "Upload failed"). Stays visible longer.
  error,

  /// Neutral information (e.g. "3 items selected").
  info,

  /// A non-critical heads-up (e.g. "Disk space is low").
  warning,
}

/// Internal data model for a single notification.
///
/// Each notification gets a unique [id] (based on the current epoch
/// milliseconds) and a [timestamp] recording when it was created.
class NotificationData {
  /// A unique identifier for this notification.
  final String id;

  /// The text content displayed to the user.
  final String message;

  /// The severity type of this notification.
  final NotificationType type;

  /// When this notification was created.
  final Moment timestamp;

  /// Creates a [NotificationData] and records the current time.
  NotificationData({
    required this.id,
    required this.message,
    required this.type,
  }) : timestamp = Moment.now();
}
