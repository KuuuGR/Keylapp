import 'models/layout.dart';

/// For a single physical key, how many of the compared layouts agree on the
/// same character. This is the basis of the "consensus" visualisation.
class KeyConsensus {
  /// The physical position (row, column). `null` chars mean a layout has no
  /// key at this position (variable row widths).
  final int row;
  final int column;

  /// Character -> number of selected layouts that put that character here.
  final Map<String, int> charCounts;

  const KeyConsensus({
    required this.row,
    required this.column,
    required this.charCounts,
  });

  /// The number of compared layouts that share the most common character.
  int get agreementCount => charCounts.values.isEmpty ? 0 : charCounts.values.reduce((a, b) => a > b ? a : b);

  /// The most common character on this key (empty if none).
  String get dominantChar =>
      charCounts.entries.isEmpty ? '' : (charCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key);

  /// 0.0 .. 1.0 — fraction of the compared layouts that agree.
  double get agreementRatio {
    final total = charCounts.values.fold<int>(0, (s, v) => s + v);
    return total == 0 ? 0 : agreementCount / total;
  }

  /// Whether all compared layouts put the same character here.
  bool get isUnanimous => charCounts.length == 1 && agreementCount >= 2;
}

/// Computes the per-key consensus across a set of selected layouts.
///
/// Semantics: "physical key position" is (row, column), where a layout's rows
/// are variable-width, so a shorter row simply has no key at a given column.
class ConsensusEngine {
  final List<KeyboardLayout> layouts;
  final List<String> selectedIds;

  Map<String, KeyboardLayout> _byId = {};

  ConsensusEngine({required this.layouts, required this.selectedIds});

  void _ensureIndex() {
    if (_byId.isNotEmpty) return;
    for (final l in layouts) {
      _byId[l.id] = l;
    }
  }

  /// Layouts resolved from [selectedIds] in the same order.
  List<KeyboardLayout> get selectedLayouts {
    _ensureIndex();
    return selectedIds.map((id) => _byId[id]).whereType<KeyboardLayout>().toList();
  }

  /// Maximum row count among the selected layouts.
  int get _maxRows => selectedLayouts.fold(0, (m, l) => l.rows.length > m ? l.rows.length : m);

  /// Maximum column count across all pairs (row i across all selected layouts).
  int _maxColsForRow(int row) {
    var m = 0;
    for (final l in selectedLayouts) {
      if (row < l.rows.length) {
        final c = l.rows[row].length;
        if (c > m) m = c;
      }
    }
    return m;
  }

  /// Returns a grid of [KeyConsensus] for every physical key position covered
  /// by at least one selected layout. `null` in the grid = no layout has a key
  /// at that position (rare, only from extremely uneven row widths).
  List<List<KeyConsensus?>> computeGrid() {
    final rows = <List<KeyConsensus?>>[];
    for (var r = 0; r < _maxRows; r++) {
      final cols = _maxColsForRow(r);
      final rowConsensus = <KeyConsensus?>[];
      for (var c = 0; c < cols; c++) {
        final counts = <String, int>{};
        var present = false;
        for (final l in selectedLayouts) {
          if (r < l.rows.length && c < l.rows[r].length) {
            present = true;
            final ch = l.rows[r][c];
            counts[ch] = (counts[ch] ?? 0) + 1;
          }
        }
        rowConsensus.add(present ? KeyConsensus(row: r, column: c, charCounts: counts) : null);
      }
      rows.add(rowConsensus);
    }
    return rows;
  }
}