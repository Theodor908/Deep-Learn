import '../../domain/entities/review_item.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/firestore_review_datasource.dart';
import '../models/review_item_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirestoreReviewDatasource _datasource;

  ReviewRepositoryImpl(this._datasource);

  @override
  Future<void> createReviewItem(ReviewItem item) async {
    final model = ReviewItemModel.fromEntity(item);
    await _datasource.createReviewItem(model);
  }

  @override
  Future<List<ReviewItem>> getDueReviewItems(String userId) async {
    final models = await _datasource.getDueReviewItems(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateReviewItem(ReviewItem item) async {
    final model = ReviewItemModel.fromEntity(item);
    await _datasource.updateReviewItem(model);
  }

  @override
  Future<List<ReviewItem>> getUserReviewItems(String userId) async {
    final models = await _datasource.getUserReviewItems(userId);
    return models.map((m) => m.toEntity()).toList();
  }
}
