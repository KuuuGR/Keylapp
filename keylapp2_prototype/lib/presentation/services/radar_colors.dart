import 'dart:ui';

/// Dedicated 2–5 layout radar color palette. Preserves the original Keylapp
/// blue/green as the first two, adds a distinct **pastel magenta/pink-purple**
/// as the third, then two more distinguishable hues.
///
/// Chosen to be distinguishable under transparency, read well on dark,
/// overlap legibly, and look good in screenshots.
class RadarColorPalette {
  static const List<Color> colors = [
    Color(0xFF4FC3F7), // blue (original layout 1)
    Color(0xFF66BB6A), // green (original layout 2)
    Color(0xFFF06292), // pastel magenta / pink-purple (NEW third)
    Color(0xFFFFB74D), // amber
    Color(0xFFCE93D8), // light purple
  ];

  static Color forIndex(int i) => colors[i % colors.length];

  /// Semi-transparent fill alpha (matches the original 0.3 fill).
  static const double fillAlpha = 0.3;
}