import 'physical_keyboard.dart';

/// The stable Staggered physical keyboard (product spec) that layouts map onto.
/// This is the FULL Staggered keyboard with a clean, right-aligned compact
/// geometry:
///
///   number row:   Esc 1 2 3 4 5 6 7 8 9 0 ⌫
///   QWERTY row:       Tab Q W E R T Y U I O P
///   home row:         Caps A S D F G H J K L ; ↵
///   bottom row:       Shift Z X C V B N M , . / Shift
///   space row:        Ctrl ◆ Alt [Space] Alt ☰
///
/// Design rules:
///  - The character rows are exactly 3 × 10 (Q..P / A..; / Z../). There is NO
///    trailing Enter on the QWERTY row (the duplicate must NOT exist); P is the
///    last key of that row and ends flush with the right edge of the keyboard.
///  - The home-row Enter (after `;`) is kept. The final key of every character
///    row (P, Enter, Shift) ends on the same right-edge line (13 columns).
///  - The QWERTY row is indented to the right so that P reaches that right edge.
///  - Letter keys are 1×1; only Tab/Caps are 1.5 (Tab stays 1.5), Enter/Shift
///    are 1.0. No character key is resized.
///  - Layout mapping: characters only land on the ten letter keys of each
///    character row (columns 6–15 / 4–13 / 5–14). Auxiliary/modifier keys never
///    consume layout characters.
class AnsiKeyboardGeometry extends PhysicalKeyboardGeometry {
  AnsiKeyboardGeometry() : super(id: 'ansi-compact', rows: _buildRows());

  static List<List<PhysicalKey>> _buildRows() {
    // Row 0: number + punctuation row. Right edge at optical col 13.
    final r0 = <PhysicalKey>[
      const PhysicalKey(row: 0, opticalColumn: 1, function: 'esc', glyph: 'Esc', unitWidth: 1.0),
    ];
    const row0Glyphs = ['1','2','3','4','5','6','7','8','9','0'];
    for (var i = 0; i < row0Glyphs.length; i++) {
      r0.add(PhysicalKey(row: 0, opticalColumn: 3 + i, glyph: row0Glyphs[i]));
    }
    r0.add(const PhysicalKey(row: 0, opticalColumn: 13, function: 'backspace', glyph: '⌫', unitWidth: 2.0));

    // Row 1: QWERTY row — Tab + Q..P (exactly 10 letters), NO Enter.
    // Indented (opticalColumn 4) so P ends flush at the right edge.
    final r1 = <PhysicalKey>[
      const PhysicalKey(row: 1, opticalColumn: 4, function: 'tab', glyph: 'Tab', unitWidth: 1.5),
    ];
    const r1Glyphs = ['Q','W','E','R','T','Y','U','I','O','P'];
    for (var i = 0; i < r1Glyphs.length; i++) {
      r1.add(PhysicalKey(row: 1, opticalColumn: 6 + i, glyph: r1Glyphs[i]));
    }

    // Row 2: home row — Caps + A..; + Enter (Enter KEPT).
    final r2 = <PhysicalKey>[
      const PhysicalKey(row: 2, opticalColumn: 2, function: 'caps', glyph: 'Caps', unitWidth: 1.5),
    ];
    const r2Glyphs = ['A','S','D','F','G','H','J','K','L',';'];
    for (var i = 0; i < r2Glyphs.length; i++) {
      r2.add(PhysicalKey(row: 2, opticalColumn: 4 + i, glyph: r2Glyphs[i]));
    }
    r2.add(const PhysicalKey(row: 2, opticalColumn: 14, function: 'enter', glyph: '↵', unitWidth: 1.0));

    // Row 3: bottom row — Shift + Z../ + Shift.
    final r3 = <PhysicalKey>[
      const PhysicalKey(row: 3, opticalColumn: 3, function: 'lshift', glyph: 'Shift', unitWidth: 1.0),
    ];
    const r3Glyphs = ['Z','X','C','V','B','N','M',',','.','/'];
    for (var i = 0; i < r3Glyphs.length; i++) {
      r3.add(PhysicalKey(row: 3, opticalColumn: 5 + i, glyph: r3Glyphs[i]));
    }
    r3.add(const PhysicalKey(row: 3, opticalColumn: 15, function: 'rshift', glyph: 'Shift', unitWidth: 1.0));

    // Row 4: modifiers + space (≤ 13 columns, does not widen the keyboard).
    const r4 = <PhysicalKey>[
      PhysicalKey(row: 4, opticalColumn: 1, function: 'ctrl', glyph: 'Ctrl', unitWidth: 1.5),
      PhysicalKey(row: 4, opticalColumn: 3, function: 'win', glyph: '◆', unitWidth: 1.25),
      PhysicalKey(row: 4, opticalColumn: 5, function: 'alt', glyph: 'Alt', unitWidth: 1.5),
      PhysicalKey(row: 4, opticalColumn: 7, function: 'space', glyph: '', unitWidth: 5.0),
      PhysicalKey(row: 4, opticalColumn: 13, function: 'ralt', glyph: 'Alt', unitWidth: 1.0),
      PhysicalKey(row: 4, opticalColumn: 15, function: 'menu', glyph: '☰', unitWidth: 1.0),
    ];

    return [r0, r1, r2, r3, r4];
  }
}