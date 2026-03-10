import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/review_item.dart';

part 'review_item_model.freezed.dart';
part 'review_item_model.g.dart';

@freezed
abstract class ReviewItemModel with _$ReviewItemModel {
  const ReviewItemModel._();

  const factory ReviewItemModel({
    required String userId,
    required String courseId,
    required String sectionId,
    required DateTime nextReviewAt,
    @Default(1) int interval,
    @Default(2.5) double easeFactor,
    @Default(0) int reviewCount,
  }) = _ReviewItemModel;

  factory ReviewItemModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewItemModelFromJson(json);

  String get documentId => '${userId}_${courseId}_$sectionId';

  factory ReviewItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewItemModel.fromJson({
      ...data,
      'nextReviewAt':
          (data['nextReviewAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['nextReviewAt'] = Timestamp.fromDate(nextReviewAt);
    return json;
  }

  ReviewItem toEntity() => ReviewItem(
        userId: userId,
        courseId: courseId,
        sectionId: sectionId,
        nextReviewAt: nextReviewAt,
        interval: interval,
        easeFactor: easeFactor,
        reviewCount: reviewCount,
      );

  factory ReviewItemModel.fromEntity(ReviewItem item) => ReviewItemModel(
        userId: item.userId,
        courseId: item.courseId,
        sectionId: item.sectionId,
        nextReviewAt: item.nextReviewAt,
        interval: item.interval,
        easeFactor: item.easeFactor,
        reviewCount: item.reviewCount,
      );
}
