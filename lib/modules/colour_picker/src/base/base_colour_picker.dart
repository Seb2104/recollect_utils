part of '../../colour_picker.dart';

/// Base class for all colour picker implementations.
///
/// Provides shared state management, lifecycle methods, and common functionality
/// to reduce duplication across different picker types (wheel, square, ring, slides).
abstract class BaseColourPicker<T extends StatefulWidget> extends State<T> {
  /// Current colour in HSV format (used internally for all colour operations)
  @protected
  HSVColour currentHsvColor = const HSVColour.fromAHSV(0.0, 0.0, 0.0, 0.0);

  /// History of previously selected colours
  @protected
  List<Color> colorHistory = [];

  /// Get the initial colour from widget properties
  /// Subclasses must implement this to extract the initial colour from their widget
  Color getInitialColor();

  /// Get the optional HSV colour override from widget properties
  /// Returns null if not provided by the widget
  HSVColour? getInitialHsvColor();

  /// Get the colour history from widget properties
  /// Returns null if not provided by the widget
  List<Color>? getColorHistory();

  /// Get the history changed callback from widget properties
  /// Returns null if not provided by the widget
  ValueChanged<List<Color>>? getHistoryChangedCallback();

  /// Called when the colour changes
  /// Subclasses must implement this to notify parent widgets
  void notifyColorChanged(HSVColour color);

  @override
  void initState() {
    super.initState();

    // Initialize from HSV if provided, otherwise convert from RGB
    final hsvOverride = getInitialHsvColor();
    currentHsvColor = hsvOverride ?? HSVColour.fromColor(getInitialColor());

    // Initialize history if callbacks are provided
    final history = getColorHistory();
    final historyCallback = getHistoryChangedCallback();
    if (history != null && historyCallback != null) {
      colorHistory = history;
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync with external colour changes
    final hsvOverride = getInitialHsvColor();
    currentHsvColor = hsvOverride ?? HSVColour.fromColor(getInitialColor());
  }

  /// Handles colour changes from picker interactions
  /// Updates internal state and notifies parent widgets
  @protected
  void onColorChanging(HSVColour colour) {
    setState(() => currentHsvColor = colour);
    notifyColorChanged(colour);
  }

  /// Creates a colour picker slider for the specified track type
  ///
  /// This is a common pattern across all pickers - creates a slider that
  /// updates the current colour when dragged.
  @protected
  Widget buildColorPickerSlider(
    TrackType trackType, {
    bool displayThumbColor = false,
  }) {
    return ColourPickerSlider(trackType, currentHsvColor, (HSVColour colour) {
      setState(() => currentHsvColor = colour);
      notifyColorChanged(colour);
    }, displayThumbColor: displayThumbColor);
  }

  /// Adds current colour to history
  @protected
  void addToHistory() {
    final historyCallback = getHistoryChangedCallback();
    if (historyCallback != null &&
        !colorHistory.contains(currentHsvColor.toColor())) {
      setState(() {
        colorHistory.add(currentHsvColor.toColor());
      });
      historyCallback(colorHistory);
    }
  }

  /// Removes a colour from history
  @protected
  void removeFromHistory(Color color) {
    final historyCallback = getHistoryChangedCallback();
    if (historyCallback != null && colorHistory.remove(color)) {
      setState(() {});
      historyCallback(colorHistory);
    }
  }

  /// Checks if device is in portrait mode or portrait is enforced
  @protected
  bool isPortrait(BuildContext context, bool portraitOnly) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
        portraitOnly;
  }
}
