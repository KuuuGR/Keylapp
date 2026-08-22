import 'package:flutter_test/flutter_test.dart';
import 'package:keylapp2/domain/consensus.dart';
import 'package:keylapp2/domain/models/layout.dart';

void main() {
  group('ConsensusEngine', () {
    test('computes agreement across layouts on a shared key', () {
      final qwerty = KeyboardLayout(
        id: 'qwerty',
        name: 'QWERTY',
        rows: [
          ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
          ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
          ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
        ],
      );
      final colemak = KeyboardLayout(
        id: 'colemak',
        name: 'Colemak',
        rows: [
          ['q', 'w', 'f', 'p', 'g', 'j', 'l', 'u', 'y'],
          ['a', 'r', 's', 't', 'd', 'h', 'n', 'e', 'i'],
          ['z', 'x', 'c', 'v', 'b', 'k', 'm'],
        ],
      );

      final engine = ConsensusEngine(
        layouts: [qwerty, colemak],
        selectedIds: const ['qwerty', 'colemak'],
      );
      final grid = engine.computeGrid();

      // Key (0,0) = 'q' in both.
      final topLeft = grid[0][0]!;
      expect(topLeft.charCounts['q'], 2);
      expect(topLeft.isUnanimous, isTrue);
      expect(topLeft.agreementRatio, 1.0);

      // Key (0,2) = 'e' in QWERTY, 'f' in Colemak → no agreement.
      final topThird = grid[0][2]!;
      expect(topThird.agreementCount, 1);
      expect(topThird.isUnanimous, isFalse);
    });
  });
}