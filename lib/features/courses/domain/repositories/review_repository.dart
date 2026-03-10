import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getCourseReviews(String courseId);
  Future<Review?> getUserReview(String courseId, String userId);
  Future<void> addReview({
    required String courseId,
    required String userId,
    required String displayName,
    required int rating,
    required String text,
  });
  Future<void> updateReview({
    required String courseId,
    required String reviewId,
    required String text,
    required int rating,
  });
}
