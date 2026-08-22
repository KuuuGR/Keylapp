/// A logical keyboard layout — an assignment of characters to physical
/// key positions. This is the canonical entity for the whole application.
///
/// The `id` is a stable, immutable slug (e.g. `"qwerty"`, `"colemak"`) that
/// never changes even if the display `name` is renamed. All other data
/// (metrics, descriptions) references a layout by `id`, never by `name`.
class KeyboardLayout {
  final String id;
  final String name;
  /// Variable-width rows of keys. A grapheme is represented via its rune
  /// string (which may be multi-codepoint for emoji/enclosed forms).
  final List<List<String>> rows;

  const KeyboardLayout({
    required this.id,
    required this.name,
    required this.rows,
  });

  factory KeyboardLayout.fromJson(Map<String, dynamic> json) {
    return KeyboardLayout(
      id: json['id'] as String,
      name: json['name'] as String,
      rows: (json['rows'] as List)
          .map((r) => (r as List).map((c) => c.toString()).toList())
          .toList(),
    );
  }

  /// Number of columns in the widest row (used to keep the grid aligned).
  int get maxColumns => rows.fold(0, (m, r) => r.length > m ? r.length : m);

  /// The three primary alphabetic rows (the rows that layouts rearrange).
  /// Rows beyond this (function rows, etc.) would come from the keyboard
  /// geometry definition in a future model; for now we keep all authored rows.
  List<List<String>> get alphabeticRows => rows;

  @override
  bool operator ==(Object other) => other is KeyboardLayout && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'KeyboardLayout($id)';
}