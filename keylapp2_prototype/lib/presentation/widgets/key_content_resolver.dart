import '../../domain/layout_mapping.dart';
import '../../domain/models/comparison_session.dart';
import '../../domain/models/comparison_style.dart';
import '../../domain/models/layout.dart';
import '../../domain/models/physical_keyboard.dart';
import 'physical_keyboard_view.dart';

/// Produces cell-based comparison content. For custom mode the style's 9 cells
/// ARE the config — the editor and renderer share the same structure.
class KeyContentResolver {
  final LayoutMapper _mapper;
  KeyContentResolver({required PhysicalKeyboardGeometry geometry}) : _mapper = LayoutMapper(geometry: geometry);

  /// Resolve the 9-cell layout (editor == renderer for custom).
  List<int> cellsFor(ComparisonStyle style, int layoutCount) {
    switch (style.visualization) {
      case ComparisonVisualization.largeSmall:
        final cells = List<int>.filled(9, -1);
        cells[4] = 0;
        if (layoutCount > 1) cells[0] = 1;
        return cells;
      case ComparisonVisualization.matrix:
        final cells = List<int>.filled(9, -1);
        const order = [0, 1, 2, 6, 7, 8];
        for (var i = 0; i < order.length && i < layoutCount; i++) cells[order[i]] = i;
        return cells;
      case ComparisonVisualization.centerCorners:
        final cells = List<int>.filled(9, -1);
        const order = [4, 0, 2, 6, 8];
        for (var i = 0; i < order.length && i < layoutCount; i++) cells[order[i]] = i;
        return cells;
      case ComparisonVisualization.custom:
        return style.customCells ?? ComparisonStyle.defaultCellsFor(layoutCount);
    }
  }

  Map<String, List<String>> buildKeyGlyphMatrix(List<KeyboardLayout> selected) {
    final matrix = <String, List<String>>{};
    for (final layout in selected) {
      _mapper.mapLayout(layout).forEach((id, glyph) {
        matrix.putIfAbsent(id, () => []).add(glyph);
      });
    }
    return matrix;
  }

  KeyContent resolve(PhysicalKey key, List<String> keyGlyphs, ComparisonSession session, List<int> cells) {
    if (key.isFunctionKey) {
      return KeyContent(chars: [key.glyph ?? ''], colors: const [], cells: cells,
          primaryLayoutIndex: session.style.primaryLayoutIndex, primaryScaleFactor: session.style.primaryScaleFactor,
          agreementCount: 0, layoutCount: 1);
    }
    final chars = keyGlyphs.isEmpty ? [''] : keyGlyphs;
    var agreement = 0;
    if (chars.length > 1) {
      final counts = <String, int>{};
      for (final c in chars) { if (c.isNotEmpty) counts[c] = (counts[c] ?? 0) + 1; }
      if (counts.isNotEmpty) agreement = counts.values.reduce((a, b) => a > b ? a : b);
    }
    return KeyContent(chars: chars, colors: session.colors, cells: cells,
        primaryLayoutIndex: session.style.primaryLayoutIndex, primaryScaleFactor: session.style.primaryScaleFactor,
        agreementCount: agreement, layoutCount: session.length);
  }
}