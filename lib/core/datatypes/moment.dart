// ignore_for_file: recollect_utilsion_methods_unrelated_type

part of '../../recollect_utils.dart';

/// A rich, human-friendly wrapper around date and time values.
///
/// [Moment] gives you everything Dart's [DateTime] does — and then some.
/// It supports flexible formatting with token-based patterns, relative time
/// strings ("3 hours ago"), arithmetic with [Period] objects, and convenient
/// accessors for common display formats.
///
/// ## Creating a Moment
///
/// ```dart
/// // From right now
/// final now = Moment.now();
///
/// // From individual components
/// final birthday = Moment(year: 1999, month: 12, date: 25, hour: 8);
///
/// // From an existing DateTime
/// final converted = Moment.fromDateTime(DateTime.utc(2025, 1, 1));
///
/// // By parsing a string (format: "yyyy/MM/dd-HH:mm:ss")
/// final parsed = Moment.parse(string: '2025/06/15-14:30:00');
/// ```
///
/// ## Formatting
///
/// Build any date/time string you need using format tokens:
///
/// ```dart
/// final m = Moment.now();
/// m.format(formatStyle: [dddd, comma, space, mmmm, space, D, comma, space, yyyy]);
/// // → "Wednesday, February 19, 2026"
/// ```
///
/// See the token constants ([D], [Do], [DD], [M], [MM], [MMM], [mmmm],
/// [yy], [yyyy], [h], [hh], [H], [HH], [m], [mm], [s], [ss], [A], [a])
/// for a full list of available format tokens.
///
/// ## Relative Time
///
/// ```dart
/// final posted = Moment(year: 2026, month: 2, date: 19, hour: 10);
/// print(posted.timeAgo());       // "3 hours ago"
/// print(posted.timeAgo(short: true)); // "3h"
/// ```
///
/// ## Arithmetic
///
/// Add or subtract [Period] values to move through time:
///
/// ```dart
/// final nextWeek = Moment.now() + Period(days: 7);
/// final lastMonth = Moment.now() - Period(months: 1);
/// ```
///
/// ## Comparison
///
/// [Moment] implements [Comparable] and supports all comparison operators:
///
/// ```dart
/// if (deadline > Moment.now()) print('Still time!');
/// ```
final class Moment implements Comparable<Moment> {
  /// The second component (0-59), or `null` if not specified.
  int? second;

  /// The minute component (0-59), or `null` if not specified.
  int? minute;

  /// The hour component (0-23), or `null` if not specified.
  int? hour;

  /// The day-of-month component (1-31), or `null` if not specified.
  int? date;

  /// The month component (1-12), or `null` if not specified.
  int? month;

  /// The year component (e.g. `2026`), or `null` if not specified.
  int? year;

  /// The token sequence used by [format] to produce a formatted string.
  ///
  /// Defaults to [defaultFormatStyle], which produces output like:
  /// `"The 19th of February 2026 at 14:35:00"`
  List<String> formatStyle;

  /// Creates a [Moment] from individual date/time components.
  ///
  /// Any component you omit stays `null` and will be treated as its
  /// zero/default value when used in calculations.
  Moment({
    this.second,
    this.minute,
    this.hour,
    this.date,
    this.month,
    this.year,
    this.formatStyle = defaultFormatStyle,
  });

  /// Creates a [Moment] from an existing [DateTime] instance.
  Moment.fromDateTime(DateTime dateTime)
    : year = dateTime.year,
      second = dateTime.second,
      minute = dateTime.minute,
      hour = dateTime.hour,
      date = dateTime.day,
      month = dateTime.month,
      formatStyle = defaultFormatStyle;

  /// Parses a [Moment] from a string in the format `"yyyy/MM/dd-HH:mm:ss"`.
  ///
  /// Throws if the string doesn't match the expected pattern. For a
  /// non-throwing alternative, see [tryParse].
  ///
  /// ```dart
  /// final m = Moment.parse(string: '2025/06/15-14:30:00');
  /// ```
  static Moment parse({required String string}) {
    var split1 = string.split('-');
    var dates = split1[0].split('/');
    var times = split1[1].split(':');
    return Moment(
      year: int.parse(dates[0]),
      month: int.parse(dates[1]),
      date: int.parse(dates[2]),
      hour: int.parse(times[0]),
      minute: int.parse(times[1]),
      second: int.parse(times[2]),
    );
  }

  /// Attempts to parse a [Moment] from [string], returning `null` on failure.
  ///
  /// If parsing fails (or [string] is `null`), the [onException] callback is
  /// invoked with the caught exception and its return value is used instead.
  static Moment? tryParse(String? string, {dynamic onException}) {
    try {
      if (string == null) {
        throw Exception('value is null');
      }
      return Moment.parse(string: string);
    } catch (e) {
      return onException(e);
    }
  }

  /// Creates a [Moment] representing the current date and time.
  ///
  /// This is the most common entry point — equivalent to
  /// `Moment.fromDateTime(DateTime.now())`.
  static Moment now() {
    return Moment.fromDateTime(DateTime.now());
  }

  /// Converts this [Moment] to a standard Dart [DateTime].
  ///
  /// Any `null` components default to their zero value (year defaults to
  /// the current year, month/date default to 1, time fields default to 0).
  DateTime get dateTime => DateTime(
    year ?? DateTime.now().year,
    month ?? 1,
    date ?? 1,
    hour ?? 0,
    minute ?? 0,
    second ?? 0,
  );

  /// Returns a new [Moment] advanced forward by [period].
  ///
  /// ```dart
  /// final nextWeek = Moment.now() + Period(days: 7);
  /// ```
  Moment operator +(Period period) {
    DateTime dt = dateTime.add(Duration(microseconds: period._period));
    return Moment.fromDateTime(dt);
  }

  /// Returns a new [Moment] moved backward by [period].
  ///
  /// ```dart
  /// final lastMonth = Moment.now() - Period(months: 1);
  /// ```
  Moment operator -(Period period) {
    DateTime dt = dateTime.subtract(Duration(microseconds: period._period));
    return Moment.fromDateTime(dt);
  }

  /// Alias for the `+` operator. Returns a new [Moment] shifted by [period].
  Moment addPeriod(Period period) => this + period;

  /// Returns `true` if this moment comes before [other] chronologically.
  bool operator <(Moment other) => totalSeconds < other.totalSeconds;

  /// Returns `true` if this moment is at or before [other].
  bool operator <=(Moment other) => totalSeconds <= other.totalSeconds;

  /// Returns `true` if this moment comes after [other] chronologically.
  bool operator >(Moment other) => totalSeconds > other.totalSeconds;

  /// Returns `true` if this moment is at or after [other].
  bool operator >=(Moment other) => totalSeconds >= other.totalSeconds;

  /// Returns the components as a list: `[second, minute, hour, date, month, year]`.
  List toList() => [second, minute, hour, date, month, year];

  /// Constructs a [Moment] from a map with string keys.
  Moment fromMap(Map<String, dynamic> map) {
    return Moment(
      second: map[second],
      minute: map[minute],
      hour: map[hour],
      date: map[date],
      month: map[month],
      year: map[year],
      formatStyle: const [
        the,
        space,
        Do,
        space,
        of,
        space,
        mmmm,
        space,
        yyyy,
        space,
        at,
        space,
        hh,
        colon,
        mm,
        colon,
        ss,
      ],
    );
  }

  /// Serializes this [Moment] to a `Map<String, dynamic>`.
  Map<String, dynamic> get asMap => {
    second.toString(): second ?? 0.0,
    minute.toString(): minute ?? 0.0,
    hour.toString(): hour ?? 0.0,
    date.toString(): date ?? 0.0,
    month.toString(): month ?? 0.0,
    year.toString(): year ?? 0.0,
  };

  /// Converts the time portion of this [Moment] into a [Period].
  ///
  /// Only the hour, minute, and second values are included — date components
  /// are zeroed out. Useful when you just care about "how much time" this
  /// represents, not "which date."
  Period get period => Period(
    seconds: second ?? 0,
    minutes: minute ?? 0,
    hours: hour ?? 0,
    days: 0,
    months: 0,
    years: 0,
  );

  /// The total number of seconds from the Unix epoch (1970-01-01) to this
  /// [Moment].
  ///
  /// Negative values represent dates before the epoch. This is the primary
  /// value used for all comparisons and ordering.
  int get totalSeconds {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;
    int h = hour ?? 0;
    int min = minute ?? 0;
    int s = second ?? 0;

    int totalDays = 0;

    if (y >= 1970) {
      for (int yr = 1970; yr < y; yr++) {
        totalDays += _isLeapYear(yr) ? 366 : 365;
      }
    } else {
      for (int yr = 1969; yr >= y; yr--) {
        totalDays -= _isLeapYear(yr) ? 366 : 365;
      }
    }

    for (int mn = 1; mn < m; mn++) {
      totalDays += _daysInMonth(mn, y);
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400 + h * 3600 + min * 60 + s;

    return totalSeconds;
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int _daysInMonth(int month, int year) {
    const monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && _isLeapYear(year)) return 29;
    return monthDays[month - 1];
  }

  /// Returns the absolute difference between this [Moment] and [other] as a
  /// [Period].
  ///
  /// The result is always positive regardless of which moment comes first.
  ///
  /// ```dart
  /// final gap = Moment.now().difference(birthday);
  /// print(gap); // e.g. "26 years, 2 months, ..."
  /// ```
  Period difference(Moment other) {
    int totalSecs = totalSeconds - other.totalSeconds;
    totalSecs = totalSecs.abs();

    int secs = totalSecs % 60;
    int totalMins = totalSecs ~/ 60;
    int mins = totalMins % 60;
    int totalHrs = totalMins ~/ 60;
    int hrs = totalHrs % 24;
    int days = totalHrs ~/ 24;

    int yrs = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    remainingDays = remainingDays % 30;

    return Period(
      years: yrs,
      months: months,
      days: remainingDays,
      hours: hrs,
      minutes: mins,
      seconds: secs,
    );
  }

  /// Returns a human-readable string describing how long ago (or from now)
  /// this [Moment] is relative to [from] (defaults to [Moment.now]).
  ///
  /// When [short] is `true`, units are abbreviated (`3h` instead of
  /// `3 hours`). Future moments get an "in" prefix; past moments get
  /// an "ago" suffix.
  ///
  /// ```dart
  /// final posted = Moment(year: 2026, month: 2, date: 19, hour: 10);
  /// print(posted.timeAgo());             // "5 hours, 30 minutes ago"
  /// print(posted.timeAgo(short: true));   // "5h 30m"
  /// ```
  String timeAgo({Moment? from, bool short = false}) {
    Moment reference = from ?? Moment.now();
    int totalSecs = reference.totalSeconds - totalSeconds;
    bool isFuture = totalSecs < 0;
    totalSecs = totalSecs.abs();

    int secs = totalSecs % 60;
    int totalMins = totalSecs ~/ 60;
    int mins = totalMins % 60;
    int totalHrs = totalMins ~/ 60;
    int hrs = totalHrs % 24;
    int days = totalHrs ~/ 24;

    int yrs = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    remainingDays = remainingDays % 30;

    List<String> parts = [];

    if (yrs > 0) {
      String unit = short ? 'y' : (yrs == 1 ? ' year' : ' years');
      parts.add('$yrs$unit');
    }
    if (months > 0) {
      String unit = short ? 'mo' : (months == 1 ? ' month' : ' months');
      parts.add('$months$unit');
    }
    if (remainingDays > 0) {
      String unit = short ? 'd' : (remainingDays == 1 ? ' day' : ' days');
      parts.add('$remainingDays$unit');
    }
    if (hrs > 0) {
      String unit = short ? 'h' : (hrs == 1 ? ' hour' : ' hours');
      parts.add('$hrs$unit');
    }
    if (mins > 0) {
      String unit = short ? 'm' : (mins == 1 ? ' minute' : ' minutes');
      parts.add('$mins$unit');
    }
    if (secs > 0 || parts.isEmpty) {
      String unit = short ? 's' : (secs == 1 ? ' second' : ' seconds');
      parts.add('$secs$unit');
    }

    String result = parts.join(short ? ' ' : ', ');

    if (isFuture) {
      return 'in $result';
    } else {
      return short ? result : '$result ago';
    }
  }

  /// The ISO day of the week (1 = Monday, 7 = Sunday), or `null` if the
  /// date components are incomplete.
  ///
  /// Uses Zeller's congruence internally for the calculation.
  int? get weekday {
    if (date == null || month == null || year == null) return null;
    int y = year!;
    int m = month!;
    int d = date!;

    if (m < 3) {
      m += 12;
      y -= 1;
    }

    int yearOfCentury = y % 100;
    int zeroBasedCentury = y ~/ 100;

    int h =
        (d +
            (13 * (m + 1) ~/ 5) +
            yearOfCentury +
            (yearOfCentury ~/ 4) +
            (zeroBasedCentury ~/ 4) -
            (2 * zeroBasedCentury) +
            700) %
        7;

    return ((h + 5) % 7) + 1;
  }

  /// The time as a 24-hour string: `"HH:mm:ss"` (e.g. `"14:05:09"`).
  String get time {
    String h = (hour ?? 0).toString().padLeft(2, '0');
    String m = (minute ?? 0).toString().padLeft(2, '0');
    String s = (second ?? 0).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// The time as a short 24-hour string without seconds: `"HH:mm"`.
  String get shortTime {
    String h = (hour ?? 0).toString().padLeft(2, '0');
    String m = (minute ?? 0).toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// The time as a 12-hour clock string with AM/PM: `"2:05:09 PM"`.
  String get clock {
    int h = hour ?? 0;
    int hour12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    String m = (minute ?? 0).toString().padLeft(2, '0');
    String s = (second ?? 0).toString().padLeft(2, '0');
    return '$hour12:$m:$s $clockPhase';
  }

  /// The time as a short 12-hour string without seconds: `"2:05 PM"`.
  String get shortClock {
    int h = hour ?? 0;
    int hour12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    String m = (minute ?? 0).toString().padLeft(2, '0');
    return '$hour12:$m $clockPhase';
  }

  /// `"AM"` or `"PM"` based on the [hour] value.
  String get clockPhase => (hour ?? 0) < 12 ? 'AM' : 'PM';

  /// The historical era — `"AD"` for years >= 1, `"BC"` for years <= -1,
  /// or `null` for year 0.
  String? get era => year! >= 1
      ? 'AD'
      : year! <= -1
      ? 'BC'
      : null;

  /// Returns a [Moment] representing tomorrow at the current time.
  static Moment tomorrow() => ((Moment.now()) + Period(days: 1));

  /// Returns a [Moment] representing yesterday at the current time.
  static Moment yesterday() => ((Moment.now()) - Period(days: 1));

  String _getOrdinal(int? value) {
    String valString = value.toString();
    if (valString.length >= 2) {
      int trailingTwo = int.parse(
        value.toString().substring(valString.length - 2, valString.length),
      );
      if (trailingTwo == 11 || trailingTwo == 12 || trailingTwo == 13) {
        return 'th';
      }
    }
    int trailing = int.parse(value.toString()[value.toString().length - 1]);
    switch (trailing) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Builds a formatted date/time string by evaluating each token in
  /// [formatStyle] against this [Moment]'s values.
  ///
  /// Tokens that don't match a known format specifier are passed through
  /// as literal strings, so you can mix separators and text freely.
  ///
  /// ```dart
  /// final m = Moment.now();
  /// m.format(formatStyle: [dddd, comma, space, mmmm, space, D, comma, space, yyyy]);
  /// // → "Wednesday, February 19, 2026"
  /// ```
  String format({List<String>? formatStyle = defaultFormatStyle}) {
    String val = '';
    for (int i = 0; i < formatStyle!.length; i++) {
      val += formatToken(this, formatStyle[i]).toString();
    }
    return val;
  }

  /// Resolves a single format [token] into its string value for the
  /// given [moment].
  ///
  /// This powers the [format] method. You generally won't call it directly,
  /// but it's public so you can extend or override token behaviour.
  String? formatToken(Moment moment, String token) {
    switch (token) {
      case ddd:
        return weekDayNames[moment.weekday]!.substring(0, 3);
      case dddd:
        return weekDayNames[moment.weekday];
      case D:
        return moment.date.toString();
      case Do:
        return '${moment.date}${_getOrdinal(moment.date!)}';
      case DD:
        return moment.date.toString().padLeft(2, '0');
      case M:
        return moment.month.toString();
      case Mo:
        return '${moment.month}${_getOrdinal(moment.month)}';
      case MM:
        return moment.month.toString().padLeft(2, '0');
      case MMM:
        return monthNames[moment.month]!.substring(0, 3);
      case mmmm:
        return monthNames[moment.month];
      case yy:
        return moment.year.toString().substring(2);
      case yyyy:
        return moment.year.toString();
      case h:
        int hour12 = moment.hour! % 12;
        return hour12 == 0 ? '12' : hour12.toString();
      case hh:
        int hour12 = moment.hour! % 12;
        return (hour12 == 0 ? 12 : hour12).toString().padLeft(2, '0');
      case H:
        return moment.hour.toString();
      case HH:
        return moment.hour.toString().padLeft(2, '0');
      case m:
        return moment.minute.toString();
      case mm:
        return moment.minute.toString().padLeft(2, '0');
      case s:
        return moment.second.toString();
      case ss:
        return moment.second.toString().padLeft(2, '0');
      case A:
        return moment.clockPhase;
      case a:
        return moment.clockPhase.toLowerCase();
      case t:
        return '${moment.hour}:${moment.minute}:${moment.second}';
      case dateNumeric:
        return '${moment.date.toString().padLeft(2, '0')}/${moment.month.toString().padLeft(2, '0')}/$year';
      default:
        return token;
    }
  }

  /// Milliseconds since the Unix epoch (1970-01-01 00:00:00 UTC).
  ///
  /// Useful for interop with APIs that expect epoch timestamps.
  int get millisecondsSinceEpoch {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;

    int totalDays = 0;

    if (y >= 1970) {
      for (int i = 1970; i < y; i++) {
        totalDays += _isLeapYear(i) ? 366 : 365;
      }
    } else {
      for (int i = 1969; i >= y; i--) {
        totalDays -= _isLeapYear(i) ? 366 : 365;
      }
    }

    for (int i = 1; i < m; i++) {
      totalDays += _daysInMonth(i, y);
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400;
    totalSeconds += (hour ?? 0) * 3600;
    totalSeconds += (minute ?? 0) * 60;
    totalSeconds += (second ?? 0);

    return totalSeconds * 1000;
  }

  @override
  int compareTo(Moment other) {
    if (totalSeconds < other.totalSeconds) return -1;
    if (totalSeconds > other.totalSeconds) return 1;
    return 0;
  }

  @override
  int get hashCode => millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) {
    if (other is! Moment) return false;
    return totalSeconds == other.totalSeconds;
  }

  @override
  Type get runtimeType => Moment;

  @override
  String toString() => '$year/$month/$date-$hour:$minute:$second';

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      NoSuchMethodError.withInvocation(this, invocation);
}
