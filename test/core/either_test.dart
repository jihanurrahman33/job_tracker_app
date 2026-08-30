import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/utils/either.dart';

void main() {
  group('Either Monad Tests', () {
    test('Right should represent success and fold correctly', () {
      const Either<String, int> result = Right(42);

      expect(result.isRight, isTrue);
      expect(result.isLeft, isFalse);
      expect(result.rightOrNull, equals(42));
      expect(result.leftOrNull, isNull);

      final folded = result.fold(
        (l) => 'Error: $l',
        (r) => 'Success: $r',
      );
      expect(folded, equals('Success: 42'));
    });

    test('Left should represent failure and fold correctly', () {
      const Either<String, int> result = Left('Something went wrong');

      expect(result.isLeft, isTrue);
      expect(result.isRight, isFalse);
      expect(result.leftOrNull, equals('Something went wrong'));
      expect(result.rightOrNull, isNull);

      final folded = result.fold(
        (l) => 'Error: $l',
        (r) => 'Success: $r',
      );
      expect(folded, equals('Error: Something went wrong'));
    });

    test('Equality should match instances with identical values', () {
      const r1 = Right<String, int>(100);
      const r2 = Right<String, int>(100);
      const l1 = Left<String, int>('err');
      const l2 = Left<String, int>('err');

      expect(r1, equals(r2));
      expect(l1, equals(l2));
      expect(r1, isNot(equals(l1)));
    });
  });
}
