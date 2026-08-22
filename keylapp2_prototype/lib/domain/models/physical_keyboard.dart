/// A physical key position with geometry, independent of which layout maps
/// characters onto it.
///
/// `unitWidth`/`unitHeight` are in *key units* (letter keys = 1×1). Wide keys
/// (Tab, Shift, Space…) span multiple optical columns. `opticalColumn` is the
/// left-edge column within its row.
class PhysicalKey {
  final int row;
  final int opticalColumn;
  final double unitWidth;
  final double unitHeight;
  final String? function; // 'tab','caps','shift','enter','space','esc',… or null
  final String? glyph;    // static label for non-letter keys (e.g. 'Tab')

  const PhysicalKey({
    required this.row,
    required this.opticalColumn,
    this.unitWidth = 1.0,
    this.unitHeight = 1.0,
    this.function,
    this.glyph,
  });

  bool get isFunctionKey => function != null;
}

/// The stable physical keyboard shape shared by every layout. Layouts only
/// change characters *inside* letter keys; never the geometry.
class PhysicalKeyboardGeometry {
  final String id;
  final List<List<PhysicalKey>> rows;

  const PhysicalKeyboardGeometry({required this.id, required this.rows});

  int get rowCount => rows.length;

  int get maxOpticalColumns => rows.fold(0, (m, r) {
    final extent = r.fold<int>(0, (acc, k) {
      final right = (k.opticalColumn + k.unitWidth).ceil();
      return right > acc ? right : acc;
    });
    return extent > m ? extent : m;
  });

  /// Letter keys (non-function) in (row, column) order, for layout mapping.
  List<PhysicalKey> get letterKeys {
    final out = <PhysicalKey>[];
    for (final r in rows) {
      for (final k in r) {
        if (!k.isFunctionKey) out.add(k);
      }
    }
    return out;
  }

  /// Derive a **simplified** (crop) version of this physical keyboard: only the
  /// character-key region is kept. Simplification hides everything outside the
  /// three character rows (the number row, function/modifier keys, space, etc.)
  /// but does NOT relocate or resize the character keys — they keep their exact
  /// physical positions, so the stagger is preserved for Staggered and the
  /// perfect 3×10 grid for Ortholinear.
  ///
  /// The character rows are rows 1–3 (the rows that layout mappings populate;
  /// see [LayoutMapper], which maps via `key.row - 1`). Row 0 (number row) and
  /// any function keys inside the character rows (Tab, Caps, Enter, Shift…) are
  /// dropped.
  ///
  /// The derived geometry's `id` gains the "-simplified" suffix; the character
  /// keys are the SAME objects (identical row/opticalColumn/unitWidth/etc).
  PhysicalKeyboardGeometry simplified() {
    final keptRows = <List<PhysicalKey>>[];
    for (final row in rows) {
      if (row.isEmpty) continue;
      final rowIndex = row.first.row;
      // Only rows 1–3 are character rows; row 0 is the number row.
      if (rowIndex < 1 || rowIndex > 3) continue;
      final letters = row.where((k) => !k.isFunctionKey).toList();
      if (letters.isNotEmpty) keptRows.add(List.unmodifiable(letters));
    }
    return PhysicalKeyboardGeometry(id: '$id-simplified', rows: List.unmodifiable(keptRows));
  }
}
