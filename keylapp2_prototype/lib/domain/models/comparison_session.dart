import 'dart:ui';

import 'comparison_style.dart';

/// A first-class, persistent representation of "which layouts am I comparing".
///
/// The same [ComparisonSession] is used by the keyboard view, the radar view
/// and the selection UI. It owns:
///   - the ordered list of selected layout ids (2–5),
///   - the color assigned to each position in the comparison,
///   - a consensus/color strategy.
class ComparisonSession {
  static const int minLayouts = 2;
  static const int maxLayouts = 5;

  /// The ordered layout ids being compared. Order defines color assignment.
  final List<String> layoutIds;

  /// HOW the selected layouts are visualized (configuration, not state).
  final ComparisonStyle style;

  /// Independent physical-keyboard configuration (geometry + scope).
  final KeyboardConfiguration keyboard;

  ComparisonSession({
    required List<String> layoutIds,
    this.style = const ComparisonStyle(),
    this.keyboard = const KeyboardConfiguration(),
  })  : assert(layoutIds.length >= minLayouts && layoutIds.length <= maxLayouts),
        layoutIds = List.unmodifiable(layoutIds);

  int get length => layoutIds.length;
  bool get isFull => layoutIds.length >= maxLayouts;

  /// A stable color for each position in the session (index-aligned).
  List<Color> get colors => List.generate(
      layoutIds.length, (i) => ComparisonColors.palette[i % ComparisonColors.palette.length]);

  ComparisonSession copyWith({List<String>? layoutIds, ComparisonStyle? style, KeyboardConfiguration? keyboard}) =>
      ComparisonSession(
          layoutIds: layoutIds ?? this.layoutIds,
          style: style ?? this.style,
          keyboard: keyboard ?? this.keyboard);

  /// A session with the default starting comparison (QWERTY + Colemak).
  factory ComparisonSession.defaultSession() =>
      ComparisonSession(layoutIds: const ['qwerty', 'colemak']);
}

/// The shared visual color palette for the 2–5 layout comparison.
/// Designed for colorblind-safe distinction and good contrast on dark.
class ComparisonColors {
  static const List<Color> palette = [
    Color(0xFF4FC3F7), // blue
    Color(0xFFFFB74D), // orange
    Color(0xFF66BB6A), // green
    Color(0xFFCE93D8), // purple
    Color(0xFFF06292), // pink
  ];

  /// The per-position color for index `i`.
  static Color colorFor(int i) => palette[i % palette.length];
}