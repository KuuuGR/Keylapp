import 'models/metrics.dart';

/// Represents a single point on the radar for one metric axis.
class RadarPoint {
  final MetricKey key;
  /// Normalized value in 0.0..1.0 (inverted for lower-better metrics so a
  /// "larger polygon area = better" reads intuitively).
  final double normalized;
  /// The raw measured value before normalization.
  final double raw;

  const RadarPoint({required this.key, required this.normalized, required this.raw});
}

/// Calculates the normalized plotting values and per-axis scale caps for the
/// radar chart.
///
/// Scaling strategy:
///  - Per-axis caps are derived from the MAX value across ALL candidate layouts
///    (not just the selected set) so adding/removing a layout in the session
///    doesn't rescale the whole chart and shift the interpretation.
///  - "Lower-better" metrics are inverted (1.0 - value/cap) so the polygon
///    shape communicates overall quality at a glance.
class RadarScaling {
  /// All metrics whose value we want to honor for cap calculation.
  final Map<String, LayoutMetrics> allMetrics;
  /// The metric keys plotted on the radar.
  final List<MetricKey> plottedKeys;

  RadarScaling({
    required this.allMetrics,
    required this.plottedKeys,
  });

  /// Compute per-axis max caps from every available metric datum.
  Map<MetricKey, double> computeCaps() {
    final caps = <MetricKey, double>{
      for (final k in plottedKeys) k: 0.0,
    };
    for (final m in allMetrics.values) {
      for (final k in plottedKeys) {
        final v = m.valueOf(k);
        if (v != null && v > caps[k]!) caps[k] = v;
      }
    }
    // Add a small headroom so a max value doesn't kiss the ring; also ensure a
    // non-zero floor.
    return {
      for (final k in plottedKeys) k: (caps[k]! * 1.05) + 0.001,
    };
  }

  /// Produce the radar points for one layout, using [caps].
  List<RadarPoint> pointsFor(LayoutMetrics? metrics, Map<MetricKey, double> caps) {
    if (metrics == null) return const [];
    final points = <RadarPoint>[];
    double dirMult(MetricKey k) =>
        kMetricDefinitions.firstWhere((d) => d.key == k).direction == MetricDirection.higherBetter
            ? 1.0
            : -1.0;

    for (final k in plottedKeys) {
      final raw = metrics.valueOf(k);
      if (raw == null) continue; // not measured for this layout
      final cap = caps[k]!;
      var normalized = (raw / cap).clamp(0.0, 1.0);
      // Invert low-better axis so area = quality.
      if (dirMult(k) < 0) normalized = 1.0 - normalized;
      points.add(RadarPoint(key: k, normalized: normalized, raw: raw));
    }
    return points;
  }
}