part of '../../recollect_utils.dart';

/// A duration of time that understands human-scale units — including years
/// and months.
///
/// Dart's built-in [Duration] only works with fixed-length units (days, hours,
/// etc.). [Period] adds support for **years** and **months**, using
/// approximate lengths (365 days/year, 30 days/month) so you can express
/// things like "6 months" or "2 years" in a single object.
///
/// Internally, everything is stored as a total number of microseconds, which
/// keeps arithmetic simple and consistent.
///
/// ## Creating a Period
///
/// ```dart
/// final twoWeeks = Period(days: 14);
/// final halfYear = Period(months: 6);
/// final custom = Period(years: 1, months: 3, days: 15, hours: 8);
/// ```
///
/// ## Arithmetic
///
/// Periods support addition, subtraction, multiplication, and negation:
///
/// ```dart
/// final doubled = twoWeeks * 2;
/// final combined = halfYear + twoWeeks;
/// final inverted = -twoWeeks;
/// ```
///
/// ## Using with Moment
///
/// The primary use case is shifting [Moment] values forward or backward:
///
/// ```dart
/// final nextMonth = Moment.now() + Period(months: 1);
/// final lastYear = Moment.now() - Period(years: 1);
/// ```
class Period {
  @override
  String toString() => '$_period microseconds';

  /// The total duration stored as microseconds.
  final int _period;

  /// Internal constructor — creates a [Period] from a raw microsecond count.
  const Period._microseconds(int period) : _period = period + 0;

  /// Returns a new [Period] that is the sum of this and [other].
  Period operator +(Period other) {
    return Period._microseconds(_period + other._period);
  }

  /// Returns a new [Period] that is the difference of this and [other].
  Period operator -(Period other) {
    return Period._microseconds(_period - other._period);
  }

  /// Returns a new [Period] scaled by [factor].
  ///
  /// ```dart
  /// final tripled = Period(days: 7) * 3; // 21 days
  /// ```
  Period operator *(num factor) {
    return Period._microseconds((_period * factor).round());
  }

  /// Returns the negation of this period (flips the sign).
  Period operator -() => Period._microseconds(-_period);

  /// Returns the absolute (non-negative) version of this period.
  Period abs() => Period._microseconds(_period.abs());

  /// Returns `true` if this period is shorter than [other].
  bool operator <(Period other) => _period < other._period;

  /// Returns `true` if this period is longer than [other].
  bool operator >(Period other) => _period > other._period;

  /// Returns `true` if this period is shorter than or equal to [other].
  bool operator <=(Period other) => _period <= other._period;

  /// Returns `true` if this period is longer than or equal to [other].
  bool operator >=(Period other) => _period >= other._period;

  @override
  bool operator ==(Object other) {
    if (other is! Period) return false;
    return _period == other._period;
  }

  @override
  int get hashCode => _period.hashCode;

  /// Creates a [Period] from human-friendly units.
  ///
  /// All parameters default to `0`. You can combine them freely:
  ///
  /// ```dart
  /// Period(years: 1, months: 6)       // ~1.5 years
  /// Period(hours: 2, minutes: 30)     // 2.5 hours
  /// Period(days: 7)                   // one week
  /// ```
  ///
  /// Months are approximated as 30 days, and years as 365 days.
  const Period({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) : this._microseconds(
         microseconds +
             microsecondsPerMillisecond * milliseconds +
             microsecondsPerSecond * seconds +
             microsecondsPerMinute * minutes +
             microsecondsPerHour * hours +
             microsecondsPerDay * days +
             microsecondsPerDay * 30 * months +
             microsecondsPerDay * 365 * years,
       );

  // ---------------------------------------------------------------------------
  // Time Unit Conversion Constants
  // ---------------------------------------------------------------------------
  //
  // These let you convert between time units without magic numbers floating
  // around your code. They're also used internally for the Period constructor.
  // ---------------------------------------------------------------------------

  /// Microseconds in one millisecond (1,000).
  static const int microsecondsPerMillisecond = 1000;

  /// Milliseconds in one second (1,000).
  static const int millisecondsPerSecond = 1000;

  /// Seconds in one minute (60).
  static const int secondsPerMinute = 60;

  /// Minutes in one hour (60).
  static const int minutesPerHour = 60;

  /// Hours in one day (24).
  static const int hoursPerDay = 24;

  /// Microseconds in one second (1,000,000).
  static const int microsecondsPerSecond =
      microsecondsPerMillisecond * millisecondsPerSecond;

  /// Microseconds in one minute (60,000,000).
  static const int microsecondsPerMinute =
      microsecondsPerSecond * secondsPerMinute;

  /// Microseconds in one hour (3,600,000,000).
  static const int microsecondsPerHour = microsecondsPerMinute * minutesPerHour;

  /// Microseconds in one day (86,400,000,000).
  static const int microsecondsPerDay = microsecondsPerHour * hoursPerDay;

  /// Milliseconds in one minute (60,000).
  static const int millisecondsPerMinute =
      millisecondsPerSecond * secondsPerMinute;

  /// Milliseconds in one hour (3,600,000).
  static const int millisecondsPerHour = millisecondsPerMinute * minutesPerHour;

  /// Milliseconds in one day (86,400,000).
  static const int millisecondsPerDay = millisecondsPerHour * hoursPerDay;

  /// Seconds in one hour (3,600).
  static const int secondsPerHour = secondsPerMinute * minutesPerHour;

  /// Seconds in one day (86,400).
  static const int secondsPerDay = secondsPerHour * hoursPerDay;

  /// Minutes in one day (1,440).
  static const int minutesPerDay = minutesPerHour * hoursPerDay;

  /// Returns `true` if this period represents a negative duration (going
  /// backward in time).
  bool get isNegative => _period < 0;

  /// Converts this period into a [Moment] anchored at the Unix epoch
  /// (1970-01-01), effectively treating the stored microseconds as an
  /// absolute timestamp.
  ///
  /// This is most useful when you have a raw duration and want to decompose
  /// it into year/month/day/hour/minute/second components.
  Moment get moment {
    int totalMicroseconds = _period;
    int totalMilliseconds = totalMicroseconds ~/ microsecondsPerMillisecond;
    int totalSeconds = totalMilliseconds ~/ millisecondsPerSecond;
    int totalMinutes = totalSeconds ~/ secondsPerMinute;
    int totalHours = totalMinutes ~/ minutesPerHour;
    int totalDays = totalHours ~/ hoursPerDay;

    int sec = totalSeconds % secondsPerMinute;
    int min = totalMinutes % minutesPerHour;
    int hr = totalHours % hoursPerDay;

    int yr = 1970 + (totalDays ~/ 365);
    int remainingDays = totalDays % 365;
    int month = 1 + (remainingDays ~/ 30);
    int day = 1 + (remainingDays % 30);

    return Moment(
      year: yr,
      month: month,
      date: day,
      hour: hr,
      minute: min,
      second: sec,
    );
  }
}
