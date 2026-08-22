import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/layout_repository.dart';
import '../domain/models/comparison_session.dart';
import '../domain/models/comparison_style.dart';
import '../domain/models/layout.dart';
import '../domain/models/metrics.dart';

/// The single source of truth for app data — loaded once at startup.
final repositoryProvider = Provider<LayoutRepository>((ref) => LayoutRepository());

/// Async provider that resolves once the bundled data is loaded & decoded.
final dataLoadedProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(repositoryProvider);
  await repo.load();
});

/// All layouts (after load). Mirrors [LayoutRepository.allLayouts].
final layoutsProvider = Provider<List<KeyboardLayout>>((ref) {
  ref.watch(dataLoadedProvider);
  return ref.watch(repositoryProvider).allLayouts;
});

/// Metrics indexed by layout id.
final metricsProvider = Provider<Map<String, LayoutMetrics>>((ref) {
  ref.watch(dataLoadedProvider);
  return ref.watch(repositoryProvider).metricsById;
});

/// A session-scoped "current comparison" — the selected layout ids plus
/// derived colors. Persisted to disk via SharedPreferences.
class ComparisonSessionNotifier extends Notifier<ComparisonSession> {
  static const _key = 'comparison.session.layoutIds';
  static const _styleKey = 'comparison.session.style';

  @override
  ComparisonSession build() {
    // Initial load from storage; fall back to QWERTY + Colemak.
    final restored = _restore();
    return restored ?? ComparisonSession.defaultSession();
  }

  ComparisonSession? _restore() {
    try {
      final prefs = _prefsSync();
      if (prefs == null) return null;
      final ids = prefs.getStringList(_key);
      if (ids == null || ids.length < ComparisonSession.minLayouts || ids.length > ComparisonSession.maxLayouts) {
        return null;
      }
      final styleName = prefs.getString(_styleKey);
      ComparisonVisualization viz = ComparisonVisualization.largeSmall;
      for (final v in ComparisonVisualization.values) {
        if (v.name == styleName) viz = v;
      }
      return ComparisonSession(layoutIds: ids, style: ComparisonStyle(visualization: viz));
    } catch (_) {
      return null;
    }
  }

  /// Best-effort synchronous prefs for the notifier build. (Real apps use
  /// SharedPreferencesAsync; this keeps the prototype simple & synchronous.)
  SharedPreferences? _prefsSync() {
    // SharedPreferences.getInstance() is async; we cache a global handle set
    // at app start (see main()). Fall back to null before that.
    return _prefs;
  }

  void replaceSession(ComparisonSession session) {
    state = session;
    _save(session);
  }

  void addLayout(String layoutId) {
    if (state.layoutIds.contains(layoutId)) return;
    if (state.isFull) return;
    replaceSession(state.copyWith(layoutIds: [...state.layoutIds, layoutId]));
  }

  void removeLayout(String layoutId) {
    if (state.layoutIds.length <= ComparisonSession.minLayouts) return; // keep >= 2
    replaceSession(state.copyWith(layoutIds: state.layoutIds.where((i) => i != layoutId).toList()));
  }

  void moveLayout(int from, int to) {
    final ids = [...state.layoutIds];
    if (from < 0 || from >= ids.length || to < 0 || to >= ids.length) return;
    final moved = ids.removeAt(from);
    ids.insert(to, moved);
    replaceSession(state.copyWith(layoutIds: ids));
  }

  void setStyle(ComparisonStyle style) {
    replaceSession(state.copyWith(style: style));
  }

  void setKeyboard(KeyboardConfiguration keyboard) {
    replaceSession(state.copyWith(keyboard: keyboard));
  }

  void _save(ComparisonSession session) {
    try {
      _prefsSync()?.setStringList(_key, session.layoutIds);
      _prefsSync()?.setString(_styleKey, session.style.visualization.name);
    } catch (_) {}
  }
}

final comparisonSessionProvider =
    NotifierProvider<ComparisonSessionNotifier, ComparisonSession>(ComparisonSessionNotifier.new);

/// Cached global SharedPreferences handle set during [main].
SharedPreferences? _prefs;
void cachePreferences(SharedPreferences prefs) => _prefs = prefs;