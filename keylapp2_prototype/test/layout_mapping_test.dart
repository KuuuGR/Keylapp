import 'package:flutter_test/flutter_test.dart';
import 'package:keylapp2/domain/layout_mapping.dart';
import 'package:keylapp2/domain/models/ansi_keyboard.dart';
import 'package:keylapp2/domain/models/layout.dart';
import 'package:keylapp2/domain/models/staggered_simplified_keyboard.dart';

void main() {
  group('LayoutMapper', () {
    test('maps QWERTY letters onto the correct physical keys', () {
      final geometry = AnsiKeyboardGeometry();
      final mapper = LayoutMapper(geometry: geometry);

      // ignore: prefer_const_constructors
      final qwerty = KeyboardLayout(
        id: 'qwerty',
        name: 'QWERTY',
        rows: [
          ['q','w','e','r','t','y','u','i','o','p'],
          ['a','s','d','f','g','h','j','k','l',';'],
          ['z','x','c','v','b','n','m',',','.','/'],
        ],
      );

      final mapped = mapper.mapLayout(qwerty);

      // QWERTY row (row 1): Q at col 3 … P at col 12 (row shifted 0.5U left).
      expect(mapped['1:3'], 'q');
      expect(mapped['1:12'], 'p');
      // Home row (row 2): A at col 3 … ; at col 12.
      expect(mapped['2:3'], 'a');
      // Bottom row (row 3): Z at col 4 … / at col 13.
      expect(mapped['3:4'], 'z');
      // Function keys keep their static labels.
      expect(mapped['0:0'], 'Esc');
      expect(mapped['1:1'], 'Tab');
      expect(mapped['4:6'], ''); // space
    });

    test('Staggered Simplified: exactly 10 keys per row, QWERTY 0.5U right', () {
      final geo = StaggeredSimplifiedKeyboardGeometry();

      // Exactly 10 keys in every character row, all 1×1.
      expect(geo.rows.length, 3);
      for (final row in geo.rows) {
        expect(row.length, 10);
        for (final k in row) {
          expect(k.unitWidth, 1.0);
          expect(k.unitHeight, 1.0);
        }
      }
      // QWERTY = Q..P, Home = A..;, Bottom = Z../
      expect(geo.rows[0].first.glyph, 'Q');
      expect(geo.rows[0].last.glyph, 'P');
      expect(geo.rows[1].first.glyph, 'A');
      expect(geo.rows[1].last.glyph, ';');
      expect(geo.rows[2].first.glyph, 'Z');
      expect(geo.rows[2].last.glyph, '/');

      // Render offsets: baseline = min first col = 3.
      // QWERTY first col 4 → offset 0.5U; Q x = 0.5.
      // Home   first col 3 → offset 0.0U; A x = 0.0.
      // Bottom first col 4 → offset 0.5U; Z x = 0.5.
      // So Q is 0.5U RIGHT of A, and Z is 0.5U right of A (unchanged).
      final q = geo.rows[0][0].opticalColumn; // 4
      final a = geo.rows[1][0].opticalColumn; // 3
      final z = geo.rows[2][0].opticalColumn; // 4
      expect(q - a, 1); // 1 optical col = 0.5U right
      expect(z - a, 1); // bottom unchanged relative to home
      expect(geo.rows[0].length, 10);
    });

    test('the physical geometry is fixed while layouts change content', () {
      final geometry = AnsiKeyboardGeometry();
      final mapper = LayoutMapper(geometry: geometry);

      // ignore: prefer_const_constructors
      final colemak = KeyboardLayout(
        id: 'colemak',
        name: 'Colemak',
        rows: [
          ['q','w','f','p','g','j','l','u','y',';'],
          ['a','r','s','t','d','h','n','e','i','o'],
          ['z','x','c','v','b','k','m',',','.','/'],
        ],
      );

      final mapped = mapper.mapLayout(colemak);

      // Key (row 1, col 3): QWERTY has q there, Colemak has q too.
      expect(mapped['1:3'], 'q');
      // Key (row 1, col 5): QWERTY= e, Colemak= f → the geometry is fixed,
      // only the content differs on the shared physical key.
      expect(mapped['1:5'], 'f');
    });
  });
}