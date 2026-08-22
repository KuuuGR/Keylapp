import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/comparison_style.dart';

/// Two compact, independent toggle buttons for the physical-keyboard:
/// geometry (Staggered ⇄ Ortholinear) and scope (Full ⇄ Simplified).
/// Each button describes the **current** state (a two-state toggle), so the
/// single visible label encodes the binary choice. Uses complementary pastel
/// UI colors (distinct from the radar layout colors).
class KeyboardControls extends ConsumerWidget {
  const KeyboardControls({super.key});

  static const _cyan = Color(0xFF80DEEA);
  static const _lavender = Color(0xFFB39DDB);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(comparisonSessionProvider);
    final kbd = session.keyboard;
    final notifier = ref.read(comparisonSessionProvider.notifier);

    final isStaggered = kbd.geometry == PhysicalGeometry.staggered;
    final isFull = kbd.scope == KeyboardScope.full;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label describes the CURRENT visible keyboard (a two-state toggle).
        _Toggle(label: isStaggered ? 'Staggered' : 'Ortholinear', color: _cyan,
            onTap: () => notifier.setKeyboard(kbd.copyWith(
                geometry: isStaggered ? PhysicalGeometry.ortholinear : PhysicalGeometry.staggered))),
        const SizedBox(width: 8),
        _Toggle(label: isFull ? 'Full' : 'Simplified', color: _lavender,
            onTap: () => notifier.setKeyboard(kbd.copyWith(
                scope: isFull ? KeyboardScope.simplified : KeyboardScope.full))),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Toggle({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(16),
          color: color.withValues(alpha: 0.16),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}