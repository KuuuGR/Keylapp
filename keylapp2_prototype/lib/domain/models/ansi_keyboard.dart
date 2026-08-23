import 'physical_keyboard.dart';

/// The stable physical keyboard (product spec) that layouts map onto.
/// This is the FULL Staggered keyboard with the standard compact ANSI key set
/// and a natural constant physical stagger across the three character rows.
///
/// Key structure (key set & trailing widths) follows the full ANSI design:
///
///   number row:   Esc 1 2 3 4 5 6 7 8 9 0 - = ⌫
///   QWERTY row:       Tab Q W E R T Y U I O P [ ] \
///   home row:         Caps A S D F G H J K L ; ' ↵
///   bottom row:       Shift Z X C V B N M , . / Shift
///   space row:        Ctrl ◆ Alt [Space] Alt ☰ Ctrl
///
/// Design rules:
///  - The QWERTY row is indented one key-width (2 optical columns) to the
///    right, and its trailing Enter was REMOVED — the row is now
///    `Tab + Q..P [ ] \` with no ↵. All key sizes/spacing are unchanged.
///  - The home and bottom rows keep their original positions:
///      * QWERTY row: Tab at col 2, Q at col 4 … `\` at col 16.
///      * Home row:   Caps at col 1, A at col 3 … `'` at col 13, then Enter.
///      * Bottom row: left Shift at col 2, Z at col 4 … `/` at col 13, then
///        right Shift.
///    As a result A (home) sits to the LEFT of Q (QWERTY), and Z (bottom)
///    sits directly under A.
///  - Leading modifiers Tab, Caps, left Shift are all 1.5U. Trailing keys
///    keep their ANSI widths.
///  - Layout mapping: layout characters land on the non-function keys of each
///    character row by QWERTY index (the first 10 map onto Q..P / A..; / Z../;
///    any additional punctuation keys — `[ ] \` / `'` — render empty for the
///    standard 3×10 layouts). Auxiliary/modifier/Enter keys never consume
///    layout characters.
class AnsiKeyboardGeometry extends PhysicalKeyboardGeometry {
  AnsiKeyboardGeometry() : super(id: 'ansi-compact', rows: _buildRows());

  static List<List<PhysicalKey>> _buildRows() {
    // Row 0: number + punctuation row. Esc at col 0; right edge at col 15.
    final r0 = <PhysicalKey>[
      const PhysicalKey(row: 0, opticalColumn: 0, function: 'esc', glyph: 'Esc', unitWidth: 1.2),
    ];
    const row0Glyphs = ['1','2','3','4','5','6','7','8','9','0','-','='];
    for (var i = 0; i < row0Glyphs.length; i++) {
      r0.add(PhysicalKey(row: 0, opticalColumn: 2 + i, glyph: row0Glyphs[i]));
    }
    r0.add(const PhysicalKey(row: 0, opticalColumn: 14, function: 'backspace', glyph: '⌫', unitWidth: 1.5));

    // Row 1: QWERTY row — Tab + Q..P [ ] \ (NO trailing Enter). The whole row
    // is shifted one key-width (2 optical columns) to the right, so it is
    // indented while every other row keeps its position.
    final r1 = <PhysicalKey>[
      const PhysicalKey(row: 1, opticalColumn: 2, function: 'tab', glyph: 'Tab', unitWidth: 1.5),
    ];
    const r1Glyphs = ['Q','W','E','R','T','Y','U','I','O','P','[',']','\\'];
    for (var i = 0; i < r1Glyphs.length; i++) {
      r1.add(PhysicalKey(row: 1, opticalColumn: 4 + i, glyph: r1Glyphs[i]));
    }

    // Row 2: home row — Caps + A..; ' + Enter. First key at col 1. The QWERTY
    // row above was shifted right by one key-width, so A sits LEFT of Q (and
    // Z sits under A on the same line, since home and bottom share position).
    final r2 = <PhysicalKey>[
      const PhysicalKey(row: 2, opticalColumn: 1, function: 'caps', glyph: 'Caps', unitWidth: 1.5),
    ];
    const r2Glyphs = ['A','S','D','F','G','H','J','K','L',';',"'"];
    for (var i = 0; i < r2Glyphs.length; i++) {
      r2.add(PhysicalKey(row: 2, opticalColumn: 3 + i, glyph: r2Glyphs[i]));
    }
    r2.add(const PhysicalKey(row: 2, opticalColumn: 14, function: 'enter2', glyph: '↵', unitWidth: 1.5));

    // Row 3: bottom letter row — Shift + Z../ + Shift. First key at col 2.
    // Home and bottom rows share the same starting column, so Z sits directly
    // under A (left Shift is 1.5U, same as Caps).
    final r3 = <PhysicalKey>[
      const PhysicalKey(row: 3, opticalColumn: 2, function: 'lshift', glyph: 'Shift', unitWidth: 1.5),
    ];
    const r3Glyphs = ['Z','X','C','V','B','N','M',',','.','/'];
    for (var i = 0; i < r3Glyphs.length; i++) {
      r3.add(PhysicalKey(row: 3, opticalColumn: 4 + i, glyph: r3Glyphs[i]));
    }
    r3.add(const PhysicalKey(row: 3, opticalColumn: 14, function: 'rshift', glyph: 'Shift', unitWidth: 2.2));

    // Row 4: space row (≤ 19 columns).
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