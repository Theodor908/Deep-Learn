// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnrollmentModelImpl _$$EnrollmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$EnrollmentModelImpl(
  userId: json['userId'] as String,
  courseId: json['courseId'] as String,
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
  lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
  currentSectionOrder: (json['currentSectionOrder'] as num?)?.toInt() ?? 1,
  completedSections:
      (json['completedSections'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  completionPercentage:
      (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
  rating: (json['rating'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$EnrollmentModelImplToJson(
  _$EnrollmentModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'courseId': instance.courseId,
  'enrolledAt': instance.enrolledAt.toIso8601String(),
  'lastAccessedAt': instance.lastAccessedAt.toIso8601String(),
  'currentSectionOrder': instance.currentSectionOrder,
  'completedSections': instance.completedSections,
  'completionPercentage': instance.completionPercentage,
  'rating': instance.rating,
};
