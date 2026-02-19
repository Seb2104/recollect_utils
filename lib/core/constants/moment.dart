part of '../../recollect_utils.dart';

const List<String> defaultFormatStyle = [
  The,
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
];

const String slash = '/';
const String dash = '-';
const String dot = '.';
const String comma = ',';
const String space = ' ';
const String backSlash = '\\';
const String colon = ':';
const String semicolon = ';';
const String at = 'at';
const String of = 'of';
const String the = 'the';
const String At = 'At';
const String Of = 'Of';
const String The = 'The';
const Map<int, String> weekDayNames = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const Map<int, String> monthNames = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

// --------------------------------------SECONDS------------------------------------ \\

/// # [Second]
/// ---
/// **Format:** `0 1 ... 58 59`
///
/// > **Summary:** The raw numerical second of the minute.
///
/// **Details:** Used for countdowns or high-precision logging where
/// leading zeros are not required for the specific string output.
const String s = 's';

/// # [Second (Long)]
/// ---
/// **Format:** `00 01 ... 58 59`
///
/// > **Summary:** A two-digit, zero-padded representation of seconds.
///
/// **Details:** The standard format for media players and stopwatches.
/// It ensures that the "seconds" column remains consistent as the
/// time increments.
const String ss = 'ss';

// --------------------------------------MINUTES------------------------------------ \\
/// # [Minute]
/// ---
/// **Format:** `0 1 ... 58 59`
///
/// > **Summary:** The raw numerical minute of the hour.
///
/// **Details:** Returns the minute without any padding. While less recollect_utils
/// in digital clocks, it is frequently used in natural language strings
/// like "Arrived 5 minutes ago."
const String m = 'm';

/// # [Minute (Long)]
/// ---
/// **Format:** `00 01 ... 58 59`
///
/// > **Summary:** The minute of the hour with leading zeros.
///
/// **Details:** Ensures that the minute always appears as two digits.
/// This is the universal standard for time display; single-digit
/// minutes (like 5:5) are generally considered incorrect in time displays.
const String mm = 'mm';

// --------------------------------------HOURS------------------------------------ \\

/// # [Hour (12-Hour Clock)]
/// ---
/// **Format:** `1 2 ... 11 12`
///
/// > **Summary:** The hour of the day in a 12-hour cycle.
///
/// **Details:** This format is the standard for civilian time. It
/// translates 00:00 to 12 and 13:00 to 1. Usually paired with the
/// AM/PM token for clarity.
const String h = 'h';

/// # [Hour (12-Hour Clock, Full)]
/// ---
/// **Format:** `01 02 ... 11 12`
///
/// > **Summary:** The hour of the day in a 12-hour cycle with a leading zero.
///
/// **Details:** Similar to the `h` token, but ensures a two-digit output.
/// This is preferred in UI design for digital clocks to prevent the
/// alignment of the time from shifting when the hour changes from 9 to 10.
const String hh = 'hh';

/// # [Hour (24-Hour Clock)]
/// ---
/// **Format:** `0 1 ... 22 23`
///
/// > **Summary:** The hour of the day in military/international time.
///
/// **Details:** This uses the 0-23 index, where 0 represents midnight.
/// It is the standard for backend logging, data storage, and international
/// systems where AM/PM ambiguity must be avoided.
const String H = 'H';

/// # [Hour (24-Hour Clock, Padded)]
/// ---
/// **Format:** `00 01 ... 22 23`
///
/// > **Summary:** The zero-padded hour of the day in 24-hour format.
///
/// **Details:** The standard format for ISO-8601 time representations.
/// It provides a consistent two-character width for all hours of the day,
/// making it ideal for table columns and file timestamps.
const String HH = 'HH';

/// # [AM/PM]
/// ---
/// **Format:** `AM PM`
///
/// > **Summary:** The meridiem indicator in uppercase.
///
/// **Details:** Used to differentiate between morning and afternoon
/// when using the 12-hour clock system. Essential for scheduling and
/// alarm-based features.
const String A = 'A';

/// # [AM/PM (Lowercase)]
/// ---
/// **Format:** `am pm`
///
/// > **Summary:** The meridiem indicator in lowercase.
///
/// **Details:** A stylistic alternative to the `A` token. It is often
/// used in modern, minimalist web design or mobile apps where a less
/// prominent "am/pm" indicator is desired.
const String a = 'a';

// --------------------------------------DAYS------------------------------------ \\
/// # [Day of Month]
/// ---
/// **Format:** `1 2 ... 30 31`
///
/// > **Summary:** The raw numerical day of the current month.
///
/// **Details:** This returns the day as a single or double digit without
/// any leading zeros. It is typically used in sentences (e.g., "March 5")
/// or in layouts where a clean, minimal look is desired.
const String D = 'D';

/// # [Day of Month (Ordinal)]
/// ---
/// **Format:** `1st 2nd ... 30th 31st`
///
/// > **Summary:** The day of the month followed by its ordinal suffix.
///
/// **Details:** This converts the day number into its spoken-word equivalent
/// format. It is essentially the standard for invitations, formal
/// letters, and any interface attempting to sound conversational.
const String Do = 'Do';

/// # [Day of Week (Short)]
/// ---
/// **Format:** `Mon Tue ... Sat Sun`
///
/// > **Summary:** The standard three-letter abbreviation for the day.
///
/// **Details:** This provides a balance between readability and space
/// efficiency. It is the most recollect_utils format used in digital dashboards
/// and general scheduling software to identify the day of the week.
const String ddd = 'ddd';

/// # [Day of Week (Full)]
/// ---
/// **Format:** `Monday Tuesday ... Sunday`
///
/// > **Summary:** The complete, unabbreviated name of the day.
///
/// **Details:** Use this for formal displays and primary headers.
/// It provides the highest level of clarity and is preferred for
/// desktop layouts and formal documents where space is not a constraint.
const String dddd = 'dddd';

/// # [Day of Month (Padded)]
/// ---
/// **Format:** `01 02 ... 30 31`
///
/// > **Summary:** A two-digit, zero-padded day of the month.
///
/// **Details:** This ensures that the day always occupies two characters.
/// This is required for fixed-width layouts and digital clock displays
/// where jumping text widths would be visually distracting.
const String DD = 'DD';

// --------------------------------------MONTHS------------------------------------ \\

/// # [Month (Number)]
/// ---
/// **Format:** `1 2 ... 11 12`
///
/// > **Summary:** The numerical index of the month.
///
/// **Details:** Represents the month in a non-padded format. 1 maps to
/// January and 12 maps to December. This is ideal for compact
/// date-picker logic or simple slash-separated date formats.
const String M = 'M';

/// # [Month (Ordinal)]
/// ---
/// **Format:** `1st 2nd ... 11th 12th`
///
/// > **Summary:** The numerical index of the month's position and order.
///
/// **Details:** Represents the month in a non-padded format. 1 maps to
/// January and 12 maps to December. This is ideal for compact
/// date-picker logic or simple slash-separated date formats.
const String Mo = 'Mo';

/// # [Month (Padded)]
/// ---
/// **Format:** `01 02 ... 11 12`
///
/// > **Summary:** A two-digit, zero-padded numerical month.
///
/// **Details:** Ensures that the month value is always two digits long.
/// This is the standard for numerical date formats like MM/DD/YYYY.
const String MM = 'MM';

/// # [Month (Short)]
/// ---
/// **Format:** `Jan Feb ... Nov Dec`
///
/// > **Summary:** The three-letter abbreviation of the month name.
///
/// **Details:** A culturally universal way to shorten month names while
/// maintaining high readability. It is used extensively in list views
/// and timeline markers.
const String MMM = 'MMM';

/// # [Month (Full)]
/// ---
/// **Format:** `January February ... December`
///
/// > **Summary:** The full name of the month.
///
/// **Details:** Provides the complete string for the month. This is the
/// most formal way to represent the month and is the foundation for
/// long-form date formatting.
const String mmmm = 'MMMM';
// --------------------------------------YEARS------------------------------------ \\

/// # [Year (Short)]
/// ---
/// **Format:** `70 71 ... 24 25`
///
/// > **Summary:** The last two digits of the year.
///
/// **Details:** Provides a truncated version of the year. While useful for
/// informal dates or space-restricted UI, it should be used cautiously
/// to avoid ambiguity between centuries.
const String yy = 'yy';

/// # [Year (Full)]
/// ---
/// **Format:** `1970 1971 ... 2024 2025`
///
/// > **Summary:** The complete four-digit year.
///
/// **Details:** The absolute numerical representation of the year.
const String yyyy = 'yyyy';
// --------------------------------------TEMPLATES------------------------------------ \\

/// # [Time (24-Hour)]
/// ---
/// **Format:** `14:35:22`
///
/// > **Summary:** A complete time string in 24-hour format.
///
/// **Details:** Outputs the full time as `hour:minute:second` using the
/// 24-hour clock. This is a convenient shorthand for displaying complete
/// timestamps in logs, data exports, or anywhere military time is preferred.
const String t = 't';

/// # [Time (12-Hour)]
/// ---
/// **Format:** `2:35:22 PM`
///
/// > **Summary:** A complete time string in 12-hour format with AM/PM.
///
/// **Details:** Outputs the full time as `hour:minute:second AM/PM` using the
/// 12-hour clock. Converts hour values accordingly (e.g., 0 becomes 12, 13
/// becomes 1) and appends the meridiem indicator for civilian time display.
const String T = 'T';

/// # [Date (Numeric)]
/// ---
/// **Format:** `05/03/2025`
///
/// > **Summary:** A complete date string in DD/MM/YYYY format.
///
/// **Details:** Outputs the full date with zero-padded day and month values
/// separated by slashes. This is the standard format for international date
/// display and is widely used in forms, reports, and date pickers.
const String dateNumeric = 'DDDD';
