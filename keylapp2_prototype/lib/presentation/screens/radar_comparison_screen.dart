import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/metrics.dart';
import '../services/radar_colors.dart';

/// Radar comparison — preserves the original Keylapp radar character while
/// extending to 2–5 layouts:
///  - dark background, circular grid, radial axes, labels
///  - semi-transparent filled polygons that overlap readably
///  - interactive axes: tap a label to open a data-driven metric explanation
///  - hand balance below, per selected layout
///  - subtle "Keylapp" branding so screenshots are identifiable
///
/// RENDER FIX: the radar is a single self-contained GestureDetector +
/// CustomPainter sized by an explicit square box (never an AspectRatio inside
/// a scroll view, which gave it zero height). This guarantees the grid, axes,
/// labels and polygons always paint.
class RadarComparisonScreen extends ConsumerWidget {
  const RadarComparisonScreen({super.key});

  static const caps = <double>[50, 50, 50, 50, 50, 10, 10];
  static const axisKeys = <MetricKey>[
    MetricKey.alternation,
    MetricKey.rolling,
    MetricKey.oneHand,
    MetricKey.redirect,
    MetricKey.badRedirect,
    MetricKey.sfb,
    MetricKey.sfs,
  ];
  static const dividerCount = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(comparisonSessionProvider);
    final allMetrics = ref.watch(metricsProvider);
    final repo = ref.watch(repositoryProvider);

    final layers = <_RadarLayer>[];
    for (var i = 0; i < session.layoutIds.length; i++) {
      final id = session.layoutIds[i];
      final name = repo.layoutById(id)?.name ?? id;
      final metrics = allMetrics[id];
      layers.add(_RadarLayer(
        name: name,
        color: RadarColorPalette.forIndex(i),
        values: _valuesFor(metrics),
        lh: metrics?.valueOf(MetricKey.leftHand),
        rh: metrics?.valueOf(MetricKey.rightHand),
      ));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Layout comparison', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RadarLayoutSelector()),
            ),
            tooltip: 'Change layouts',
          ),
        ],
      ),
      /// Responsive layout: on landscape/short windows the hand balance sits to
      /// the side (horizontal), so nothing stacks vertically and overflows.
      /// The radar chart always fits inside a bounded area; extra content scrolls.
      body: LayoutBuilder(builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final side = _HandBalancePanel(layers: layers, width: isLandscape ? 240 : 280);
        // Bounded square radar that fits the available space minus legend room.
        final legendHeight = 92.0;
        final boundForRadar = isLandscape
            ? constraints.maxHeight
            : (constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight) - legendHeight;
        final radarSize = (boundForRadar - 10).clamp(120.0, isLandscape ? 460.0 : 360.0);
        if (radarSize <= 0) return const SizedBox.shrink();

        final radar = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: radarSize,
              height: radarSize,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final key = _metricAt(details.localPosition, radarSize);
                  if (key != null) _showMetricExplanation(context, metricDefinitionFor(key));
                },
                child: CustomPaint(
                  size: Size(radarSize, radarSize),
                  painter: _RadarPainter(layers: layers),
                ),
              ),
            ),
            _legend(layers),
            const Text('Keylapp', style: TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 12)),
            const SizedBox(height: 8),
          ],
        );

        return isLandscape
            // Landscape: radar on the left (bounded), hand balance on the right.
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: radar),
                  const SizedBox(width: 12),
                  side,
                ]),
              )
            // Portrait: radar on top, hand balance scrolls below.
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [radar, const SizedBox(height: 8), side]),
                ),
              );
      }),
    );
  }

  /// Map a tapped local position to the nearest metric axis (interactive axes).
  MetricKey? _metricAt(Offset local, double size) {
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 60;
    final dx = local.dx - center.dx;
    final dy = local.dy - center.dy;
    if (math.sqrt(dx * dx + dy * dy) < radius * 0.6) return null; // ignore center hits
    final angle = math.atan2(local.dy - center.dy, local.dx - center.dx);
    if (angle < 0) return axisKeys[MathUtils.closest(angle + 2 * math.pi, axisKeys.length)];
    return axisKeys[MathUtils.closest(angle, axisKeys.length)];
  }

  Widget _legend(List<_RadarLayer> layers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: [
          for (final l in layers)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: l.color, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(l.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
              if (l.values == null)
                const Text(' (no data)', style: TextStyle(color: Colors.amber, fontSize: 10)),
            ]),
        ],
      ),
    );
  }

  List<double>? _valuesFor(LayoutMetrics? m) {
    if (m == null) return null;
    final values = <double>[];
    for (final k in axisKeys) {
      final v = m.valueOf(k);
      if (v == null) return null;
      values.add(v);
    }
    return values;
  }

  void _showMetricExplanation(BuildContext context, MetricDefinition def) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      builder: (ctx) => _MetricExplanationSheet(definition: def),
    );
  }
}

/// Small math helper to avoid a dependency on `dart:math` at call sites above.
abstract final class MathUtils {
  static int closest(double angle, int n) {
    var best = 0;
    var bestDiff = double.infinity;
    for (var i = 0; i < n; i++) {
      final a = 2 * math.pi / n * i;
      var diff = (a - angle).abs();
      if (diff > 2 * math.pi) diff = (2 * math.pi - diff).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = i;
      }
    }
    return best;
  }
}

class _RadarLayer {
  final String name;
  final Color color;
  final List<double>? values;
  final double? lh;
  final double? rh;
  const _RadarLayer({required this.name, required this.color, required this.values, this.lh, this.rh});
}

/// Self-contained painter: draws grid rings, axes, labels, and polygons all in
/// one place. Called with an explicit square size so it always has pixels.
class _RadarPainter extends CustomPainter {
  final List<_RadarLayer> layers;
  _RadarPainter({required this.layers});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = (w < h ? w : h) / 2 - 60;
    if (radius <= 0) return;
    final n = RadarComparisonScreen.axisKeys.length;

    // Background fill so the canvas is never transparent-looking.
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF12121E));

    // Circular grid rings (original: 4 dividers at radius×(i+1)/5).
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < RadarComparisonScreen.dividerCount; i++) {
      canvas.drawCircle(center, radius * (i + 1) / (RadarComparisonScreen.dividerCount + 1), gridPaint);
    }

    // Radial axes + labels (labels drawn here, rotated like the original).
    for (var i = 0; i < n; i++) {
      final angle = 2 * math.pi / n * i;
      final end = center + Offset(radius * math.cos(angle), radius * math.sin(angle));
      canvas.drawLine(center, end, gridPaint);

      final def = metricDefinitionFor(RadarComparisonScreen.axisKeys[i]);
      final labelPos = center + Offset((radius + 14) * math.cos(angle), (radius + 14) * math.sin(angle));
      final tp = TextPainter(
        text: TextSpan(text: def.abbreviation, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(labelPos.dx, labelPos.dy);
      canvas.rotate(angle);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Polygons: semi-transparent fills + colored strokes.
    for (final layer in layers) {
      final values = layer.values;
      if (values == null || values.length < n) continue;
      final path = Path();
      for (var i = 0; i < n; i++) {
        final angle = 2 * math.pi / n * i;
        final valueRadius = radius * (values[i] / RadarComparisonScreen.caps[i]);
        final point = center + Offset(valueRadius * math.cos(angle), valueRadius * math.sin(angle));
        if (i == 0) path.moveTo(point.dx, point.dy);
        else path.lineTo(point.dx, point.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()
        ..color = layer.color.withValues(alpha: RadarColorPalette.fillAlpha)
        ..style = PaintingStyle.fill);
      canvas.drawPath(path, Paint()
        ..color = layer.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.layers != layers;
}

/// The data-driven metric explanation sheet (one generic sheet per metric).
class _MetricExplanationSheet extends StatelessWidget {
  final MetricDefinition definition;
  const _MetricExplanationSheet({required this.definition});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('${definition.icon} ', style: const TextStyle(fontSize: 20)),
              Expanded(child: Text(definition.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 8),
            Text(definition.description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(definition.directionNote, style: const TextStyle(color: Colors.lightGreenAccent)),
            const SizedBox(height: 12),
            Text('What it measures', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(definition.explanation, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 12),
            Text('Example', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(definition.example, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

/// Hand balance per selected layout — preserved from the original.
class _HandBalancePanel extends StatelessWidget {
  final List<_RadarLayer> layers;
  final double width;
  const _HandBalancePanel({required this.layers, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hand Balance', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final l in layers)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.name, style: TextStyle(color: l.color, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                if (l.lh == null)
                  const Text('no data', style: TextStyle(color: Colors.amber, fontSize: 11))
                else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 16,
                      child: Row(children: [
                        Expanded(flex: (l.lh! * 100).toInt(), child: Container(color: l.color.withValues(alpha: 0.55))),
                        Expanded(flex: (l.rh! * 100).toInt(), child: Container(color: l.color)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text('LH: ${l.lh!.toStringAsFixed(1)}%  •  RH: ${l.rh!.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white54, fontSize: 10)),
                ],
              ]),
            ),
        ],
      ),
    );
  }
}

/// The single shared layout-selector used by both Radar and keyboard
/// comparison. One source of truth for available/selected layouts, add/remove,
/// limits and identity.
class RadarLayoutSelector extends ConsumerWidget {
  const RadarLayoutSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layouts = ref.watch(layoutsProvider);
    final session = ref.watch(comparisonSessionProvider);
    final notifier = ref.read(comparisonSessionProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Change compared layouts', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: layouts.length,
        itemBuilder: (context, i) {
          final layout = layouts[i];
          final inSession = session.layoutIds.contains(layout.id);
          final selColor = inSession ? session.colors[session.layoutIds.indexOf(layout.id)] : Colors.white24;
          return ListTile(
            dense: true,
            leading: Icon(
              inSession ? Icons.check_circle : Icons.circle_outlined,
              color: selColor,
              size: 20,
            ),
            title: Text(layout.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
            onTap: () {
              if (inSession) {
                if (session.layoutIds.length > 2) notifier.removeLayout(layout.id);
              } else if (!session.isFull) {
                notifier.addLayout(layout.id);
              }
            },
          );
        },
      ),
    );
  }
}