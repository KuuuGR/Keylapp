import 'package:flutter/material.dart';

/// Draws a single physical key with the compared layouts' characters split
/// visually and color-coded. Layout count maps to a subdivision strategy:
///
///  2 → vertical split (top / bottom)
///  3 → three horizontal bands
///  4 → four quadrants
///  5 → four corners + center (the "5" strategy from the spec)
///
/// Includes a subtle consensus indicator (agreement badge).
class KeyComparisonCell extends StatelessWidget {
  final List<String> chars; // char for each selected layout, in session order
  final List<Color> colors;  // same length as chars
  final int agreementCount;
  final int layoutCount;
  final VoidCallback onTap;

  const KeyComparisonCell({
    super.key,
    required this.chars,
    required this.colors,
    required this.agreementCount,
    required this.layoutCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24),
            color: const Color(0xFF1E1E2E),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: _buildSplit()),
              _consensusBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplit() {
    switch (layoutCount) {
      case 2:
        return _verticalSplit(2);
      case 3:
        return _verticalSplit(3);
      case 4:
        return _quadrant();
      case 5:
        return _fiveSplit();
      default:
        return _verticalSplit(2);
    }
  }

  // Vertical bands (top..bottom) staggered so each char is legible.
  Widget _verticalSplit(int bands) {
    return Column(
      children: [
        for (var i = 0; i < bands; i++)
          Expanded(
            child: Container(
              color: colors[i % colors.length].withValues(alpha: 0.55),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  chars[i % chars.length],
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _quadrant() {
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            _quadrantChild(0, Alignment.topLeft, '↖'),
            _quadrantChild(1, Alignment.topRight, '↗'),
          ]),
        ),
        Expanded(
          child: Row(children: [
            _quadrantChild(2, Alignment.bottomLeft, '↙'),
            _quadrantChild(3, Alignment.bottomRight, '↘'),
          ]),
        ),
      ],
    );
  }

  Widget _quadrantChild(int index, Alignment align, String hint) {
    return Expanded(
      child: Container(
        color: colors[index % colors.length].withValues(alpha: 0.5),
        alignment: align,
        padding: const EdgeInsets.all(2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(chars[index % chars.length], style: _smallStyle()),
        ),
      ),
    );
  }

  // 5: four corners + center (the order is top-left, top-right, bottom-left,
  // bottom-right, then center for the 5th layout).
  Widget _fiveSplit() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(alignment: Alignment.topLeft, child: _cornerChar(0)),
        Align(alignment: Alignment.topRight, child: _cornerChar(1)),
        Align(alignment: Alignment.bottomLeft, child: _cornerChar(2)),
        Align(alignment: Alignment.bottomRight, child: _cornerChar(3)),
        Align(alignment: Alignment.center, child: _centerChar(4)),
      ],
    );
  }

  Widget _cornerChar(int index) {
    return Container(
      width: 18, height: 18,
      color: colors[index % colors.length].withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(chars[index % chars.length], style: _smallStyle()),
      ),
    );
  }

  Widget _centerChar(int index) {
    return Container(
      width: 20, height: 20,
      color: colors[index % colors.length].withValues(alpha: 0.9),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(chars[index % chars.length],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black)),
      ),
    );
  }

  TextStyle _smallStyle() =>
      const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w600);

  Widget _consensusBadge() {
    if (agreementCount < 2) return const SizedBox.shrink();
    final unanimous = agreementCount == layoutCount;
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: unanimous ? Colors.green.withValues(alpha: 0.85) : Colors.amber.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'x$agreementCount',
          style: const TextStyle(fontSize: 7, color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}