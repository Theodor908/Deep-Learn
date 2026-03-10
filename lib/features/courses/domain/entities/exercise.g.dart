// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      correctAnswer: (json['correctAnswer'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      order: (json['order'] as num).toInt(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'type': _$ExerciseTypeEnumMap[instance.type]!,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
      'order': instance.order,
      'explanation': instance.explanation,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.mcq: 'mcq',
  ExerciseType.fillBlank: 'fillBlank',
  ExerciseType.trueFalse: 'trueFalse',
  ExerciseType.matching: 'matching',
  ExerciseType.openEnded: 'openEnded',
};
