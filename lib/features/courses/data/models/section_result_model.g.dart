// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectionResultModelImpl _$$SectionResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$SectionResultModelImpl(
  sectionId: json['sectionId'] as String,
  score: (json['score'] as num).toDouble(),
  passed: json['passed'] as bool,
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$SectionResultModelImplToJson(
  _$SectionResultModelImpl instance,
) => <String, dynamic>{
  'sectionId': instance.sectionId,
  'score': instance.score,
  'passed': instance.passed,
  'attempts': instance.attempts,
  'completedAt': instance.completedAt?.toIso8601String(),
};
