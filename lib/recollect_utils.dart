/// # Collect — The Developer's Repertoire
///
/// A comprehensive Flutter toolkit providing reusable utilities, extensions,
/// custom datatypes, and UI widgets for rapid application development.
///
/// ## Overview
///
/// Collect bundles commonly-used functionality into a single, well-organized
/// package. It is structured into two main areas:
///
/// - **Core** — Fundamental utilities, extensions, constants, helpers, and
///   presentation widgets that extend Flutter's built-in capabilities.
/// - **Modules** — Feature-specific, self-contained modules including a
///   [Colour] system, a [ColourPicker] widget, and a searchable [Menu].
///
/// ## Feature Highlights
///
/// | Category         | Description                                              |
/// |------------------|----------------------------------------------------------|
/// | **Extensions**   | 100+ extension methods on `int`, `double`, `String`,     |
/// |                  | `Widget`, `List`, `BuildContext`, and more.               |
/// | **Datatypes**    | [Moment] (rich `DateTime` wrapper) and [Period]          |
/// |                  | (duration with year/month support).                       |
/// | **Colour**       | Multi-format colour class supporting RGB, HSL, HSV,      |
/// |                  | Hex, and Base-256 representations.                        |
/// | **ColourPicker** | Interactive colour picker with wheel, square, ring, and  |
/// |                  | slider picker styles.                                     |
/// | **Menu**         | Searchable dropdown menu with filtering and custom items. |
/// | **Theming**      | Material 3 theme system (Sage & Terracotta palettes).    |
/// | **Fonts**        | 16 bundled font families ready for use.                   |
/// | **Notifications**| Toast-style notification system.                          |
/// | **Radix**        | Base conversion utilities (binary, octal, hex, base-256). |
///
/// ## Quick Start
///
/// ```dart
/// import 'package:recollect_utils/recollect_utils.dart';
///
/// // Use extension methods
/// final greeting = 'hello world'.toTitleCase(); // 'Hello World'
/// final binary = 42.toBinary();                 // '101010'
///
/// // Work with Moments
/// final now = Moment.now();
/// print(now.format('MMMM dd, yyyy'));           // 'February 19, 2026'
///
/// // Create colours in any format
/// final red = Colour.fromHex('#FF0000');
/// final blue = Colour.fromRGB(0, 0, 255);
/// ```
///
/// ## Architecture
///
/// ```
/// recollect_utils/
/// ├── core/
/// │   ├── constants/    — Static values, enums, and lookup tables
/// │   ├── datatypes/    — Moment and Period custom types
/// │   ├── extensions/   — Extension methods on built-in types
/// │   ├── helpers/      — Icon and font helper utilities
/// │   ├── presentation/ — Ready-to-use UI widgets
/// │   └── utils/        — Notifications, radix conversion, string processing
/// └── modules/
///     ├── colour/        — Colour class and colour-space types
///     ├── colour_picker/  — Interactive colour picker widgets
///     └── menu/          — Searchable dropdown menu component
/// ```
///
/// See also:
/// - [GitHub Repository](https://github.com/Seb2104/recollect_utils)
/// - [Colour] for multi-format colour handling
/// - [Moment] for advanced date/time operations
/// - [Period] for human-friendly durations
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:super_editor/super_editor.dart' as sp;
import 'package:super_editor/super_editor.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide FilterCallback, SearchCallback;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:recollect_utils/modules/colour/colour.dart';
import 'package:unicode/unicode.dart' as unicode;

export 'modules/colour/colour.dart';
export 'modules/colour_picker/colour_picker.dart';
export 'modules/menus/menus.dart';

part 'core/constants/bases.dart';
part 'core/constants/colour_pickers.dart';
part 'core/constants/moment.dart';
part 'core/constants/packaged_fonts.dart';
part 'core/constants/picker_style.dart';
part 'core/constants/strings.dart';
part 'core/constants/tab_view.dart';
part 'core/datatypes/align_type.dart';
part 'core/datatypes/moment.dart';
part 'core/datatypes/period.dart';
part 'core/extensions/build_context.dart';
part 'core/extensions/double.dart';
part 'core/extensions/int.dart';
part 'core/extensions/list.dart';
part 'core/extensions/num.dart';
part 'core/extensions/string.dart';
part 'core/extensions/widget.dart';
part 'core/helpers/collect_icons.dart';
part 'core/helpers/fonts.dart';
part 'core/presentation/action_icon.dart';
part 'core/presentation/app_theme.dart';
part 'core/presentation/box.dart';
part 'core/presentation/hover_detector.dart';
part 'core/presentation/rounded_checkmark.dart';
part 'core/presentation/tab_view.dart';
part 'core/presentation/word.dart';
part 'core/utils/notifications.dart';
part 'core/utils/radix.dart';
part 'core/utils/strings.dart';
part 'modules/colour/constants/colours.dart';
part 'modules/xtx/data/file_constants.dart';
part 'modules/xtx/data/metadata_keys.dart';
part 'modules/xtx/data/model_constants.dart';
part 'modules/xtx/data/parse_result.dart';
part 'modules/xtx/data/result.dart';
part 'modules/xtx/models/asset.dart';
part 'modules/xtx/models/header.dart';
part 'modules/xtx/models/node.dart';
part 'modules/xtx/parser/buffered_reader.dart';
part 'modules/xtx/parser/components/asset_parser.dart';
part 'modules/xtx/parser/components/header_parser.dart';
part 'modules/xtx/parser/components/metadata_parser.dart';
part 'modules/xtx/parser/components/node_parser.dart';
part 'modules/xtx/parser/exceptions.dart';
part 'modules/xtx/parser/metrics.dart';
part 'modules/xtx/parser/streaming_parser.dart';
part 'modules/xtx/parser/xtx_parser.dart';
part 'modules/xtx/utils/byte_reader.dart';
part 'modules/xtx/utils/file_system_manager.dart';
part 'modules/xtx/utils/format.dart';
part 'modules/xtx/xtx_document.dart';
part 'modules/xtx/xtx_file.dart';
part 'modules/xtx/xtx.dart';