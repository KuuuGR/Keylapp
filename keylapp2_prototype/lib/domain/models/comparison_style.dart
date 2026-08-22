/// Comparison visualization is **configuration**, completely separate from
/// layout data and from comparison state.
///
/// Principle: Layouts are data. Comparison is state. Visualization is config.
/// Rendering is implementation.
///
/// The Custom mode uses a **3×3 visual key editor** (9 cells). Each cell can
/// hold one selected layout (or be empty). One layout may be marked *primary*,
/// and rendered larger (Equal / 1.5× / 2×).

/// The primary-layout draw scale.
enum PrimaryScale { equal, scale1_5, scale2 }

/// The 3×3 visual cells of a custom key. Values map 1:1 to cell positions.
enum KeyCell { c00, c01, c02, c10, c11, c12, c20, c21, c22 }

/// Presets — distinct ways to subdivide a physical key.
enum ComparisonVisualization {
  largeSmall,
  matrix,
  centerCorners,
  custom,
}

/// Independent physical-geometry choice.
enum PhysicalGeometry { staggered, ortholinear }

/// Independent scope of the keyboard (how much is shown).
enum KeyboardScope { full, simplified }

/// Independent physical-keyboard configuration (geometry + scope).
class KeyboardConfiguration {
  final PhysicalGeometry geometry;
  final KeyboardScope scope;
  const KeyboardConfiguration({this.geometry = PhysicalGeometry.staggered, this.scope = KeyboardScope.full});
  KeyboardConfiguration copyWith({PhysicalGeometry? geometry, KeyboardScope? scope}) =>
      KeyboardConfiguration(geometry: geometry ?? this.geometry, scope: scope ?? this.scope);
}

/// The persisted configuration describing HOW the selected layouts are shown.
/// Does NOT store any layout id — it maps cell indices (not regions) so the
/// editor IS the configuration; the renderer reads the exact same structure.
class ComparisonStyle {
  final ComparisonVisualization visualization;

  /// For `custom`: 9 cells, each holding a layout index (-1 = empty).
  final List<int>? customCells;

  /// The layout index (in session order) that is shown larger; -1 = none.
  final int primaryLayoutIndex;

  /// How much larger the primary layout is drawn (Equal default).
  final PrimaryScale primaryScale;

  const ComparisonStyle({
    this.visualization = ComparisonVisualization.largeSmall,
    this.customCells,
    this.primaryLayoutIndex = -1,
    this.primaryScale = PrimaryScale.equal,
  });

  ComparisonStyle withVisualization(ComparisonVisualization v) =>
      ComparisonStyle(
          visualization: v, customCells: customCells, primaryLayoutIndex: primaryLayoutIndex, primaryScale: primaryScale);

  ComparisonStyle withCustomCells(List<int>? cells, {int? primary, PrimaryScale? scale}) =>
      ComparisonStyle(
          visualization: ComparisonVisualization.custom,
          customCells: cells ?? customCells,
          primaryLayoutIndex: primary ?? primaryLayoutIndex,
          primaryScale: scale ?? primaryScale);

  /// Default 3×3 custom layout for N layouts — center primary, corners around.
  static List<int> defaultCellsFor(int count) {
    // Center cell is c11 (index 4). Surround: TL, TR, BL, BR = c00,c02,c20,c22.
    final cells = List<int>.filled(9, -1);
    cells[4] = 0; // primary
    switch (count) {
      case 2:
        cells[0] = 1;
        break;
      case 3:
        cells[0] = 1;
        cells[2] = 2;
        break;
      case 4:
        cells[0] = 1;
        cells[2] = 2;
        cells[6] = 3;
        break;
      default:
        cells[0] = 1;
        cells[2] = 2;
        cells[6] = 3;
        cells[8] = 4;
    }
    return cells;
  }

  /// Reads the layout index in a cell (safe against out-of-range).
  int cellAt(int index) =>
      (customCells != null && index < customCells!.length) ? customCells![index] : -1;

  /// The primary layout's scale as a text/typography multiplier hint.
  double get primaryScaleFactor {
    switch (primaryScale) {
      case PrimaryScale.equal: return 1.0;
      case PrimaryScale.scale1_5: return 1.5;
      case PrimaryScale.scale2: return 2.0;
    }
  }
}