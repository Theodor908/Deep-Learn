import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/exercise.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
abstract class ExerciseModel with _$ExerciseModel {
  const ExerciseModel._();

  const factory ExerciseModel({
    required String id,
    required String sectionId,
    required String type,
    required String question,
    @Default([]) List<String> options,
    required List<String> correctAnswer,
    required int order,
    String? explanation,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  factory ExerciseModel.fromFirestore(
      DocumentSnapshot doc, String sectionId) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseModel.fromJson({
      'id': doc.id,
      'sectionId': sectionId,
      ...data,
      'options': List<String>.from(data['options'] ?? []),
      'correctAnswer': List<String>.from(data['correctAnswer'] ?? []),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json.remove('sectionId');
    return json;
  }

  Exercise toEntity() => Exercise(
        id: id,
        sectionId: sectionId,
        type: ExerciseType.values.firstWhere(
          (e) => e.name == type,
          orElse: () => ExerciseType.mcq,
        ),
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        order: order,
        explanation: explanation,
      );

  factory ExerciseModel.fromEntity(Exercise exercise) => ExerciseModel(
        id: exercise.id,
        sectionId: exercise.sectionId,
        type: exercise.type.name,
        question: exercise.question,
        options: exercise.options,
        correctAnswer: exercise.correctAnswer,
        order: exercise.order,
        explanation: exercise.explanation,
      );
}
