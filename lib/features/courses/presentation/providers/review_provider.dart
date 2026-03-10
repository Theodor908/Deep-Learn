import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/firestore_course_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

part 'review_provider.g.dart';

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepositoryImpl(FirestoreCourseDatasource());
}

@riverpod
Future<List<Review>> courseReviews(CourseReviewsRef ref, String courseId) async {
  ref.keepAlive();
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCourseReviews(courseId);
}

@riverpod
Future<Review?> userReview(UserReviewRef ref, String courseId) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getUserReview(courseId, user.uid);
}

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addReview({
    required String courseId,
    required String displayName,
    required int rating,
    required String text,
  }) async {
    final authState = ref.read(authStateProvider);
    final user = authState.valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.addReview(
        courseId: courseId,
        userId: user.uid,
        displayName: displayName,
        rating: rating,
        text: text,
      );
    });

    ref.invalidate(courseReviewsProvider);
    ref.invalidate(userReviewProvider);
  }

  Future<void> updateReview({
    required String courseId,
    required String reviewId,
    required String text,
    required int rating,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.updateReview(
        courseId: courseId,
        reviewId: reviewId,
        text: text,
        rating: rating,
      );
    });

    ref.invalidate(courseReviewsProvider);
    ref.invalidate(userReviewProvider);
  }
}
