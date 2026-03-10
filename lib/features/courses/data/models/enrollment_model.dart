import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/enrollment.dart';

part 'enrollment_model.freezed.dart';
part 'enrollment_model.g.dart';

@freezed
abstract class EnrollmentModel with _$EnrollmentModel {
  const EnrollmentModel._();

  const factory EnrollmentModel({
    required String userId,
    required String courseId,
    required DateTime enrolledAt,
    required DateTime lastAccessedAt,
    @Default(1) int currentSectionOrder,
    @Default([]) List<int> completedSections,
    @Default(0.0) double completionPercentage,
    @Default(0) int rating,
  }) = _EnrollmentModel;

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentModelFromJson(json);

  String get documentId => '${userId}_$courseId';

  factory EnrollmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EnrollmentModel.fromJson({
      ...data,
      'enrolledAt':
          (data['enrolledAt'] as Timestamp).toDate().toIso8601String(),
      'lastAccessedAt':
          (data['lastAccessedAt'] as Timestamp).toDate().toIso8601String(),
      'completedSections': List<int>.from(data['completedSections'] ?? []),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['enrolledAt'] = Timestamp.fromDate(enrolledAt);
    json['lastAccessedAt'] = Timestamp.fromDate(lastAccessedAt);
    return json;
  }

  Enrollment toEntity() => Enrollment(
        userId: userId,
        courseId: courseId,
        enrolledAt: enrolledAt,
        lastAccessedAt: lastAccessedAt,
        currentSectionOrder: currentSectionOrder,
        completedSections: completedSections,
        completionPercentage: completionPercentage,
        rating: rating,
      );

  factory EnrollmentModel.fromEntity(Enrollment enrollment) => EnrollmentModel(
        userId: enrollment.userId,
        courseId: enrollment.courseId,
        enrolledAt: enrollment.enrolledAt,
        lastAccessedAt: enrollment.lastAccessedAt,
        currentSectionOrder: enrollment.currentSectionOrder,
        completedSections: enrollment.completedSections,
        completionPercentage: enrollment.completionPercentage,
        rating: enrollment.rating,
      );
}
