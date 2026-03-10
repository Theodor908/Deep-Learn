import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
abstract class Course with _$Course {
  const factory Course({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required List<String> categoryIds,
    required int totalSections,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int enrollmentCount,
    @Default(0.0) double averageRating,
    @Default(0) int ratingCount,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) =>
      _$CourseFromJson(json);
}
