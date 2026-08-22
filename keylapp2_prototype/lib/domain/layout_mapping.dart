import 'models/layout.dart';
import 'models/physical_keyboard.dart';

/// Maps a layout's alphabetic rows onto the physical keyboard's letter keys by
/// QWERTY position. Function/number keys keep their fixed glyphs; only letter
/// keys change.
///
/// Mapping is by **index among the physical row's letter keys** (in optical
/// order), so it works identically for any geometry — Standard (rows contain
/// modifier/function keys between letters) and Ortholinear (pure letter rows).
class LayoutMapper {
  final PhysicalKeyboardGeometry geometry;
  LayoutMapper({required this.geometry});

  /// Per-key display char keyed by 'row:col'.
  Map<String, String> mapLayout(KeyboardLayout layout) {
    final result = <String, String>{};

    for (final row in geometry.rows) {
      if (row.isEmpty) continue;
      final letters = row.where((k) => !k.isFunctionKey).toList()
        ..sort((a, b) => a.opticalColumn.compareTo(b.opticalColumn));

      for (final key in row) {
        final id = _keyId(key.row, key.opticalColumn);
        if (key.isFunctionKey) { result[id] = key.glyph ?? ''; continue; }
        final layoutRowIndex = key.row - 1; // 1→0,2→1,3→2
        if (layoutRowIndex >= 0 && layoutRowIndex < layout.rows.length) {
          final localCol = letters.indexWhere((k) => k.opticalColumn == key.opticalColumn);
          final lr = layout.rows[layoutRowIndex];
          result[id] = (localCol >= 0 && localCol < lr.length) ? lr[localCol] : '';
        } else {
          result[id] = key.glyph ?? '';
        }
      }
    }
    return result;
  }

  static String _keyId(int row, int col) => '$row:$col';
}