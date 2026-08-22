import 'physical_keyboard.dart';

/// Ortholinear physical keyboard — an explicit, independent 4 × 12 rectangular
/// matrix with NO stagger and NO row offsets. This geometry is NOT derived from
/// the staggered ANSI keyboard; it is its own deliberate physical shape.
///
/// Authoritative layout (columns 1–12, rows 1–4):
///
///   col  1    2   3   4   5   6   7   8   9   10   11   12
///   ┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┐
///   │ ▶  │ Q  │ W  │ E  │ R  │ T  │ Y  │ U  │ I  │ O  │ P  │ ◀  │  row 1
///   ├────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┤
///   │    │ A  │ S  │ D  │ F  │ G  │ H  │ J  │ K  │ L  │ ;  │    │  row 2
///   ├────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┤
///   │    │ Z  │ X  │ C  │ V  │ B  │ N  │ M  │ ,  │ .  │ /  │    │  row 3
///   ├────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┤
///   │    │    │    │    │             │    │    │    │    │    │  row 4
///   └────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┘
///
/// - The character area is exactly 3 × 10: rows 1–3, columns 2–11.
///   Q starts at (1,2), A at (2,2), Z at (3,2).
/// - Columns 1 and 12 are auxiliary physical keys on every character row.
/// - The two top-corner keys (row 1, cols 1 & 12) are the **bumper keys**.
/// - Row 4 is the auxiliary bottom row, containing a wide Space key.
/// - All 30 layout keys are identical 1×1 rectangles, perfectly aligned.
class OrtholinearKeyboardGeometry extends PhysicalKeyboardGeometry {
  OrtholinearKeyboardGeometry() : super(id: 'ortholinear', rows: _buildRows());

  static const int charColumns = 10;

  static List<List<PhysicalKey>> _buildRows() {
    const charRows = [
      ['Q','W','E','R','T','Y','U','I','O','P'],
      ['A','S','D','F','G','H','J','K','L',';'],
      ['Z','X','C','V','B','N','M',',','.','/'],
    ];

    final rows = <List<PhysicalKey>>[];
    for (var r = 0; r < charRows.length; r++) {
      final row = <PhysicalKey>[];
      // Column 1: auxiliary. Row 1's outer keys are the bumper keys.
      row.add(PhysicalKey(
        row: r + 1,
        opticalColumn: 1,
        function: r == 0 ? 'bumper' : 'aux',
        glyph: '',
      ));
      // Columns 2–11: the 10 layout keys (identical 1×1 rectangles).
      for (var c = 0; c < charColumns; c++) {
        row.add(PhysicalKey(
          row: r + 1,
          opticalColumn: 2 + c,
          glyph: charRows[r][c],
        ));
      }
      // Column 12: auxiliary. Row 1's outer key is a bumper key.
      row.add(PhysicalKey(
        row: r + 1,
        opticalColumn: 12,
        function: r == 0 ? 'bumper' : 'aux',
        glyph: '',
      ));
      rows.add(row);
    }

    // Row 4: auxiliary bottom row. Space is intentionally the ONLY non-1U key:
    // exactly 2U wide (max), centred. The remaining ten columns are separate
    // normal 1U×1U keys (five on each side) so they stay individually
    // addressable and visually distinguishable (e.g. potential bumper/thumb
    // keys) — they must NOT disappear into the Space.
    //   [1U][1U][1U][1U][1U][2U SPACE][1U][1U][1U][1U][1U]
    final bottom = <PhysicalKey>[
      PhysicalKey(row: 4, opticalColumn: 1, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 2, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 3, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 4, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 5, function: 'aux', glyph: ''),
      const PhysicalKey(row: 4, opticalColumn: 6, function: 'space', glyph: '', unitWidth: 2.0),
      PhysicalKey(row: 4, opticalColumn: 8, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 9, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 10, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 11, function: 'aux', glyph: ''),
      PhysicalKey(row: 4, opticalColumn: 12, function: 'aux', glyph: ''),
    ];
    rows.add(bottom);

    return rows;
  }
}