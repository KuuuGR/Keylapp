import 'package:flutter/material.dart';

import '../../domain/models/physical_keyboard.dart';

/// Renders a single physical key (function or letter). Comparison content is
/// resolved from a shared 9-cell structure (editor == renderer), with the
/// primary layout drawn at an optional larger scale.
///
/// LAYOUT MODEL: The comparison content is rendered *inside* the key's already
/// bounded box using a simple Column-of-Rows (each cell an Expanded). No
/// `Table`/`TableRow` is used, so there is no FlexParentData/TableCellParentData
/// conflict and no `TableBorder` assertion. The physical key owns its geometry;
/// comparison content just fills it.
class PhysicalKeyWidget extends StatelessWidget {
  final PhysicalKey physicalKey;
  final List<String> cellChars;
  final List<Color> cellColors;
  final List<int> cells;            // 9 cells, layout index or -1
  final int primaryLayoutIndex;
  final double primaryScaleFactor;
  final int agreementCount;
  final int layoutCount;
  final bool showComparison;
  final VoidCallback? onTap;

  const PhysicalKeyWidget({
    super.key,
    required this.physicalKey,
    required this.cellChars,
    required this.cellColors,
    required this.cells,
    required this.primaryLayoutIndex,
    required this.primaryScaleFactor,
    required this.agreementCount,
    required this.layoutCount,
    required this.showComparison,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return physicalKey.isFunctionKey ? _functionKey() : _letterKey();
  }

  Widget _functionKey() {
    // Subtle, deliberate visual treatments for important physical keys so they
    // don't collapse into generic empty squares — but never obscured.
    final isBumper = physicalKey.function == 'bumper';
    final isSpace = physicalKey.function == 'space';
    final baseColor = isBumper
        ? const Color(0xFF3A2A4A) // muted violet for bumper keys
        : isSpace
            ? const Color(0xFF2A3A4A) // muted steel-blue for Space
            : const Color(0xFF2A2A3C); // default aux

    Border? border;
    if (isBumper) {
      // Restrained accent ring on bumper keys.
      border = Border.all(color: const Color(0xFFB39DDB).withValues(alpha: 0.35), width: 1.2);
    } else if (isSpace) {
      border = Border.all(color: const Color(0xFF80DEEA).withValues(alpha: 0.35), width: 1.2);
    }

    return Material(
      color: baseColor,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: border,
          ),
          child: Center(
            child: isSpace
                // Space gets a small centred glyph label that reads as a bar.
                ? Icon(Icons.horizontal_rule, color: Colors.white38, size: 16)
                : Text(physicalKey.glyph ?? '',
                    style: const TextStyle(fontSize: 13, color: Colors.white60)),
          ),
        ),
      ),
    );
  }

  Widget _letterKey() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showComparison)
                _comparisonGrid()
              else
                Center(child: _glyphText(cellChars.isNotEmpty ? cellChars.first : '', 1.0)),
              _consensusBadge(),
            ],
          ),
        ),
      ),
    );
  }

  /// 3×3 grid built from a Column of 3 Rows. Each cell is an Expanded inside
  /// a Row (which supports FlexParentData), so it receives a predictable
  /// rectangular area from the parent Stack. Cell value = layout index; -1 =
  /// empty. The primary layout gets a larger font.
  Widget _comparisonGrid() {
    return Column(
      children: [
        for (var row = 0; row < 3; row++)
          Expanded(
            child: Row(
              children: [
                for (var col = 0; col < 3; col++) _cell(row * 3 + col),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cell(int cellIndex) {
    final layoutIndex = cells.length > cellIndex ? cells[cellIndex] : -1;
    final hasLayout = layoutIndex >= 0 && layoutIndex < cellChars.length;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: hasLayout
            ? BoxDecoration(color: cellColors[layoutIndex].withValues(alpha: 0.4))
            : const BoxDecoration(color: Colors.transparent),
        child: hasLayout
            ? Center(child: _glyphText(cellChars[layoutIndex], _scaleFor(layoutIndex)))
            : const SizedBox.shrink(),
      ),
    );
  }

  double _scaleFor(int layoutIndex) =>
      layoutIndex == primaryLayoutIndex ? primaryScaleFactor : 1.0;

  Widget _glyphText(String s, double scale) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(s,
            style: TextStyle(
              fontSize: 14 * scale,
              color: Colors.white,
              fontWeight: scale > 1.0 ? FontWeight.w800 : FontWeight.w600,
            )),
      );

  Widget _consensusBadge() {
    if (agreementCount < 2) return const SizedBox.shrink();
    final unanimous = agreementCount == layoutCount;
    return Positioned(
      right: 2, bottom: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: (unanimous ? Colors.green : Colors.amber).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text('x$agreementCount',
            style: const TextStyle(fontSize: 7, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
    );
  }
}