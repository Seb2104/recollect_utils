part of '../../recollect_utils.dart';

/// Convenience extension on [BuildContext] for showing toast-style
/// notifications without wiring up a [NotificationManager] yourself.
///
/// These methods let you fire off a notification in a single line from
/// anywhere you have access to a `BuildContext`:
///
/// ```dart
/// context.notify('File saved successfully');
/// context.warn('Disk space is running low');
/// context.fail('Upload failed — please try again');
/// ```
///
/// Under the hood, each method delegates to [NotificationManager.show]
/// with the appropriate [NotificationType].
extension NotificationExtension on BuildContext {
  /// Shows an **informational** toast notification with the given [message].
  ///
  /// Optionally pass a [duration] to control how long the toast stays
  /// visible. If omitted, the [NotificationManager]'s default is used.
  void notify(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.info,
      duration: duration,
    );
  }

  /// Shows a **warning** toast notification with the given [message].
  ///
  /// Use this for non-critical issues the user should be aware of.
  void warn(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.warning,
      duration: duration,
    );
  }

  /// Shows an **error** toast notification with the given [message].
  ///
  /// Use this when something has gone wrong and the user needs to know.
  void fail(String message, {Duration? duration}) {
    NotificationManager().show(
      context: this,
      message: message,
      type: NotificationType.error,
      duration: duration,
    );
  }
}
