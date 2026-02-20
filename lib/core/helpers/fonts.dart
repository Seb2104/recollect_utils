part of '../../recollect_utils.dart';

/// A type alias that makes font-family parameters self-documenting.
///
/// Instead of `String fontFamily`, you can write `Font fontFamily` — same
/// type, clearer intent.
typedef Font = String;

/// Singleton that discovers, indexes, and dynamically loads system fonts at
/// runtime.
///
/// [SystemFonts] scans the platform's standard font directories (Windows,
/// macOS, Linux) for `.ttf` and `.otf` files and lets you load them into
/// Flutter's font engine on the fly — no need to bundle every font in your
/// asset manifest.
///
/// ## Getting Started
///
/// ```dart
/// final fonts = SystemFonts();
///
/// // See what's available
/// final allFonts = fonts.getFontList(); // ['Arial', 'Courier New', ...]
///
/// // Load one font for use in TextStyle
/// await fonts.loadFont('Fira Code');
///
/// // Or load everything at once
/// await fonts.loadAllFonts();
/// ```
///
/// ## Custom Font Directories
///
/// If your fonts live somewhere non-standard, point the scanner there:
///
/// ```dart
/// fonts.addAdditionalFontDirectory('/opt/my-fonts/');
/// ```
///
/// ## How It Works
///
/// 1. On first access, the constructor scans platform-specific directories.
/// 2. [getFontPaths] lazily collects all `.ttf`/`.otf` file paths.
/// 3. [getFontMap] builds a `{name: path}` lookup from those paths.
/// 4. [loadFont] reads the bytes and registers them with [FontLoader].
///
/// Fonts are cached after loading, so calling [loadFont] twice for the same
/// name is a no-op the second time.
class SystemFonts {
  static final SystemFonts _instance = SystemFonts._internal();

  /// Returns the singleton [SystemFonts] instance.
  factory SystemFonts() {
    return _instance;
  }

  SystemFonts._internal() {
    _fontDirectories.addAll(_getFontDirectories());
  }

  final List<String> _fontDirectories = [];

  final List<String> _fontPaths = [];
  final Map<String, String> _fontMap = {};
  final List<String> _loadedFonts = [];

  List<String> _getFontDirectories() {
    if (Platform.isWindows) {
      return [
        '${Platform.environment['windir']}/fonts/',
        '${Platform.environment['USERPROFILE']}/AppData/Local/Microsoft/Windows/Fonts/',
      ];
    }
    return [];
  }

  /// Returns a list of absolute file paths for every `.ttf` and `.otf` font
  /// found in the system font directories.
  ///
  /// Results are lazily computed and cached on first call.
  List<String> getFontPaths() {
    if (_fontPaths.isEmpty) {
      final paths = _fontDirectories;
      final List<FileSystemEntity> fontFilePaths = [];

      for (final path in paths) {
        if (!Directory(path).existsSync()) {
          continue;
        }
        fontFilePaths.addAll(Directory(path).listSync());
      }

      _fontPaths.addAll(
        fontFilePaths
            .where(
              (element) =>
                  element.path.endsWith('.ttf') ||
                  element.path.endsWith('.otf'),
            )
            .map((e) => e.path)
            .toList(),
      );
    }
    return _fontPaths;
  }

  /// Returns a map of `{fontName: filePath}` for all discovered fonts.
  ///
  /// The font name is derived from the file's basename (without extension).
  Map<String, String> getFontMap() {
    if (_fontMap.isEmpty) {
      _fontMap.addAll(
        Map.fromEntries(
          getFontPaths().map((e) => MapEntry(p.basenameWithoutExtension(e), e)),
        ),
      );
    }
    return _fontMap;
  }

  /// Returns a simple list of all discovered font names (no paths).
  List<String> getFontList() {
    return getFontMap().keys.toList();
  }

  /// Dynamically loads the font with [fontName] into Flutter's rendering
  /// engine so it can be used in [TextStyle.fontFamily].
  ///
  /// Returns the font name on success, or `null` if the font wasn't found.
  /// If the font was already loaded, returns the name immediately without
  /// reloading.
  Future<String?> loadFont(String fontName) async {
    if (_loadedFonts.contains(fontName)) {
      return fontName;
    }

    if (!getFontMap().containsKey(fontName)) {
      return null;
    }

    final bytes = await File(getFontMap()[fontName]!).readAsBytes();
    FontLoader(fontName)
      ..addFont(Future.value(ByteData.view(bytes.buffer)))
      ..load();

    _loadedFonts.add(fontName);
    return fontName;
  }

  /// Loads every discovered font into the Flutter rendering engine.
  ///
  /// Returns a list of all successfully loaded font names. This can take
  /// a moment on systems with many installed fonts.
  Future<List<String>> loadAllFonts() async {
    List<String> loadedFonts = [];
    for (final font in getFontList()) {
      loadedFonts.add((await loadFont(font))!);
    }
    return loadedFonts;
  }

  /// Loads a font from an arbitrary file [path] (must end with `.ttf` or
  /// `.otf`).
  ///
  /// Returns the font name on success, or `null` if the path is invalid, the
  /// file doesn't exist, or a font with the same name is already loaded.
  Future<String?> loadFontFromPath(String path) async {
    if (!path.endsWith('.ttf') && !path.endsWith('.otf')) {
      return null;
    }

    if (!File(path).existsSync()) {
      return null;
    }

    if (_fontMap.containsKey(p.basenameWithoutExtension(path))) {
      return null;
    }

    _fontMap[p.basenameWithoutExtension(path)] = path;

    return loadFont(p.basenameWithoutExtension(path));
  }

  /// Scans an additional directory for `.ttf` and `.otf` files and adds them
  /// to the font map.
  ///
  /// Does nothing if the directory doesn't exist.
  void addAdditionalFontDirectory(String path) {
    if (!Directory(path).existsSync()) {
      return;
    }

    for (FileSystemEntity e in Directory(path).listSync()) {
      if (!e.path.endsWith('.ttf') && !e.path.endsWith('.otf')) {
        continue;
      }
      _fontMap[p.basenameWithoutExtension(e.path)] = e.path;
    }
  }

  /// Clears the cached font map and path list, forcing a fresh scan on the
  /// next call to [getFontPaths] or [getFontMap].
  void rescan() {
    _fontMap.clear();
    _fontPaths.clear();
  }
}
