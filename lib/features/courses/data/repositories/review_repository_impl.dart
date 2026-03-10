import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/firestore_course_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirestoreCourseDatasource _datasource;

  ReviewRepositoryImpl(this._datasource);

  @override
  Future<List<Review>> getCourseReviews(String courseId) async {
    final models = await _datasource.getCourseReviews(courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Review?> getUserReview(String courseId, String userId) async {
    final model = await _datasource.getUserReview(courseId, userId);
    return model?.toEntity();
  }

  @override
  Future<void> addReview({
    required String courseId,
    required String userId,
    required String displayName,
    required int rating,
    required String text,
  }) async {
    final now = DateTime.now();
    final review = ReviewModel(
      id: '${userId}_$courseId',
      userId: userId,
      courseId: courseId,
      displayName: displayName,
      rating: rating,
      text: text,
      createdAt: now,
      updatedAt: now,
    );
    await _datasource.addReview(courseId, review);
  }

  @override
  Future<void> updateReview({
    required String courseId,
    required String reviewId,
    required String text,
    required int rating,
  }) async {
    await _datasource.updateReview(courseId, reviewId, text, rating);
  }
}
