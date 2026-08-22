import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/comparison_session.dart';
import '../../domain/models/comparison_style.dart';

/// Preset selector: user chooses HOW the layouts are shown inside each key.
class VisualizationSelector extends ConsumerWidget {
  final ComparisonSession session;
  const VisualizationSelector({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(comparisonSessionProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Visualization',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final v in ComparisonVisualization.values)
            ChoiceChip(
              label: Text(_label(v), style: const TextStyle(color: Colors.white, fontSize: 12)),
              selected: session.style.visualization == v,
              selectedColor: const Color(0xFF1E88E5),
              onSelected: (_) => notifier.setStyle(session.style.withVisualization(v)),
            ),
        ]),
      ],
    );
  }

  String _label(ComparisonVisualization v) {
    switch (v) {
      case ComparisonVisualization.largeSmall: return 'Large + Small';
      case ComparisonVisualization.matrix: return 'Matrix';
      case ComparisonVisualization.centerCorners: return 'Center + Corners';
      case ComparisonVisualization.custom: return 'Custom';
    }
  }
}

/// A clean, visual 3×3 single-key editor. Tapping a cell opens a layout picker;
/// the chosen layout appears immediately in that cell. Unused cells stay empty.
/// The same cells are handed to the renderer, so editor == renderer.
class CustomRegionEditor extends ConsumerWidget {
  final ComparisonSession session;
  const CustomRegionEditor({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(comparisonSessionProvider.notifier);
    final repo = ref.watch(repositoryProvider);
    final cells = session.style.customCells ?? ComparisonStyle.defaultCellsFor(session.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        const Text('Tap a cell to place a layout — this is exactly what each key shows.',
            style: TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 8),
        // Sized from constraints: capped square so all 9 cells stay fully
        // visible without overflowing the screen.
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240, maxHeight: 240),
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 240,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    for (var r = 0; r < 3; r++)
                      Expanded(child: Row(children: [
                        for (var c = 0; c < 3; c++)
                          _cell(r * 3 + c, cells, repo, context, notifier),
                      ])),
                  ]),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (var i = 0; i < session.layoutIds.length; i++)
            Chip(
              backgroundColor: session.colors[i].withValues(alpha: 0.18),
              side: BorderSide(color: session.colors[i]),
              label: Text('${i + 1}. ${repo.layoutById(session.layoutIds[i])?.name ?? session.layoutIds[i]}',
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
        ]),
        const SizedBox(height: 8),
        const Text('Primary layout size', style: TextStyle(color: Colors.white70, fontSize: 12)),
        Wrap(spacing: 6, children: [
          for (final scale in PrimaryScale.values)
            ChoiceChip(
              label: Text(_scaleLabel(scale), style: const TextStyle(color: Colors.white, fontSize: 11)),
              selected: session.style.primaryScale == scale,
              selectedColor: const Color(0xFF1E88E5),
              onSelected: (_) => notifier.setStyle(session.style.withCustomCells(cells, scale: scale)),
            ),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _cell(int idx, List<int> cells, repo, BuildContext context, notifier) {
    final layoutIndex = cells.length > idx ? cells[idx] : -1;
    final hasLayout = layoutIndex >= 0 && layoutIndex < session.layoutIds.length;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pick(context, notifier, repo, cells, idx),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: hasLayout ? session.colors[layoutIndex].withValues(alpha: 0.4) : Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: hasLayout ? session.colors[layoutIndex] : Colors.white12),
          ),
          child: Center(
            child: hasLayout
                ? Text(repo.layoutById(session.layoutIds[layoutIndex])?.name ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 10))
                : const Icon(Icons.add, color: Colors.white24, size: 18),
          ),
        ),
      ),
    );
  }

  void _pick(BuildContext context, notifier, repo, List<int> cells, int idx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(padding: EdgeInsets.all(12), child: Text('Choose layout', style: TextStyle(color: Colors.white))),
          for (var i = 0; i < session.layoutIds.length; i++)
            ListTile(
              leading: Icon(Icons.circle, color: session.colors[i], size: 16),
              title: Text('${i + 1}. ${repo.layoutById(session.layoutIds[i])?.name ?? session.layoutIds[i]}',
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                final next = List<int>.of(cells);
                final isNew = !cells.contains(i);
                next[idx] = i;
                notifier.setStyle(session.style.withCustomCells(next, primary: isNew ? i : session.style.primaryLayoutIndex));
                Navigator.pop(ctx);
              },
            ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  String _scaleLabel(PrimaryScale s) {
    switch (s) {
      case PrimaryScale.equal: return 'Equal';
      case PrimaryScale.scale1_5: return '1.5×';
      case PrimaryScale.scale2: return '2×';
    }
  }
}