import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../courses/domain/entities/section_result.dart';
import '../../../courses/presentation/providers/enrollment_provider.dart';
import '../../data/datasources/firestore_review_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review_item.dart';
import '../../domain/repositories/review_repository.dart';

part 'practice_provider.g.dart';

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepositoryImpl(FirestoreReviewDatasource());
}

@riverpod
Future<List<ReviewItem>> dueReviewItems(DueReviewItemsRef ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return [];

  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getDueReviewItems(user.uid);
}

@riverpod
Future<List<ReviewItem>> userReviewItems(UserReviewItemsRef ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return [];

  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getUserReviewItems(user.uid);
}

@riverpod
class PracticeNotifier extends _$PracticeNotifier {
  @override
  FutureOr<PracticeState> build() {
    return const PracticeState();
  }

  void submitAnswer(String exerciseId, List<String> userAnswer,
      List<String> correctAnswer) {
    final current = state.valueOrNull ?? const PracticeState();
    final isCorrect = _checkAnswer(userAnswer, correctAnswer);

    final updatedAnswers = Map<String, bool>.from(current.answers)
      ..[exerciseId] = isCorrect;

    final totalAnswered = updatedAnswers.length;
    final correctCount =
        updatedAnswers.values.where((v) => v).length;
    final score =
        totalAnswered > 0 ? correctCount / totalAnswered : 0.0;

    state = AsyncData(current.copyWith(
      answers: updatedAnswers,
      currentScore: score,
    ));
  }

  Future<void> completeSectionPractice({
    required String courseId,
    required String sectionId,
    required int totalExercises,
  }) async {
    final current = state.valueOrNull ?? const PracticeState();
    final authState = ref.read(authStateProvider);
    final user = authState.valueOrNull;
    if (user == null) return;

    final passed = current.currentScore >= AppConstants.passThreshold;

    final enrollmentRepo = ref.read(enrollmentRepositoryProvider);
    await enrollmentRepo.saveSectionResult(
      user.uid,
      courseId,
      SectionResult(
        sectionId: sectionId,
        score: current.currentScore,
        passed: passed,
        attempts: 1,
        completedAt: passed ? DateTime.now() : null,
      ),
    );

    final reviewRepo = ref.read(reviewRepositoryProvider);
    final quality = _scoreToQuality(current.currentScore);

    final existingItems = await reviewRepo.getUserReviewItems(user.uid);
    final existing = existingItems
        .where((r) => r.courseId == courseId && r.sectionId == sectionId)
        .toList();

    if (existing.isNotEmpty) {
      final item = existing.first;
      final updated = _applySmTwo(item, quality);
      await reviewRepo.updateReviewItem(updated);
    } else {
      final newItem = ReviewItem(
        userId: user.uid,
        courseId: courseId,
        sectionId: sectionId,
        nextReviewAt: DateTime.now().add(
          Duration(days: AppConstants.initialReviewIntervalDays),
        ),
        interval: AppConstants.initialReviewIntervalDays,
        easeFactor: AppConstants.initialEaseFactor,
        reviewCount: 1,
      );
      await reviewRepo.createReviewItem(newItem);
    }

    ref.invalidate(dueReviewItemsProvider);
    ref.invalidate(userReviewItemsProvider);

    state = AsyncData(current.copyWith(isComplete: true, passed: passed));
  }

  void reset() {
    state = const AsyncData(PracticeState());
  }

  bool _checkAnswer(List<String> userAnswer, List<String> correctAnswer) {
    if (userAnswer.length != correctAnswer.length) return false;
    final sortedUser = List<String>.from(userAnswer)..sort();
    final sortedCorrect = List<String>.from(correctAnswer)..sort();
    for (var i = 0; i < sortedUser.length; i++) {
      if (sortedUser[i].toLowerCase() != sortedCorrect[i].toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  int _scoreToQuality(double score) {
    if (score >= 0.95) return 5;
    if (score >= 0.85) return 4;
    if (score >= 0.70) return 3;
    if (score >= 0.50) return 2;
    if (score >= 0.30) return 1;
    return 0;
  }

  ReviewItem _applySmTwo(ReviewItem item, int quality) {
    double newEaseFactor =
        item.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    newEaseFactor = max(1.3, newEaseFactor);

    int newInterval;
    if (quality < 3) {
      // Reset interval on poor performance.
      newInterval = 1;
    } else if (item.reviewCount == 0) {
      newInterval = 1;
    } else if (item.reviewCount == 1) {
      newInterval = 6;
    } else {
      newInterval = (item.interval * newEaseFactor).round();
    }

    return item.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor,
      reviewCount: item.reviewCount + 1,
      nextReviewAt: DateTime.now().add(Duration(days: newInterval)),
    );
  }
}

class PracticeState {
  final Map<String, bool> answers;
  final double currentScore;
  final bool isComplete;
  final bool passed;

  const PracticeState({
    this.answers = const {},
    this.currentScore = 0.0,
    this.isComplete = false,
    this.passed = false,
  });

  PracticeState copyWith({
    Map<String, bool>? answers,
    double? currentScore,
    bool? isComplete,
    bool? passed,
  }) {
    return PracticeState(
      answers: answers ?? this.answers,
      currentScore: currentScore ?? this.currentScore,
      isComplete: isComplete ?? this.isComplete,
      passed: passed ?? this.passed,
    );
  }
}
