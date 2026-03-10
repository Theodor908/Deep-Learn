import 'dart:math';

import '../../features/practice/domain/entities/review_item.dart';
import '../constants/app_constants.dart';

// SM-2 spaced repetition algorithm
abstract final class Sm2Algorithm {
  static ReviewItem calculateNext(ReviewItem item, double score) {
    double newEaseFactor = item.easeFactor;
    int newInterval = item.interval;

    if (score >= 0.8) {
      // Good recall — increase interval.
      if (item.reviewCount == 0) {
        newInterval = 1;
      } else if (item.reviewCount == 1) {
        newInterval = 3;
      } else {
        newInterval = (item.interval * newEaseFactor).round();
      }
      newEaseFactor =
          item.easeFactor + (0.1 - (1 - score) * (0.08 + (1 - score) * 0.02));
    } else if (score >= 0.6) {
      // Okay recall — keep interval the same.
      newInterval = item.interval;
    } else {
      // Poor recall — reset to initial interval.
      newInterval = AppConstants.initialReviewIntervalDays;
      newEaseFactor = item.easeFactor - 0.2;
    }

    // Ease factor must never go below 1.3.
    newEaseFactor = max(1.3, newEaseFactor);

    return item.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor,
      reviewCount: item.reviewCount + 1,
      nextReviewAt: DateTime.now().add(Duration(days: newInterval)),
    );
  }

  static String overdueDescription(ReviewItem item) {
    final now = DateTime.now();
    final difference = now.difference(item.nextReviewAt);

    if (difference.isNegative) {
      final days = difference.inDays.abs();
      if (days == 0) return 'Due today';
      if (days == 1) return 'Due tomorrow';
      return 'Due in $days days';
    }

    final days = difference.inDays;
    if (days == 0) return 'Due today';
    if (days == 1) return 'Overdue by 1 day';
    return 'Overdue by $days days';
  }

  // 0 = not due, 1 = due today, 2 = overdue
  static int urgencyLevel(ReviewItem item) {
    final now = DateTime.now();
    final difference = now.difference(item.nextReviewAt);

    if (difference.isNegative) return 0;
    if (difference.inDays == 0) return 1;
    return 2;
  }
}
