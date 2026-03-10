// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewItemImpl _$$ReviewItemImplFromJson(Map<String, dynamic> json) =>
    _$ReviewItemImpl(
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      sectionId: json['sectionId'] as String,
      nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReviewItemImplToJson(_$ReviewItemImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'courseId': instance.courseId,
      'sectionId': instance.sectionId,
      'nextReviewAt': instance.nextReviewAt.toIso8601String(),
      'interval': instance.interval,
      'easeFactor': instance.easeFactor,
      'reviewCount': instance.reviewCount,
    };
