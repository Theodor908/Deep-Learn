import 'package:flutter_test/flutter_test.dart';
import 'package:deep_learn/core/utils/exercise_scorer.dart';
import 'package:deep_learn/features/courses/domain/entities/exercise.dart';

void main() {
  // Helper to build exercises concisely.
  Exercise _exercise({
    required ExerciseType type,
    List<String> options = const [],
    required List<String> correctAnswer,
  }) =>
      Exercise(
        id: 'ex1',
        sectionId: 's1',
        type: type,
        question: 'Test question',
        options: options,
        correctAnswer: correctAnswer,
        order: 1,
      );

  group('MCQ scoring', () {
    test('should return 1.0 for correct answer', () {
      // Arrange
      final exercise = _exercise(
        type: ExerciseType.mcq,
        options: ['A', 'B', 'C'],
        correctAnswer: ['B'],
      );

      // Act
      final result = ExerciseScorer.score(exercise, ['B']);

      // Assert
      expect(result, 1.0);
    });

    test('should return 1.0 for correct answer with different casing', () {
      final exercise = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['Paris'],
      );

      final result = ExerciseScorer.score(exercise, ['paris']);

      expect(result, 1.0);
    });

    test('should return 0.0 for wrong answer', () {
      final exercise = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['B'],
      );

      final result = ExerciseScorer.score(exercise, ['A']);

      expect(result, 0.0);
    });

    test('should return 0.0 for empty user answer', () {
      final exercise = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['B'],
      );

      final result = ExerciseScorer.score(exercise, []);

      expect(result, 0.0);
    });

    test('should return 0.0 when correct answer is empty', () {
      final exercise = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: [],
      );

      final result = ExerciseScorer.score(exercise, ['B']);

      expect(result, 0.0);
    });
  });

  group('True/False scoring', () {
    test('should return 1.0 for correct true answer', () {
      final exercise = _exercise(
        type: ExerciseType.trueFalse,
        correctAnswer: ['true'],
      );

      final result = ExerciseScorer.score(exercise, ['true']);

      expect(result, 1.0);
    });

    test('should return 0.0 for wrong answer', () {
      final exercise = _exercise(
        type: ExerciseType.trueFalse,
        correctAnswer: ['true'],
      );

      final result = ExerciseScorer.score(exercise, ['false']);

      expect(result, 0.0);
    });

    test('should handle case-insensitive comparison', () {
      final exercise = _exercise(
        type: ExerciseType.trueFalse,
        correctAnswer: ['True'],
      );

      final result = ExerciseScorer.score(exercise, ['TRUE']);

      expect(result, 1.0);
    });

    test('should return 0.0 for empty answer', () {
      final exercise = _exercise(
        type: ExerciseType.trueFalse,
        correctAnswer: ['false'],
      );

      final result = ExerciseScorer.score(exercise, []);

      expect(result, 0.0);
    });
  });

  group('Fill-in-the-blank scoring', () {
    test('should return 1.0 for exact match', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['photosynthesis'],
      );

      final result = ExerciseScorer.score(exercise, ['photosynthesis']);

      expect(result, 1.0);
    });

    test('should be case-insensitive', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['Photosynthesis'],
      );

      final result = ExerciseScorer.score(exercise, ['PHOTOSYNTHESIS']);

      expect(result, 1.0);
    });

    test('should trim whitespace', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['gravity'],
      );

      final result = ExerciseScorer.score(exercise, ['  gravity  ']);

      expect(result, 1.0);
    });

    test('should accept any of multiple valid answers', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['color', 'colour'],
      );

      // Act & Assert
      expect(ExerciseScorer.score(exercise, ['color']), 1.0);
      expect(ExerciseScorer.score(exercise, ['colour']), 1.0);
    });

    test('should return 0.0 for wrong answer', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['gravity'],
      );

      final result = ExerciseScorer.score(exercise, ['magnetism']);

      expect(result, 0.0);
    });

    test('should return 0.0 for empty answer', () {
      final exercise = _exercise(
        type: ExerciseType.fillBlank,
        correctAnswer: ['gravity'],
      );

      final result = ExerciseScorer.score(exercise, []);

      expect(result, 0.0);
    });
  });

  group('Matching scoring', () {
    test('should return 1.0 for all pairs correct', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['A:1', 'B:2', 'C:3'],
      );

      final result = ExerciseScorer.score(exercise, ['A:1', 'B:2', 'C:3']);

      expect(result, 1.0);
    });

    test('should give partial credit for some correct pairs', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['A:1', 'B:2', 'C:3'],
      );

      final result = ExerciseScorer.score(exercise, ['A:1', 'B:3', 'C:2']);

      // 1 correct out of 3
      expect(result, closeTo(1 / 3, 0.001));
    });

    test('should return 0.0 for all pairs wrong', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['A:1', 'B:2'],
      );

      final result = ExerciseScorer.score(exercise, ['A:2', 'B:1']);

      expect(result, 0.0);
    });

    test('should be case-insensitive', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['Cat:Meow', 'Dog:Bark'],
      );

      final result =
          ExerciseScorer.score(exercise, ['cat:meow', 'dog:bark']);

      expect(result, 1.0);
    });

    test('should return 0.0 for empty user answer', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['A:1', 'B:2'],
      );

      final result = ExerciseScorer.score(exercise, []);

      expect(result, 0.0);
    });

    test('should return 0.0 when correct answer list is empty', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: [],
      );

      final result = ExerciseScorer.score(exercise, ['A:1']);

      expect(result, 0.0);
    });

    test('should handle partial submission gracefully', () {
      final exercise = _exercise(
        type: ExerciseType.matching,
        correctAnswer: ['A:1', 'B:2', 'C:3', 'D:4'],
      );

      // User only matched 2 out of 4
      final result = ExerciseScorer.score(exercise, ['A:1', 'B:2']);

      expect(result, 0.5);
    });
  });

  group('Open-ended scoring', () {
    test('should return 1.0 when all keywords are present', () {
      final exercise = _exercise(
        type: ExerciseType.openEnded,
        correctAnswer: ['photosynthesis', 'sunlight', 'carbon dioxide'],
      );

      final result = ExerciseScorer.score(exercise,
          ['Photosynthesis uses sunlight to convert carbon dioxide into glucose']);

      expect(result, 1.0);
    });

    test('should give partial credit for some keywords', () {
      final exercise = _exercise(
        type: ExerciseType.openEnded,
        correctAnswer: ['photosynthesis', 'sunlight', 'carbon dioxide'],
      );

      final result = ExerciseScorer.score(
          exercise, ['Photosynthesis is a process involving sunlight']);

      // 2 out of 3 keywords
      expect(result, closeTo(2 / 3, 0.001));
    });

    test('should return 0.0 when no keywords match', () {
      final exercise = _exercise(
        type: ExerciseType.openEnded,
        correctAnswer: ['photosynthesis', 'chlorophyll'],
      );

      final result = ExerciseScorer.score(exercise, ['I like pizza']);

      expect(result, 0.0);
    });

    test('should return 0.0 for empty user answer', () {
      final exercise = _exercise(
        type: ExerciseType.openEnded,
        correctAnswer: ['keyword'],
      );

      final result = ExerciseScorer.score(exercise, []);

      expect(result, 0.0);
    });

    test('should return 0.0 for whitespace-only answer', () {
      final exercise = _exercise(
        type: ExerciseType.openEnded,
        correctAnswer: ['keyword'],
      );

      final result = ExerciseScorer.score(exercise, ['   ']);

      expect(result, 0.0);
    });
  });

  group('scoreAll', () {
    test('should return average score across all exercises', () {
      final ex1 = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['A'],
      ).copyWith(id: 'e1');
      final ex2 = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['B'],
      ).copyWith(id: 'e2');

      final answers = {
        'e1': ['A'], // correct
        'e2': ['X'], // wrong
      };

      final result = ExerciseScorer.scoreAll([ex1, ex2], answers);

      expect(result, 0.5);
    });

    test('should return 0.0 for empty exercise list', () {
      final result = ExerciseScorer.scoreAll([], {});

      expect(result, 0.0);
    });

    test('should treat missing answers as 0.0', () {
      final ex1 = _exercise(
        type: ExerciseType.mcq,
        correctAnswer: ['A'],
      ).copyWith(id: 'e1');

      // No answer provided for e1
      final result = ExerciseScorer.scoreAll([ex1], {});

      expect(result, 0.0);
    });
  });
}
