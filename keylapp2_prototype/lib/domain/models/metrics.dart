/// Whether a higher numeric value is better or worse for this metric.
enum MetricDirection { higherBetter, lowerBetter }

/// The metric keys used across the application (distinct from display names).
enum MetricKey {
  alternation('alt'), rolling('roll'), oneHand('one'), redirect('rtl'),
  badRedirect('red'), sfb('sfb'), sfs('sfs'), leftHand('lh'), rightHand('rh');

  final String jsonKey;
  const MetricKey(this.jsonKey);

  static MetricKey? fromJsonKey(String k) {
    for (final m in values) { if (m.jsonKey == k) return m; }
    return null;
  }
}

/// A fully data-driven metric definition. The radar uses [key] to open the
/// correct explanation; no per-metric UI screen is needed. Adding a new metric
/// = add an entry here (and the data key); the views are generic.
class MetricDefinition {
  final MetricKey key;
  final String name;         // display name, e.g. 'Alternation'
  final String abbreviation; // short label, e.g. 'Alt'
  final String description;  // one-line what it is
  final String directionNote;// 'Higher is better' / 'Lower is better'
  final String explanation;  // longer prose
  final String example;      // concrete example
  final String icon;         // emoji/icon glyph for affinity/branding

  const MetricDefinition({
    required this.key,
    required this.name,
    required this.abbreviation,
    required this.description,
    required this.directionNote,
    required this.explanation,
    required this.example,
    required this.icon,
  });

  MetricDirection get direction =>
      (key == MetricKey.alternation || key == MetricKey.rolling || key == MetricKey.leftHand || key == MetricKey.rightHand)
          ? MetricDirection.higherBetter
          : MetricDirection.lowerBetter;
}

/// All metric definitions — the single source for labels, descriptions,
/// directions, examples and icons. Views read from here; no hardcoded per-metric
/// screens.
const List<MetricDefinition> kMetricDefinitions = [
  MetricDefinition(
    key: MetricKey.alternation,
    name: 'Alternation',
    abbreviation: 'Alt',
    description: 'Share of bigrams that switch hands.',
    directionNote: 'Higher is better — alternating hands is natural and rhythmic.',
    explanation: 'Measures how often typing switches between hands. Higher values promote rhythm and reduce fatigue.',
    example: 'Typing "ad" alternates hands, while "as" uses the same hand.',
    icon: '🔄',
  ),
  MetricDefinition(
    key: MetricKey.rolling,
    name: 'Rolling',
    abbreviation: 'Roll',
    description: 'Share of smooth same-hand rolls (e.g. "asd").',
    directionNote: 'Higher is better — rolls feel fluid and fast.',
    explanation: 'Measures flowing finger movements in one direction, like "asd".',
    example: '"jkl" forms a right-hand inward roll.',
    icon: '🔁',
  ),
  MetricDefinition(
    key: MetricKey.oneHand,
    name: 'One-Hand',
    abbreviation: '1H',
    description: 'Share of runs typed entirely by one hand.',
    directionNote: 'Lower is better — extended one-hand runs are tiring.',
    explanation: 'Shows how often one hand types multiple keys in a row.',
    example: '"fast" on QWERTY is mostly typed with the left hand.',
    icon: '✋',
  ),
  MetricDefinition(
    key: MetricKey.redirect,
    name: 'Redirect',
    abbreviation: 'Rtl',
    description: 'Direction reversals within a hand.',
    directionNote: 'Lower is better — redirects interrupt flow.',
    explanation: 'Measures changes in finger or hand direction that break flow.',
    example: 'Typing "lo" then "k" creates a redirect on the right hand.',
    icon: '↩️',
  ),
  MetricDefinition(
    key: MetricKey.badRedirect,
    name: 'Bad Redirect',
    abbreviation: 'Red',
    description: 'Redirects that involve weak fingers.',
    directionNote: 'Lower is much better — these are the most awkward.',
    explanation: 'Especially disruptive direction changes, often with weak fingers.',
    example: '"plk" requires an awkward right-hand movement.',
    icon: '🚫',
  ),
  MetricDefinition(
    key: MetricKey.sfb,
    name: 'Same-Finger Bigram',
    abbreviation: 'SFB',
    description: 'Two consecutive strokes on the same finger.',
    directionNote: 'Lower is better — sfb are slow and tiring.',
    explanation: 'Measures consecutive keypresses using the same finger.',
    example: '"ed" on QWERTY uses the same finger (middle).',
    icon: '🧍',
  ),
  MetricDefinition(
    key: MetricKey.sfs,
    name: 'Same-Finger Skip',
    abbreviation: 'SFS',
    description: 'Same finger with a key in between.',
    directionNote: 'Lower is better — sfs require awkward finger travel.',
    explanation: 'Measures skips over keys with the same finger.',
    example: 'Typing "e" then "t" with the index finger.',
    icon: '🦘',
  ),
  MetricDefinition(
    key: MetricKey.leftHand,
    name: 'Left-Hand Load',
    abbreviation: 'LH',
    description: 'Percentage of keystrokes on the left hand.',
    directionNote: 'Not plotted on the radar; shown as hand balance.',
    explanation: 'Percentage of keystrokes on the left hand.',
    example: 'A 54% LH means most typing uses the left hand.',
    icon: '←',
  ),
  MetricDefinition(
    key: MetricKey.rightHand,
    name: 'Right-Hand Load',
    abbreviation: 'RH',
    description: 'Percentage of keystrokes on the right hand.',
    directionNote: 'Not plotted on the radar; shown as hand balance.',
    explanation: 'Percentage of keystrokes on the right hand.',
    example: 'A 46% RH means less typing uses the right hand.',
    icon: '→',
  ),
];

/// Convenience lookup used by the radar to open an explanation.
MetricDefinition metricDefinitionFor(MetricKey key) =>
    kMetricDefinitions.firstWhere((d) => d.key == key);

/// Measured values for a layout, with provenance.
class LayoutMetrics {
  final String layoutId;
  final String? analyser;
  final String? corpus;
  final int likes;
  final Map<MetricKey, double> values;
  const LayoutMetrics({
    required this.layoutId, required this.analyser, required this.corpus,
    required this.likes, required this.values,
  });

  double? valueOf(MetricKey key) => values[key];
  bool get isComparable => analyser != null && corpus != null;

  factory LayoutMetrics.fromJson(Map<String, dynamic> json) {
    final rawStats = json['stats'] as Map<String, dynamic>;
    final values = <MetricKey, double>{};
    rawStats.forEach((k, v) {
      final mk = MetricKey.fromJsonKey(k);
      if (mk != null) values[mk] = (v as num).toDouble();
    });
    return LayoutMetrics(
      layoutId: json['layoutId'] as String,
      analyser: json['analyser'] as String?,
      corpus: json['corpus'] as String?,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      values: values,
    );
  }
}