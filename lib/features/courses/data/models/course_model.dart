import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/course.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
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
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel.fromJson({
      'id': doc.id,
      ...data,
      'createdAt':
          (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'updatedAt':
          (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
      'categoryIds': List<String>.from(data['categoryIds'] ?? []),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    return json;
  }

  Course toEntity() => Course(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        categoryIds: categoryIds,
        totalSections: totalSections,
        createdAt: createdAt,
        updatedAt: updatedAt,
        enrollmentCount: enrollmentCount,
        averageRating: averageRating,
        ratingCount: ratingCount,
      );

  factory CourseModel.fromEntity(Course course) => CourseModel(
        id: course.id,
        title: course.title,
        description: course.description,
        imageUrl: course.imageUrl,
        categoryIds: course.categoryIds,
        totalSections: course.totalSections,
        createdAt: course.createdAt,
        updatedAt: course.updatedAt,
        enrollmentCount: course.enrollmentCount,
        averageRating: course.averageRating,
        ratingCount: course.ratingCount,
      );
}
