import 'package:flutter_test/flutter_test.dart';
import 'package:keylapp2/domain/layout_mapping.dart';
import 'package:keylapp2/domain/models/ansi_keyboard.dart';
import 'package:keylapp2/domain/models/layout.dart';

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