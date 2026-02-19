part of '../../recollect_utils.dart';

/// Internal marker for which theme-aware colour variant a [Word] should use.
enum _WordTextStyle { normal, primary, secondary, tertiary }

/// An advanced text widget that bundles a [Text] with inline [TextStyle]
/// parameters and theme-aware colour variants — so you can style text
/// without manually building a [TextStyle] every time.
///
/// ## Why use Word instead of Text?
///
/// Flutter's [Text] widget requires you to wrap all styling in a separate
/// [TextStyle] object. [Word] flattens that: you pass `fontSize`,
/// `fontWeight`, `color`, etc. directly as constructor parameters.
///
/// ## Named Constructors
///
/// | Constructor       | Colour                         | Defaults                   |
/// |-------------------|--------------------------------|----------------------------|
/// | `Word(...)`       | Inherited / custom             | Normal weight, no overflow |
/// | `Word.primary`    | [AppTheme.textPrimary]         | Bold, 28px, ellipsis       |
/// | `Word.secondary`  | [AppTheme.textSecondary]       | Normal weight, ellipsis    |
/// | `Word.tertiary`   | [AppTheme.textTertiary]        | Normal weight, ellipsis    |
///
/// ## Example
///
/// ```dart
/// // Simple usage
/// Word('Hello, world!')
///
/// // Styled
/// Word('Title', fontSize: 24, fontWeight: FontWeight.bold)
///
/// // Theme-aware primary heading
/// Word.primary('Dashboard')
///
/// // Selectable text
/// Word('Copy me', selectable: true)
/// ```
class Word extends StatefulWidget {
  final String data;
  final bool selectable;
  final _WordTextStyle _textStyleType;
  final InlineSpan? textSpan;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final String? semanticsIdentifier;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool inherit;
  final Color? color;
  final Color? backgroundColor;
  final Font? fontFamily;
  final List<Font>? fontFamilyFallback;
  final String? package;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final double? height;
  final TextLeadingDistribution? leadingDistribution;
  final Paint? foreground;
  final Paint? background;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? debugLabel;
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;

  const Word(
    this.data, {
    super.key,
    this.selectable = false,
    this.inherit = true,
    this.textSpan,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.leadingDistribution,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily = TIMES_NEW_ROMAN,
    this.fontFamilyFallback = const [APPLE_COLOUR_EMOJI],
    this.package,
  }) : _textStyleType = _WordTextStyle.normal;

  const Word.primary(
    this.data, {
    super.key,
    this.selectable = false,
    this.inherit = true,
    this.textSpan,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow = TextOverflow.ellipsis,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.backgroundColor,
    this.fontSize = 28,
    this.fontWeight = FontWeight.bold,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.leadingDistribution,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily = TIMES_NEW_ROMAN,
    this.fontFamilyFallback = const [APPLE_COLOUR_EMOJI],
    this.package,
  }) : _textStyleType = _WordTextStyle.primary;

  const Word.secondary(
    this.data, {
    super.key,
    this.selectable = false,
    this.inherit = true,
    this.textSpan,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow = TextOverflow.ellipsis,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.leadingDistribution,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily = TIMES_NEW_ROMAN,
    this.fontFamilyFallback = const [APPLE_COLOUR_EMOJI],
    this.package,
  }) : _textStyleType = _WordTextStyle.secondary;

  const Word.tertiary(
    this.data, {
    super.key,
    this.selectable = false,
    this.inherit = true,
    this.textSpan,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow = TextOverflow.ellipsis,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.leadingDistribution,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily = TIMES_NEW_ROMAN,
    this.fontFamilyFallback = const [APPLE_COLOUR_EMOJI],
    this.package,
  }) : _textStyleType = _WordTextStyle.tertiary;

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  Color? _getColor(BuildContext context) {
    if (widget.color != null) {
      return widget.color;
    }

    switch (widget._textStyleType) {
      case _WordTextStyle.primary:
        return AppTheme.textPrimary(context);
      case _WordTextStyle.secondary:
        return AppTheme.textSecondary(context);
      case _WordTextStyle.tertiary:
        return AppTheme.textTertiary(context);
      case _WordTextStyle.normal:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor = _getColor(context);
    return widget.selectable
        ? Text(
            widget.data,
            style: TextStyle(
              inherit: widget.inherit,
              color: resolvedColor,
              backgroundColor: widget.backgroundColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              fontStyle: widget.fontStyle,
              letterSpacing: widget.letterSpacing,
              wordSpacing: widget.wordSpacing,
              textBaseline: widget.textBaseline,
              height: widget.height,
              leadingDistribution: widget.leadingDistribution,
              locale: widget.locale,
              foreground: widget.foreground,
              background: widget.background,
              shadows: widget.shadows,
              fontFeatures: widget.fontFeatures,
              fontVariations: widget.fontVariations,
              decoration: widget.decoration,
              decorationColor: widget.decorationColor,
              decorationStyle: widget.decorationStyle,
              decorationThickness: widget.decorationThickness,
              debugLabel: widget.debugLabel,
              fontFamily: widget.fontFamily!,
              fontFamilyFallback: widget.fontFamilyFallback!,
              package: widget.package,
              overflow: widget.overflow,
            ),
            strutStyle: widget.strutStyle,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            locale: widget.locale,
            softWrap: widget.softWrap,
            overflow: widget.overflow,
            textScaler: widget.textScaler,
            maxLines: widget.maxLines,
            semanticsLabel: widget.semanticsLabel,
            semanticsIdentifier: widget.semanticsIdentifier,
            textWidthBasis: widget.textWidthBasis,
            textHeightBehavior: widget.textHeightBehavior,
            selectionColor: widget.selectionColor,
          )
        : Text(
            widget.data,
            style: TextStyle(
              inherit: widget.inherit,
              color: resolvedColor,
              backgroundColor: widget.backgroundColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              fontStyle: widget.fontStyle,
              letterSpacing: widget.letterSpacing,
              wordSpacing: widget.wordSpacing,
              textBaseline: widget.textBaseline,
              height: widget.height,
              leadingDistribution: widget.leadingDistribution,
              locale: widget.locale,
              foreground: widget.foreground,
              background: widget.background,
              shadows: widget.shadows,
              fontFeatures: widget.fontFeatures,
              fontVariations: widget.fontVariations,
              decoration: widget.decoration,
              decorationColor: widget.decorationColor,
              decorationStyle: widget.decorationStyle,
              decorationThickness: widget.decorationThickness,
              debugLabel: widget.debugLabel,
              fontFamily: widget.fontFamily!,
              fontFamilyFallback: widget.fontFamilyFallback!,
              package: widget.package,
              overflow: widget.overflow,
            ),
            strutStyle: widget.strutStyle,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            locale: widget.locale,
            softWrap: widget.softWrap,
            overflow: widget.overflow,
            textScaler: widget.textScaler,
            maxLines: widget.maxLines,
            semanticsLabel: widget.semanticsLabel,
            semanticsIdentifier: widget.semanticsIdentifier,
            textWidthBasis: widget.textWidthBasis,
            textHeightBehavior: widget.textHeightBehavior,
            selectionColor: widget.selectionColor,
          );
  }
}
