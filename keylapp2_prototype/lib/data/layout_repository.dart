import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/models/layout.dart';
import '../domain/models/metrics.dart';

/// Loads the canonical bundled dataset into in-memory domain objects.
///
/// This is the application's only data source. Layouts are discovered
/// automatically from `assets/data/layouts.json` — adding a new layout means
/// only adding a JSON entry; no Dart code changes.
class LayoutRepository {
  /// All renderable layouts, keyed by stable id.
  Map<String, KeyboardLayout> _layoutsById = {};

  /// All metric sets, keyed by layout id.
  Map<String, LayoutMetrics> _metricsByLayoutId = {};

  /// All prose descriptions, keyed by layout id.
  Map<String, String> _descriptionsByLayoutId = {};

  bool _loaded = false;

  bool get isLoaded => _loaded;

  List<KeyboardLayout> get allLayouts => _layoutsById.values.toList();

  KeyboardLayout? layoutById(String id) => _layoutsById[id];

  LayoutMetrics? metricsFor(String layoutId) => _metricsByLayoutId[layoutId];

  /// All metric sets indexed by layout id (public accessor for providers).
  Map<String, LayoutMetrics> get metricsById => _metricsByLayoutId;

  String? descriptionFor(String layoutId) => _descriptionsByLayoutId[layoutId];

  /// Loads (once) from the three bundled JSON files in `assets/data/`.
  Future<void> load() async {
    if (_loaded) return;

    final layoutsJson = await rootBundle.loadString('assets/data/layouts.json');
    final metricsJson = await rootBundle.loadString('assets/data/metrics.json');
    final descriptionsJson = await rootBundle.loadString('assets/data/descriptions.json');

    final layouts = (jsonDecode(layoutsJson) as List)
        .map((e) => KeyboardLayout.fromJson(e as Map<String, dynamic>))
        .toList();
    final metrics = (jsonDecode(metricsJson) as List)
        .map((e) => LayoutMetrics.fromJson(e as Map<String, dynamic>))
        .toList();
    final parsedDescriptions = (jsonDecode(descriptionsJson) as List)
        .map((d) => (d as Map<String, dynamic>))
        .toList();

    _layoutsById = { for (final l in layouts) l.id: l };
    _metricsByLayoutId = { for (final m in metrics) m.layoutId: m };
    _descriptionsByLayoutId = {
      for (final d in parsedDescriptions)
        d['layoutId'] as String: d['description'] as String,
    };

    _loaded = true;
  }
}