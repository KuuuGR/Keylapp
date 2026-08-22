import 'physical_keyboard.dart';

/// The stable physical keyboard (product spec) that layouts map onto.
/// Letter keys are auto-generated; only the layout of wide/function keys is
/// declared explicitly, giving a compact, readable ANSI-style keyboard.
class AnsiKeyboardGeometry extends PhysicalKeyboardGeometry {
  AnsiKeyboardGeometry() : super(id: 'ansi-compact', rows: _buildRows());

  static List<List<PhysicalKey>> _buildRows() {
    // Row 0: number + punctuation row.
    final r0 = <PhysicalKey>[
      const PhysicalKey(row: 0, opticalColumn: 0, function: 'esc', glyph: 'Esc', unitWidth: 1.2),
    ];
    const row0Glyphs = ['1','2','3','4','5','6','7','8','9','0','-','='];
    // Letters start at optical column 2 (after Esc spanning 1.2 → col 2).
    for (var i = 0; i < row0Glyphs.length; i++) {
      r0.add(PhysicalKey(row: 0, opticalColumn: 2 + i, glyph: row0Glyphs[i]));
    }
    r0.add(const PhysicalKey(row: 0, opticalColumn: 14, function: 'backspace', glyph: '⌫', unitWidth: 1.5));

    // Row 1: QWERTY row.
    final r1 = <PhysicalKey>[
      const PhysicalKey(row: 1, opticalColumn: 0, function: 'tab', glyph: 'Tab', unitWidth: 1.5),
    ];
    const r1Glyphs = ['Q','W','E','R','T','Y','U','I','O','P','[',']','\\'];
    for (var i = 0; i < r1Glyphs.length; i++) {
      r1.add(PhysicalKey(row: 1, opticalColumn: 2 + i, glyph: r1Glyphs[i]));
    }
    r1.add(const PhysicalKey(row: 1, opticalColumn: 15, function: 'enter', glyph: '↵', unitWidth: 1.5));

    // Row 2: home row.
    final r2 = <PhysicalKey>[
      const PhysicalKey(row: 2, opticalColumn: 0, function: 'caps', glyph: 'Caps', unitWidth: 1.8),
    ];
    const r2Glyphs = ['A','S','D','F','G','H','J','K','L',';',"'"];
    for (var i = 0; i < r2Glyphs.length; i++) {
      r2.add(PhysicalKey(row: 2, opticalColumn: 2 + i, glyph: r2Glyphs[i]));
    }
    r2.add(const PhysicalKey(row: 2, opticalColumn: 13, function: 'enter2', glyph: '↵', unitWidth: 1.5));

    // Row 3: bottom letter row.
    final r3 = <PhysicalKey>[
      const PhysicalKey(row: 3, opticalColumn: 0, function: 'lshift', glyph: 'Shift', unitWidth: 2.2),
    ];
    const r3Glyphs = ['Z','X','C','V','B','N','M',',','.','/'];
    for (var i = 0; i < r3Glyphs.length; i++) {
      r3.add(PhysicalKey(row: 3, opticalColumn: 3 + i, glyph: r3Glyphs[i]));
    }
    r3.add(const PhysicalKey(row: 3, opticalColumn: 13, function: 'rshift', glyph: 'Shift', unitWidth: 2.2));

    // Row 4: space row.
    const r4 = <PhysicalKey>[
      PhysicalKey(row: 4, opticalColumn: 0, function: 'ctrl', glyph: 'Ctrl', unitWidth: 1.5),
      PhysicalKey(row: 4, opticalColumn: 2, function: 'win', glyph: '◆', unitWidth: 1.25),
      PhysicalKey(row: 4, opticalColumn: 4, function: 'alt', glyph: 'Alt', unitWidth: 1.5),
      PhysicalKey(row: 4, opticalColumn: 6, function: 'space', glyph: '', unitWidth: 6.0),
      PhysicalKey(row: 4, opticalColumn: 13, function: 'ralt', glyph: 'Alt', unitWidth: 1.5),
      PhysicalKey(row: 4, opticalColumn: 15, function: 'menu', glyph: '☰', unitWidth: 1.25),
      PhysicalKey(row: 4, opticalColumn: 17, function: 'rctrl', glyph: 'Ctrl', unitWidth: 1.5),
    ];

    return [r0, r1, r2, r3, r4];
  }
}