import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/ansi_keyboard.dart';
import '../../domain/models/comparison_session.dart';
import '../../domain/models/comparison_style.dart';
import '../../domain/models/layout.dart';
import '../../domain/models/ortholinear_keyboard.dart';
import '../../domain/models/physical_keyboard.dart';
import '../widgets/comparison_style_editor.dart';
import '../widgets/key_content_resolver.dart';
import '../widgets/keyboard_controls.dart';
import '../widgets/physical_keyboard_view.dart';
import 'about_screen.dart';
import 'radar_comparison_screen.dart';

/// Primary screen. A real physical keyboard (AnsiKeyboardGeometry) with 2–5
/// layouts' characters rendered inside each letter key, plus consensus badges.
class KeyboardComparisonScreen extends ConsumerWidget {
  const KeyboardComparisonScreen({super.key});

  /// Choose the physical geometry/scope — four distinct combinations across two
  /// INDEPENDENT dimensions: geometry (Staggered/Ortholinear) × scope
  /// (Full/Simplified). Simplified is a **crop** of the full physical keyboard's
  /// character-key region (via `.simplified()`); it never relocates or resizes
  /// the character keys, so the stagger (or aligned grid) is preserved.
  PhysicalKeyboardGeometry _geometryFor(ComparisonSession session) {
    final full = session.keyboard.geometry == PhysicalGeometry.ortholinear
        ? fullOrthoGeo
        : fullStaggeredGeo;
    return session.keyboard.scope == KeyboardScope.simplified ? full.simplified() : full;
  }
  static final fullStaggeredGeo = AnsiKeyboardGeometry();
  static final fullOrthoGeo = OrtholinearKeyboardGeometry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(comparisonSessionProvider);
    final repo = ref.watch(repositoryProvider);

    // The glyph map must follow the *currently displayed* geometry's letter
    // keys (Staggered shows 13/11/10 chars; Ortholinear shows the first 10 of
    // each row) so that Simplified crops and Full both render the same keys.
    final geometry = _geometryFor(session);
    final resolver = KeyContentResolver(geometry: geometry);

    final selected = <KeyboardLayout>[];
    for (final id in session.layoutIds) {
      final lay = repo.layoutById(id);
      if (lay != null) selected.add(lay);
    }
    final glyphMatrix = resolver.buildKeyGlyphMatrix(selected);

    final cells = resolver.cellsFor(session.style, selected.length);

    KeyContent resolveKey(PhysicalKey key) {
      final glyphs = glyphMatrix['${key.row}:${key.opticalColumn}'] ?? const [];
      return resolver.resolve(key, glyphs, session, cells);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _Header(session: session),
              const SizedBox(height: 8),
              Expanded(
                child: PhysicalKeyboardView(
                  geometry: geometry,
                  showComparison: session.length > 1,
                  keyContentResolver: resolveKey,
                ),
              ),
              const SizedBox(height: 8),
              // Shared bottom toolbar: Radar + the two binary toggles.
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RadarComparisonScreen()),
                    ),
                    icon: const Icon(Icons.radar, size: 18),
                    label: const Text('Radar'),
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1E88E5)),
                  ),
                  const Spacer(),
                  const KeyboardControls(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final ComparisonSession session;
  const _Header({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    return Row(
      children: [
        const Text('Comparing',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (var i = 0; i < session.layoutIds.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _Chip(
                    color: session.colors[i],
                    label: repo.layoutById(session.layoutIds[i])?.name ?? session.layoutIds[i],
                  ),
                ),
            ]),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.white70, size: 20),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _LayoutSelectorScreen()),
          ),
          tooltip: 'Choose layouts & how to display',
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white70, size: 20),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          ),
          tooltip: 'About & support',
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final Color color;
  final String label;
  const _Chip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.18),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ]),
    );
  }
}

class _LayoutSelectorScreen extends ConsumerWidget {
  const _LayoutSelectorScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layouts = ref.watch(layoutsProvider);
    final session = ref.watch(comparisonSessionProvider);
    final notifier = ref.read(comparisonSessionProvider.notifier);
    final repo = ref.watch(repositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Choose layouts to compare', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RadarLayoutSelector()),
            ),
            tooltip: 'Add layouts',
          ),
        ],
      ),
      body: Column(
        children: [
          // Visualization preset selector (configuration, not layout data).
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: VisualizationSelector(session: session),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 6, runSpacing: 6,
              children: [
                for (var i = 0; i < session.layoutIds.length; i++)
                  Chip(
                    backgroundColor: session.colors[i].withValues(alpha: 0.18),
                    side: BorderSide(color: session.colors[i]),
                    label: Text(repo.layoutById(session.layoutIds[i])?.name ?? session.layoutIds[i],
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                    onDeleted: () => _safeRemove(notifier, session.layoutIds[i]),
                  ),
              ],
            ),
          ),
          if (session.style.visualization == ComparisonVisualization.custom)
            CustomRegionEditor(session: session),
          Expanded(
            child: ListView.builder(
              itemCount: layouts.length,
              itemBuilder: (context, i) {
                final layout = layouts[i];
                final inSession = session.layoutIds.contains(layout.id);
                return ListTile(
                  dense: true,
                  leading: Icon(
                    inSession ? Icons.check_circle : Icons.circle_outlined,
                    color: inSession ? _colorFor(layout.id, session) : Colors.white24,
                    size: 20,
                  ),
                  title: Text(layout.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  onTap: () {
                    if (inSession) {
                      _safeRemove(notifier, layout.id);
                    } else if (!session.isFull) {
                      notifier.addLayout(layout.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Maximum 5 layouts')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _safeRemove(notifier, String id) {
    if (notifier.state.layoutIds.length > 2) notifier.removeLayout(id);
  }

  Color _colorFor(String id, session) {
    for (var i = 0; i < session.layoutIds.length; i++) {
      if (session.layoutIds[i] == id) return session.colors[i];
    }
    return Colors.white24;
  }
}