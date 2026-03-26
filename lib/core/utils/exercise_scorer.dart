import '../../features/courses/domain/entities/exercise.dart';

abstract final class ExerciseScorer {
  static double score(Exercise exercise, List<String> userAnswer) {
    return switch (exercise.type) {
      ExerciseType.mcq => _scoreMcq(exercise, userAnswer),
      ExerciseType.trueFalse => _scoreTrueFalse(exercise, userAnswer),
      ExerciseType.fillBlank => _scoreFillBlank(exercise, userAnswer),
      ExerciseType.matching => _scoreMatching(exercise, userAnswer),
      ExerciseType.openEnded => _scoreOpenEnded(exercise, userAnswer),
      ExerciseType.photo => 0.0, // Photo exercises are standalone, not scored here.
      ExerciseType.map => 0.0,
    };
  }

  static double scoreAll(
    List<Exercise> exercises,
    Map<String, List<String>> userAnswers,
  ) {
    if (exercises.isEmpty) return 0.0;

    double totalScore = 0.0;
    for (final exercise in exercises) {
      final answer = userAnswers[exercise.id] ?? [];
      totalScore += score(exercise, answer);
    }
    return totalScore / exercises.length;
  }

  static double _scoreMcq(Exercise exercise, List<String> userAnswer) {
    if (userAnswer.isEmpty || exercise.correctAnswer.isEmpty) return 0.0;
    return userAnswer.first.trim().toLowerCase() ==
            exercise.correctAnswer.first.trim().toLowerCase()
        ? 1.0
        : 0.0;
  }

  static double _scoreTrueFalse(Exercise exercise, List<String> userAnswer) {
    if (userAnswer.isEmpty || exercise.correctAnswer.isEmpty) return 0.0;
    return userAnswer.first.trim().toLowerCase() ==
            exercise.correctAnswer.first.trim().toLowerCase()
        ? 1.0
        : 0.0;
  }

  static double _scoreFillBlank(Exercise exercise, List<String> userAnswer) {
    if (userAnswer.isEmpty || exercise.correctAnswer.isEmpty) return 0.0;
    final userText = userAnswer.first.trim().toLowerCase();
    for (final correct in exercise.correctAnswer) {
      if (userText == correct.trim().toLowerCase()) return 1.0;
    }
    return 0.0;
  }

  // Pairs format: ["A:1", "B:2", "C:3"]
  static double _scoreMatching(Exercise exercise, List<String> userAnswer) {
    if (exercise.correctAnswer.isEmpty) return 0.0;
    if (userAnswer.isEmpty) return 0.0;

    final correctPairs = <String, String>{};
    for (final pair in exercise.correctAnswer) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        correctPairs[parts[0].trim().toLowerCase()] =
            parts[1].trim().toLowerCase();
      }
    }

    if (correctPairs.isEmpty) return 0.0;

    int correctCount = 0;
    for (final pair in userAnswer) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim().toLowerCase();
        final value = parts[1].trim().toLowerCase();
        if (correctPairs[key] == value) {
          correctCount++;
        }
      }
    }

    return correctCount / correctPairs.length;
  }

  // Keyword matching, partial credit
  static double _scoreOpenEnded(Exercise exercise, List<String> userAnswer) {
    if (userAnswer.isEmpty || exercise.correctAnswer.isEmpty) return 0.0;

    final userText = userAnswer.first.trim().toLowerCase();
    if (userText.isEmpty) return 0.0;

    int matchedKeywords = 0;
    for (final keyword in exercise.correctAnswer) {
      final normalizedKeyword = keyword.trim().toLowerCase();
      if (normalizedKeyword.isNotEmpty && userText.contains(normalizedKeyword)) {
        matchedKeywords++;
      }
    }

    return matchedKeywords / exercise.correctAnswer.length;
  }
}
