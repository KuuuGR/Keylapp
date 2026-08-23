import 'physical_keyboard.dart';

/// The Staggered + Simplified physical keyboard — an INDEPENDENT geometry,
/// deliberately NOT derived from [AnsiKeyboardGeometry] (the Staggered Full
/// geometry) and NOT shared with it. This prevents any change here from
/// leaking into the frozen Staggered Full or Ortholinear geometries.
///
/// It shows only the three character rows (rows 1–3), exactly 10 keys each:
///
///   QWERTY:  Q W E R T Y U I O P
///   home:      A S D F G H J K L ;
///   bottom:      Z X C V B N M , . /
///
/// Design rules:
///  - QWERTY row contains EXACTLY 10 keys (Q..P). It sits 0.5U (one optical
///    column) to the RIGHT of its normal simplified position.
///  - Home row contains EXACTLY 10 keys (A..;), kept in its normal position.
///  - Bottom row contains EXACTLY 10 keys (Z../), kept in its normal position.
///  - All character keys are 1×1; no key is resized; spacing is unchanged.
///  - Key rows use row numbers 1–3 so the standard [LayoutMapper] (which maps
///    layout rows via `key.row - 1`) places layout chars onto the correct rows.
class StaggeredSimplifiedKeyboardGeometry extends PhysicalKeyboardGeometry {
  StaggeredSimplifiedKeyboardGeometry()
      : super(id: 'ansi-compact-simplified', rows: _buildRows());

  static List<List<PhysicalKey>> _buildRows() {
    // QWERTY row (row 1) — exactly Q..P, shifted ONE optical column (0.5U)
    // to the RIGHT of its normal simplified position (Q was at col 3, now 4).
    final r1 = <PhysicalKey>[];
    const r1Glyphs = ['Q','W','E','R','T','Y','U','I','O','P'];
    for (var i = 0; i < r1Glyphs.length; i++) {
      r1.add(PhysicalKey(row: 1, opticalColumn: 4 + i, glyph: r1Glyphs[i]));
    }

    // Home row (row 2) — exactly A..;, normal position (A at col 3).
    final r2 = <PhysicalKey>[];
    const r2Glyphs = ['A','S','D','F','G','H','J','K','L',';'];
    for (var i = 0; i < r2Glyphs.length; i++) {
      r2.add(PhysicalKey(row: 2, opticalColumn: 3 + i, glyph: r2Glyphs[i]));
    }

    // Bottom row (row 3) — exactly Z../, normal position (Z at col 4).
    final r3 = <PhysicalKey>[];
    const r3Glyphs = ['Z','X','C','V','B','N','M',',','.','/'];
    for (var i = 0; i < r3Glyphs.length; i++) {
      r3.add(PhysicalKey(row: 3, opticalColumn: 4 + i, glyph: r3Glyphs[i]));
    }

    return [r1, r2, r3];
  }
}