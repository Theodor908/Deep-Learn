import '../entities/review_item.dart';

abstract class ReviewRepository {
  Future<void> createReviewItem(ReviewItem item);
  Future<List<ReviewItem>> getDueReviewItems(String userId);
  Future<void> updateReviewItem(ReviewItem item);
  Future<List<ReviewItem>> getUserReviewItems(String userId);
}
