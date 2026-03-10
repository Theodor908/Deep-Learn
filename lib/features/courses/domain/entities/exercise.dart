import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

enum ExerciseType {
  mcq,
  fillBlank,
  trueFalse,
  matching,
  openEnded,
}

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String sectionId,
    required ExerciseType type,
    required String question,
    @Default([]) List<String> options,
    required List<String> correctAnswer,
    required int order,
    String? explanation,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}
