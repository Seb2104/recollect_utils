part of '../../recollect_utils.dart';

/// The Collect design system — a complete Material 3 theme built around
/// two signature colour palettes: **Sage** (a calm olive-green) and
/// **Terracotta** (a warm earthy tone).
///
/// [AppTheme] provides:
///
/// - Ready-to-use [ThemeData] for light and dark modes via [light] and [dark].
/// - Context-aware colour accessors (e.g. [textPrimary], [background]) that
///   automatically return the right value for the current brightness.
/// - A full set of semantic colour tokens for surfaces, borders, text
///   hierarchy, hover/focus states, and table styling.
///
/// ## Quick Start
///
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(),
///   darkTheme: AppTheme.dark(),
/// )
/// ```
///
/// ## Using Context-Aware Colours
///
/// ```dart
/// Container(
///   color: AppTheme.background(context),
///   child: Text(
///     'Hello',
///     style: TextStyle(color: AppTheme.textPrimary(context)),
///   ),
/// )
/// ```
///
/// ## Colour Palette
///
/// | Token                  | Hex       | Usage                          |
/// |------------------------|-----------|--------------------------------|
/// | [primarySage]          | `#9CAF88` | Primary actions, indicators    |
/// | [secondaryTerracotta]  | `#D4B5A0` | Secondary accents              |
/// | [accentGold]           | `#E6D5B8` | Success highlights             |
/// | [softCoral]            | `#E5C4B5` | Warnings                       |
/// | [accentError]          | `#D49490` | Error states                   |
/// | [lavenderMist]         | `#CBBFD4` | Tertiary accents               |
class AppTheme {
  /// The base text style inherited by the entire theme's text hierarchy.
  ///
  /// Uses Times New Roman as the primary font with a sensible set of
  /// fallbacks that covers Windows, macOS, Linux, and emoji rendering.
  static const TextStyle baseTextStyle = TextStyle(
    fontFamily: 'Times New Roman',
    fontSize: 12,
    fontFamilyFallback: [
      'Segoe UI',
      'Arial',
      'Helvetica',
      'sans-serif',
      'Noto Color Emoji',
      'Apple Color Emoji',
      'Segoe UI Emoji',
    ],
  );

  /// Returns the **light** mode [ThemeData].
  ///
  /// Built on Material 3 with the Sage/Terracotta palette, warm surface
  /// tones, and a full text theme derived from [baseTextStyle].
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primarySage,
        primaryContainer: Color(0xFFE8F0E5),
        secondary: secondaryTerracotta,
        secondaryContainer: Color(0xFFF5EDEA),
        tertiary: lavenderMist,
        tertiaryContainer: Color(0xFFF0EDF5),
        surface: lightSurface,
        surfaceContainerHighest: lightSurfaceVariant,
        error: accentError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
        outline: lightBorder,
        shadow: Color(0x1A3A3531),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x0A3A3531),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySage,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primarySage.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySage,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primarySage, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: lightTextTertiary),
        labelStyle: const TextStyle(color: lightTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 0.5,
        space: 0.5,
      ),
      textTheme: TextTheme(
        displayLarge: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 3.5,
        ),
        displayMedium: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.8,
        ),
        displaySmall: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.2,
        ),
        headlineLarge: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.0,
        ),
        headlineMedium: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.75,
        ),
        headlineSmall: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.5,
        ),
        titleLarge: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.375,
        ),
        titleMedium: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 1.125,
        ),
        titleSmall: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w400,
          fontSize: baseTextStyle.fontSize! * 1.125,
        ),
        bodyMedium: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: baseTextStyle.copyWith(
          color: lightTextSecondary,
          fontWeight: FontWeight.w400,
          fontSize: baseTextStyle.fontSize! * 0.875,
        ),
        labelLarge: baseTextStyle.copyWith(
          color: lightTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: baseTextStyle.copyWith(
          color: lightTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 0.875,
        ),
        labelSmall: baseTextStyle.copyWith(
          color: lightTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 0.75,
        ),
      ),
    );
  }

  /// Returns the **dark** mode [ThemeData].
  ///
  /// Uses deeper surface colours and lighter text to maintain readability
  /// while keeping the same Sage/Terracotta personality as the light theme.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primarySage,
        primaryContainer: Color(0xFF4D5E4A),
        secondary: secondaryTerracotta,
        secondaryContainer: Color(0xFF7D6359),
        tertiary: lavenderMist,
        tertiaryContainer: Color(0xFF6B6474),
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        error: accentError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onError: Colors.white,
        outline: darkBorder,
        shadow: Color(0x33000000),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x33000000),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySage,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: const Color(0x33000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySage,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primarySage, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
        labelStyle: const TextStyle(color: darkTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 3.5,
        ),
        displayMedium: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.8,
        ),
        displaySmall: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.2,
        ),
        headlineLarge: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 2.0,
        ),
        headlineMedium: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.75,
        ),
        headlineSmall: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.5,
        ),
        titleLarge: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: baseTextStyle.fontSize! * 1.375,
        ),
        titleMedium: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 1.125,
        ),
        titleSmall: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w400,
          fontSize: baseTextStyle.fontSize! * 1.125,
        ),
        bodyMedium: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: baseTextStyle.copyWith(
          color: darkTextSecondary,
          fontWeight: FontWeight.w400,
          fontSize: baseTextStyle.fontSize! * 0.875,
        ),
        labelLarge: baseTextStyle.copyWith(
          color: darkTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: baseTextStyle.copyWith(
          color: darkTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 0.875,
        ),
        labelSmall: baseTextStyle.copyWith(
          color: darkTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: baseTextStyle.fontSize! * 0.75,
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Context-Aware Colour Accessors
  // -----------------------------------------------------------------------
  //
  // Each of these inspects the current theme brightness and returns the
  // appropriate light or dark variant. Use these instead of hard-coding
  // colour constants — they'll adapt automatically when the user toggles
  // between light and dark mode.
  // -----------------------------------------------------------------------

  /// The semantic "success" colour. Currently [accentGold].
  static Color success(BuildContext context) => accentGold;

  /// The semantic "warning" colour. Currently [softCoral].
  static Color warning(BuildContext context) => softCoral;

  /// The semantic "error" colour. Currently [accentError].
  static Color error(BuildContext context) => accentError;

  /// The highest-contrast text colour for the current brightness.
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextPrimary
        : darkTextPrimary;
  }

  /// A medium-emphasis text colour for secondary content.
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }

  /// A low-emphasis text colour for hints, placeholders, and captions.
  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextTertiary
        : darkTextTertiary;
  }

  /// A surface colour for elevated containers (cards, dialogs).
  static Color surfaceElevated(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurfaceElevated
        : darkSurfaceElevated;
  }

  /// A very subtle border for low-contrast separation.
  static Color borderSubtle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorderSubtle
        : darkBorderSubtle;
  }

  /// The background tint applied on mouse hover.
  static Color hover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightHover
        : darkHover;
  }

  /// The background tint applied when a widget has keyboard/accessibility focus.
  static Color focus(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightFocus
        : darkFocus;
  }

  /// The standard border colour for the current brightness.
  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorder
        : darkBorder;
  }

  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurfaceVariant
        : darkSurfaceVariant;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSurface
        : darkSurface;
  }

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBackground
        : darkBackground;
  }

  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightDivider
        : darkDivider;
  }

  static Color tableCellBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellBackground
        : darkTableCellBackground;
  }

  static Color tableCellHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellHover
        : darkTableCellHover;
  }

  static Color tableCellFocus(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellFocus
        : darkTableCellFocus;
  }

  static Color tableCellSelected(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableCellSelected
        : darkTableCellSelected;
  }

  static Color tableHeaderBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableHeaderBackground
        : darkTableHeaderBackground;
  }

  static Color tableHeaderText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableHeaderText
        : darkTableHeaderText;
  }

  static Color tableBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableBorder
        : darkTableBorder;
  }

  static Color tableBorderHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableBorderHover
        : darkTableBorderHover;
  }

  static Color tableAlternateRow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableAlternateRow
        : darkTableAlternateRow;
  }

  static Color tableResizeHandle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableResizeHandle
        : darkTableResizeHandle;
  }

  static Color tableResizeHandleHover(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableResizeHandleHover
        : darkTableResizeHandleHover;
  }

  static Color tableShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTableShadow
        : darkTableShadow;
  }

  // -----------------------------------------------------------------------
  // Light Theme — Table Colours
  // -----------------------------------------------------------------------

  /// Default cell background in light mode.
  static const Color lightTableCellBackground = Color(0xFFFFFFFE);
  static const Color lightTableCellHover = Color(0xFFFAF7F3);
  static const Color lightTableCellFocus = Color(0xFFF0EDE7);
  static const Color lightTableCellSelected = Color(0xFFE8F0E5);
  static const Color lightTableHeaderBackground = Color(0xFFF8F5F0);
  static const Color lightTableHeaderText = Color(0xFF3A3731);
  static const Color lightTableBorderHover = Color(0xFFD4CFC5);
  static const Color lightTableAlternateRow = Color(0xFFFCFAF7);
  static const Color lightTableResizeHandle = Color(0xFF9CAF88);
  static const Color lightTableResizeHandleHover = Color(0xFF7A8F6D);
  static const Color lightTableShadow = Color(0x0A3A3531);
  static const Color lightTableBorder = Colors.transparent;

  // -----------------------------------------------------------------------
  // Dark Theme — Table Colours
  // -----------------------------------------------------------------------

  /// Default cell background in dark mode.
  static const Color darkTableCellBackground = Color(0xFF2A2825);
  static const Color darkTableCellHover = Color(0xFF38352F);
  static const Color darkTableCellFocus = Color(0xFF423F38);
  static const Color darkTableCellSelected = Color(0xFF4D5E4A);
  static const Color darkTableHeaderBackground = Color(0xFF38352F);
  static const Color darkTableHeaderText = Color(0xFFF8F6F3);
  static const Color darkTableBorder = Colors.transparent;
  static const Color darkTableBorderHover = Color(0xFF6B6560);
  static const Color darkTableAlternateRow = Color(0xFF32302D);
  static const Color darkTableResizeHandle = Color(0xFF9CAF88);
  static const Color darkTableResizeHandleHover = Color(0xFFAABD98);
  static const Color darkTableShadow = Color(0x33000000);

  // -----------------------------------------------------------------------
  // Brand Palette
  // -----------------------------------------------------------------------

  /// The primary Sage green — the signature colour of the Collect design system.
  static const Color primarySage = Color(0xFF9CAF88);
  static const Color primarySageDark = Color(0xFF7A8F6D);
  static const Color secondaryTerracotta = Color(0xFFD4B5A0);
  static const Color accentGold = Color(0xFFE6D5B8);
  static const Color softCoral = Color(0xFFE5C4B5);
  static const Color dustyRose = Color(0xFFFF6767);
  static const Color lavenderMist = Color(0xFFCBBFD4);
  static const Color accentSuccess = Color(0xFF88B584);
  static const Color accentWarning = Color(0xFFE5BD8F);
  static const Color accentError = Color(0xFFD49490);

  // -----------------------------------------------------------------------
  // Light Theme — Surface, Text & Chrome Colours
  // -----------------------------------------------------------------------

  /// The main background colour for light mode.
  static const Color lightBackground = Color(0xFFF5F3EE);
  static const Color lightSurface = Color(0xFFFFFDFA);
  static const Color lightSurfaceVariant = Color(0xFFF8F5F0);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFE);
  static const Color lightTextPrimary = Color(0xFF3A3731);
  static const Color lightTextSecondary = Color(0xFF6B6560);
  static const Color lightTextTertiary = Color(0xFF9D9691);
  static const Color lightBorder = Color(0xFFE8E3DC);
  static const Color lightBorderSubtle = Color(0xFFF0EDE7);
  static const Color lightDivider = Color(0xFFE5DFD7);
  static const Color lightHover = Color(0xFFFAF7F3);
  static const Color lightFocus = Color(0xFFF0EDE7);

  // -----------------------------------------------------------------------
  // Dark Theme — Surface, Text & Chrome Colours
  // -----------------------------------------------------------------------

  /// The main background colour for dark mode.
  static const Color darkBackground = Color(0xFF2A2825);
  static const Color darkSurface = Color(0xFF1F1D1A);
  static const Color darkSurfaceVariant = Color(0xFF38352F);
  static const Color darkSurfaceElevated = Color(0xFF423F38);
  static const Color darkTextPrimary = Color(0xFFF8F6F3);
  static const Color darkTextSecondary = Color(0xFFC8C1B8);
  static const Color darkTextTertiary = Color(0xFF9E9892);
  static const Color darkBorder = Color(0xFF504B43);
  static const Color darkBorderSubtle = Color(0xFF423F38);
  static const Color darkDivider = Color(0xFF45413A);
  static const Color darkHover = Color(0xFF38352F);
  static const Color darkFocus = Color(0xFF423F38);
}
