import 'package:flutter_test/flutter_test.dart';
import 'package:deep_learn/core/utils/sm2_algorithm.dart';
import 'package:deep_learn/features/practice/domain/entities/review_item.dart';

void main() {
  ReviewItem _freshItem() => ReviewItem(
        userId: 'u1',
        courseId: 'c1',
        sectionId: 's1',
        nextReviewAt: DateTime.now(),
        interval: 1,
        easeFactor: 2.5,
        reviewCount: 0,
      );

  group('Good recall (score >= 0.8)', () {
    test('should set interval to 1 on first review', () {
      // Arrange
      final item = _freshItem();

      // Act
      final result = Sm2Algorithm.calculateNext(item, 1.0);

      // Assert
      expect(result.interval, 1);
      expect(result.reviewCount, 1);
    });

    test('should set interval to 3 on second review', () {
      final item = _freshItem().copyWith(reviewCount: 1, interval: 1);

      final result = Sm2Algorithm.calculateNext(item, 1.0);

      expect(result.interval, 3);
      expect(result.reviewCount, 2);
    });

    test('should multiply interval by easeFactor on third+ review', () {
      final item = _freshItem().copyWith(
        reviewCount: 2,
        interval: 3,
        easeFactor: 2.5,
      );

      final result = Sm2Algorithm.calculateNext(item, 1.0);

      // 3 * 2.5 = 7.5, rounded to 8
      expect(result.interval, 8);
      expect(result.reviewCount, 3);
    });

    test('should increase ease factor for perfect score', () {
      final item = _freshItem().copyWith(easeFactor: 2.5);

      final result = Sm2Algorithm.calculateNext(item, 1.0);

      expect(result.easeFactor, greaterThan(2.5));
    });

    test('should increase ease factor for 0.8 score', () {
      final item = _freshItem().copyWith(easeFactor: 2.5);

      final result = Sm2Algorithm.calculateNext(item, 0.8);

      // EF formula: 2.5 + (0.1 - (1-0.8)*(0.08 + (1-0.8)*0.02))
      // = 2.5 + (0.1 - 0.2*(0.08 + 0.004))
      // = 2.5 + (0.1 - 0.0168) = 2.5832
      expect(result.easeFactor, greaterThan(2.5));
    });

    test('should update nextReviewAt to future date', () {
      final item = _freshItem();
      final before = DateTime.now();

      final result = Sm2Algorithm.calculateNext(item, 1.0);

      expect(result.nextReviewAt.isAfter(before), isTrue);
    });
  });

  group('Okay recall (0.6 <= score < 0.8)', () {
    test('should keep interval the same', () {
      final item = _freshItem().copyWith(interval: 7);

      final result = Sm2Algorithm.calculateNext(item, 0.7);

      expect(result.interval, 7);
    });

    test('should still increment review count', () {
      final item = _freshItem().copyWith(reviewCount: 3);

      final result = Sm2Algorithm.calculateNext(item, 0.65);

      expect(result.reviewCount, 4);
    });

    test('should not change ease factor', () {
      final item = _freshItem().copyWith(easeFactor: 2.5);

      final result = Sm2Algorithm.calculateNext(item, 0.7);

      expect(result.easeFactor, 2.5);
    });
  });

  group('Poor recall (score < 0.6)', () {
    test('should reset interval to initial value', () {
      final item = _freshItem().copyWith(interval: 30);

      final result = Sm2Algorithm.calculateNext(item, 0.3);

      expect(result.interval, 1); // initialReviewIntervalDays
    });

    test('should decrease ease factor by 0.2', () {
      final item = _freshItem().copyWith(easeFactor: 2.5);

      final result = Sm2Algorithm.calculateNext(item, 0.4);

      expect(result.easeFactor, 2.3);
    });

    test('should increment review count', () {
      final item = _freshItem().copyWith(reviewCount: 5);

      final result = Sm2Algorithm.calculateNext(item, 0.2);

      expect(result.reviewCount, 6);
    });
  });

  group('Ease factor bounds', () {
    test('should never go below 1.3', () {
      // Start with ease factor just above 1.3 and give poor score
      final item = _freshItem().copyWith(easeFactor: 1.4);

      final result = Sm2Algorithm.calculateNext(item, 0.0);

      // 1.4 - 0.2 = 1.2, but clamped to 1.3
      expect(result.easeFactor, 1.3);
    });

    test('should stay at 1.3 if already at minimum', () {
      final item = _freshItem().copyWith(easeFactor: 1.3);

      final result = Sm2Algorithm.calculateNext(item, 0.0);

      expect(result.easeFactor, 1.3);
    });
  });

  group('Interval progression over multiple reviews', () {
    test('should progress correctly with consistent good scores', () {
      var item = _freshItem();

      // Review 1: good score → interval 1
      item = Sm2Algorithm.calculateNext(item, 1.0);
      expect(item.interval, 1);
      expect(item.reviewCount, 1);

      // Review 2: good score → interval 3
      item = Sm2Algorithm.calculateNext(item, 1.0);
      expect(item.interval, 3);
      expect(item.reviewCount, 2);

      // Review 3: good score → interval = 3 * EF (EF > 2.5)
      item = Sm2Algorithm.calculateNext(item, 1.0);
      expect(item.interval, greaterThan(3));
      expect(item.reviewCount, 3);

      // Review 4: good score → interval grows further
      final prevInterval = item.interval;
      item = Sm2Algorithm.calculateNext(item, 1.0);
      expect(item.interval, greaterThan(prevInterval));
      expect(item.reviewCount, 4);
    });

    test('should reset progression after poor score', () {
      var item = _freshItem();

      // Build up to a long interval
      item = Sm2Algorithm.calculateNext(item, 1.0); // interval 1
      item = Sm2Algorithm.calculateNext(item, 1.0); // interval 3
      item = Sm2Algorithm.calculateNext(item, 1.0); // interval ~8

      expect(item.interval, greaterThan(3));

      // Poor score resets to initial
      item = Sm2Algorithm.calculateNext(item, 0.2);
      expect(item.interval, 1);
    });
  });

  group('overdueDescription', () {
    test('should return "Due today" for items due now', () {
      final item = _freshItem().copyWith(nextReviewAt: DateTime.now());

      final result = Sm2Algorithm.overdueDescription(item);

      expect(result, 'Due today');
    });

    test('should return "Due tomorrow" for items due tomorrow', () {
      final item = _freshItem().copyWith(
        nextReviewAt: DateTime.now().add(const Duration(days: 1, hours: 1)),
      );

      final result = Sm2Algorithm.overdueDescription(item);

      expect(result, 'Due tomorrow');
    });

    test('should return overdue description for past items', () {
      final item = _freshItem().copyWith(
        nextReviewAt: DateTime.now().subtract(const Duration(days: 3)),
      );

      final result = Sm2Algorithm.overdueDescription(item);

      expect(result, 'Overdue by 3 days');
    });
  });

  group('urgencyLevel', () {
    test('should return 0 for items not yet due', () {
      final item = _freshItem().copyWith(
        nextReviewAt: DateTime.now().add(const Duration(days: 5)),
      );

      expect(Sm2Algorithm.urgencyLevel(item), 0);
    });

    test('should return 2 for overdue items', () {
      final item = _freshItem().copyWith(
        nextReviewAt: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(Sm2Algorithm.urgencyLevel(item), 2);
    });
  });
}
