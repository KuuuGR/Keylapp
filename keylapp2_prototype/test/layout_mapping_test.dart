import 'package:flutter_test/flutter_test.dart';
import 'package:keylapp2/domain/layout_mapping.dart';
import 'package:keylapp2/domain/models/ansi_keyboard.dart';
import 'package:keylapp2/domain/models/layout.dart';

void main() {
  group('LayoutMapper', () {
    test('maps QWERTY letters onto the correct physical keys', () {
      final geometry = AnsiKeyboardGeometry();
      final mapper = LayoutMapper(geometry: geometry);

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

      // The QWERTY row-0 letter 'q' should land on physical key (row 1, col 2).
      expect(mapped['1:2'], 'q');
      // The 'p' lands at (row 1, col 11).
      expect(mapped['1:11'], 'p');
      // Home row 'a' lands at (row 2, col 2).
      expect(mapped['2:2'], 'a');
      // Bottom row 'z' lands at (row 3, col 3).
      expect(mapped['3:3'], 'z');
      // Function keys keep their static labels.
      expect(mapped['0:0'], 'Esc');
      expect(mapped['1:0'], 'Tab');
      expect(mapped['4:6'], ''); // space
    });

    test('the physical geometry is fixed while layouts change content', () {
      final geometry = AnsiKeyboardGeometry();
      final mapper = LayoutMapper(geometry: geometry);

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

      // Same key (row 1, col 2): QWERTY has q there, Colemak has q too.
      expect(mapped['1:2'], 'q');
      // Key (row 1, col 4): QWERTY= e, Colemak= f → the geometry is fixed,
      // only the content differs on the shared physical key.
      expect(mapped['1:4'], 'f');
    });
  });
}