import 'package:freezed_annotation/freezed_annotation.dart';

part 'enrollment.freezed.dart';
part 'enrollment.g.dart';

@freezed
abstract class Enrollment with _$Enrollment {
  const factory Enrollment({
    required String userId,
    required String courseId,
    required DateTime enrolledAt,
    required DateTime lastAccessedAt,
    @Default(1) int currentSectionOrder,
    @Default([]) List<int> completedSections,
    @Default(0.0) double completionPercentage,
    @Default(0) int rating,
  }) = _Enrollment;

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);
}
