import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item.freezed.dart';
part 'review_item.g.dart';

@freezed
abstract class ReviewItem with _$ReviewItem {
  const factory ReviewItem({
    required String userId,
    required String courseId,
    required String sectionId,
    required DateTime nextReviewAt,
    @Default(1) int interval,
    @Default(2.5) double easeFactor,
    @Default(0) int reviewCount,
  }) = _ReviewItem;

  factory ReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ReviewItemFromJson(json);
}
