import 'package:flutter/material.dart';

/// Layout delegate for the [ColourPickerSlider] widget.
///
/// Positions three child elements within a slider:
/// - [track] — the colour gradient bar, inset 15px from each side.
/// - [thumb] — the draggable indicator, overlaid on top of the track.
/// - [gestureContainer] — a full-size hit region that captures pan gestures.
///
/// The track height is 1/5 of the available height and is vertically centred
/// at 40% of the height. The thumb is sized at 5px wide and 1/4 of the
/// height.
class SliderLayout extends MultiChildLayoutDelegate {
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    layoutChild(
      track,
      BoxConstraints.tightFor(
        width: size.width - 30.0,
        height: size.height / 5,
      ),
    );
    positionChild(track, Offset(15.0, size.height * 0.4));
    layoutChild(
      thumb,
      BoxConstraints.tightFor(width: 5.0, height: size.height / 4),
    );
    positionChild(thumb, Offset(0.0, size.height * 0.4));
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(SliderLayout oldDelegate) => false;
}
