part of '../../../recollect_utils.dart';

/// A palette of pre-defined [Colour] constants, mirroring Flutter's
/// [Colors] class but using the Collect [Colour] type.
///
/// Use these anywhere you'd use `Colors.red` or `Colors.blue`, but with
/// full access to Collect's multi-format output and colour space conversions.
///
/// ## Available Colours
///
/// **Blacks & Whites** — [black], [black87], [black54], [black45], [black38],
/// [black26], [black12], [white], [white70], [white60], [white54], [white38],
/// [white30], [white24], [white12], [white10], [transparent].
///
/// **Material Primaries** — [pink], [purple], [deepPurple], [indigo],
/// [lightBlue], [cyan], [teal], [lightGreen], [lime], [yellow], [amber],
/// [orange], [deepOrange], [brown], [grey], [blueGrey].
///
/// **Material Accents** — [redAccent], [pinkAccent], [purpleAccent],
/// [deepPurpleAccent], [indigoAccent], [blueAccent], [lightBlueAccent],
/// [cyanAccent], [tealAccent], [greenAccent], [lightGreenAccent],
/// [limeAccent], [yellowAccent], [amberAccent], [orangeAccent],
/// [deepOrangeAccent].
mixin class Colours {
  static const Colour transparent = Colour(
    alpha: 0x00,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black = Colour(
    alpha: 0xFF,
    green: 0x00,
    blue: 0x00,
    red: 0x00,
  );
  static const Colour black87 = Colour(
    alpha: 0xDD,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black54 = Colour(
    alpha: 0x8A,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black45 = Colour(
    alpha: 0x73,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black38 = Colour(
    alpha: 0x61,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black26 = Colour(
    alpha: 0x42,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour black12 = Colour(
    alpha: 0x1F,
    red: 0x00,
    green: 0x00,
    blue: 0x00,
  );
  static const Colour white = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white70 = Colour(
    alpha: 0xB3,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white60 = Colour(
    alpha: 0x99,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white54 = Colour(
    alpha: 0x8A,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white38 = Colour(
    alpha: 0x62,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white30 = Colour(
    alpha: 0x4D,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white24 = Colour(
    alpha: 0x3D,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white12 = Colour(
    alpha: 0x1F,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour white10 = Colour(
    alpha: 0x1A,
    red: 0xFF,
    green: 0xFF,
    blue: 0xFF,
  );

  static const Colour pink = Colour(
    alpha: 0xFF,
    red: 0xE9,
    green: 0x1E,
    blue: 0x63,
  );
  static const Colour purple = Colour(
    alpha: 0xFF,
    red: 0x9C,
    green: 0x27,
    blue: 0xB0,
  );
  static const Colour deepPurple = Colour(
    alpha: 0xFF,
    red: 0x67,
    green: 0x3A,
    blue: 0xB7,
  );
  static const Colour indigo = Colour(
    alpha: 0xFF,
    red: 0x3F,
    green: 0x51,
    blue: 0xB5,
  );
  static const Colour lightBlue = Colour(
    alpha: 0xFF,
    red: 0x03,
    green: 0xA9,
    blue: 0xF4,
  );
  static const Colour cyan = Colour(
    alpha: 0xFF,
    red: 0x00,
    green: 0xBC,
    blue: 0xD4,
  );
  static const Colour teal = Colour(
    alpha: 0xFF,
    red: 0x00,
    green: 0x96,
    blue: 0x88,
  );
  static const Colour lightGreen = Colour(
    alpha: 0xFF,
    red: 0x8B,
    green: 0xC3,
    blue: 0x4A,
  );
  static const Colour lime = Colour(
    alpha: 0xFF,
    red: 0xCD,
    green: 0xDC,
    blue: 0x39,
  );
  static const Colour yellow = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xEB,
    blue: 0x3B,
  );
  static const Colour amber = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xC1,
    blue: 0x07,
  );
  static const Colour orange = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0x98,
    blue: 0x00,
  );
  static const Colour deepOrange = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0x57,
    blue: 0x22,
  );
  static const Colour brown = Colour(
    alpha: 0xFF,
    red: 0x79,
    green: 0x55,
    blue: 0x48,
  );
  static const Colour grey = Colour(
    alpha: 0xFF,
    red: 0x9E,
    green: 0x9E,
    blue: 0x9E,
  );
  static const Colour blueGrey = Colour(
    alpha: 0xFF,
    red: 0x60,
    green: 0x7D,
    blue: 0x8B,
  );

  static const Colour redAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0x52,
    blue: 0x52,
  );
  static const Colour pinkAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0x40,
    blue: 0x81,
  );
  static const Colour purpleAccent = Colour(
    alpha: 0xFF,
    red: 0xE0,
    green: 0x40,
    blue: 0xFB,
  );
  static const Colour deepPurpleAccent = Colour(
    alpha: 0xFF,
    red: 0x7C,
    green: 0x4D,
    blue: 0xFF,
  );
  static const Colour indigoAccent = Colour(
    alpha: 0xFF,
    red: 0x53,
    green: 0x6D,
    blue: 0xFE,
  );
  static const Colour blueAccent = Colour(
    alpha: 0xFF,
    red: 0x44,
    green: 0x8A,
    blue: 0xFF,
  );
  static const Colour lightBlueAccent = Colour(
    alpha: 0xFF,
    red: 0x40,
    green: 0xC4,
    blue: 0xFF,
  );
  static const Colour cyanAccent = Colour(
    alpha: 0xFF,
    red: 0x18,
    green: 0xFF,
    blue: 0xFF,
  );
  static const Colour tealAccent = Colour(
    alpha: 0xFF,
    red: 0x64,
    green: 0xFF,
    blue: 0xDA,
  );
  static const Colour greenAccent = Colour(
    alpha: 0xFF,
    red: 0x69,
    green: 0xF0,
    blue: 0xAE,
  );
  static const Colour lightGreenAccent = Colour(
    alpha: 0xFF,
    red: 0xB2,
    green: 0xFF,
    blue: 0x59,
  );
  static const Colour limeAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xF0,
    blue: 0x00,
  );
  static const Colour yellowAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xEA,
    blue: 0x00,
  );
  static const Colour amberAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xAB,
    blue: 0x40,
  );
  static const Colour orangeAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0xAB,
    blue: 0x40,
  );
  static const Colour deepOrangeAccent = Colour(
    alpha: 0xFF,
    red: 0xFF,
    green: 0x6E,
    blue: 0x40,
  );
}
