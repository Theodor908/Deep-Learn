// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseModelImpl _$$ExerciseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseModelImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      type: json['type'] as String,
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

Map<String, dynamic> _$$ExerciseModelImplToJson(_$ExerciseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'type': instance.type,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
      'order': instance.order,
      'explanation': instance.explanation,
    };
