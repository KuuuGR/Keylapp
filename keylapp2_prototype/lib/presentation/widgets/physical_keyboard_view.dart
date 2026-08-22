import 'package:flutter/material.dart';

import '../../domain/models/physical_keyboard.dart';
import 'physical_key_widget.dart';

/// Resolved content for a physical key: per-layout glyphs + colors + 9-cell
/// custom layout (editor == renderer) + primary scale + consensus.
class KeyContent {
  final List<String> chars;
  final List<Color> colors;
  final List<int> cells;
  final int primaryLayoutIndex;
  final double primaryScaleFactor;
  final int agreementCount;
  final int layoutCount;
  const KeyContent({
    required this.chars,
    required this.colors,
    required this.cells,
    required this.primaryLayoutIndex,
    required this.primaryScaleFactor,
    required this.agreementCount,
    required this.layoutCount,
  });
}

/// Renders the physical keyboard as ONE physical object that scales uniformly
/// to fit the bounded area — never clips, never shows an overflow strip, and
/// never resizes individual character keys independently.
///
/// LAYOUT MODEL:
///  - A `baseUnit` is computed from the bounded constraints so that 10
///    letter-columns × 5 full-keyboard-rows fit the area.
///  - The keyboard is built at that natural size (every character key =
///    1×baseUnit; special keys = unitWidth×baseUnit; every row 1×baseUnit).
///  - The whole built object is wrapped in `FittedBox(fit: contain)` so if the
///    natural size exceeds the available box it scales DOWN uniformly — all
///    keys shrink together, identically. No overflow, no clipping, no strip.
class PhysicalKeyboardView extends StatelessWidget {
  final PhysicalKeyboardGeometry geometry;
  final bool showComparison;
  final KeyContent Function(PhysicalKey key) keyContentResolver;

  const PhysicalKeyboardView({
    super.key,
    required this.geometry,
    required this.showComparison,
    required this.keyContentResolver,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // The global leftmost start column across rows. Using it as the baseline
      // removes any artificial leading column (e.g. a shared aux/border column in
      // Simplified crops) while preserving the *relative* inter-row offsets —
      // which is exactly what produces the Stagger (and the aligned grid for
      // Ortholinear).
      final minStartCol = geometry.rows
          .where((r) => r.isNotEmpty)
          .fold<int>(1 << 30, (m, r) => r.first.opticalColumn < m ? r.first.opticalColumn : m);
      final baseline = geometry.rows.where((r) => r.isNotEmpty).isEmpty ? 0 : minStartCol;

      // Occupied width in key-units: from the leftmost key column to the right
      // edge of the widest key. This is tighter than raw maxOpticalColumns, so
      // the keyboard scales up to use the available area instead of leaving a
      // wasted margin (Ortholinear Full spans 12 columns, not 13).
      final occupiedWidthUnits = geometry.maxOpticalColumns.toDouble() - baseline;
      final rows = geometry.rows.length.toDouble();
      final gap = 0.12; // compact key gap as a fraction of baseUnit
      final colsWithGaps = occupiedWidthUnits + (occupiedWidthUnits - 1) * gap;
      final rowsWithGaps = rows + (rows - 1) * gap;

      final unitByWidth = constraints.maxWidth / colsWithGaps;
      final unitByHeight = constraints.maxHeight / rowsWithGaps;
      final baseUnit = (unitByWidth < unitByHeight ? unitByWidth : unitByHeight).clamp(2.0, 200.0);

      // Build the keyboard at its natural size.
      final keyboard = Container(
        color: const Color(0xFF14141F),
        padding: EdgeInsets.all(baseUnit * 0.28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in geometry.rows)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Relative horizontal offset for this row. Staggered keeps its
                  // natural row offsets; Ortholinear rows share the same offset,
                  // giving perfectly aligned columns.
                  if (row.isNotEmpty)
                    SizedBox(width: (row.first.opticalColumn - baseline) * (baseUnit * 0.5)),
                  for (final key in row)
                    Container(
                      width: key.unitWidth * baseUnit - baseUnit * gap,
                      height: baseUnit - baseUnit * gap,
                      margin: EdgeInsets.all(baseUnit * gap / 2),
                      child: KeyHole(
                        physicalKey: key,
                        content: keyContentResolver(key),
                        showComparison: showComparison,
                      ),
                    ),
                ],
              ),
          ],
        ),
      );

      // Scale the whole keyboard uniformly to fit — no overflow, no strip.
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          clipBehavior: Clip.none,
          child: keyboard,
        ),
      );
    });
  }
}

class KeyHole extends StatelessWidget {
  final PhysicalKey physicalKey;
  final KeyContent content;
  final bool showComparison;
  const KeyHole({super.key, required this.physicalKey, required this.content, required this.showComparison});

  @override
  Widget build(BuildContext context) {
    return PhysicalKeyWidget(
      physicalKey: physicalKey,
      cellChars: content.chars,
      cellColors: content.colors,
      cells: content.cells,
      primaryLayoutIndex: content.primaryLayoutIndex,
      primaryScaleFactor: content.primaryScaleFactor,
      agreementCount: content.agreementCount,
      layoutCount: content.layoutCount,
      showComparison: showComparison,
    );
  }
}