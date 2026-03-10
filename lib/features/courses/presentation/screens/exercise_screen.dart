import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/exercise_scorer.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../practice/presentation/providers/practice_provider.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/section.dart';
import '../providers/course_provider.dart';
import 'section_content_screen.dart';
import '../providers/enrollment_provider.dart';
import '../widgets/exercise_widgets/fill_blank_exercise.dart';
import '../widgets/exercise_widgets/matching_exercise.dart';
import '../widgets/exercise_widgets/mcq_exercise.dart';
import '../widgets/exercise_widgets/open_ended_exercise.dart';
import '../widgets/exercise_widgets/photo_exercise_widget.dart';
import '../widgets/exercise_widgets/true_false_exercise.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String sectionId;
  final String sectionTitle;
  final int sectionOrder;

  const ExerciseScreen({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.sectionTitle,
    required this.sectionOrder,
  });

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  // Answers keyed by exercise ID.
  final Map<String, List<String>> _answers = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, Map<String, String>> _matchingAnswers = {};

  bool _isSubmitted = false;
  double _overallScore = 0.0;

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(
      sectionExercisesProvider(widget.courseId, widget.sectionId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              widget.sectionTitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => ErrorDisplay(
          error: error,
          onRetry: () => ref.invalidate(
            sectionExercisesProvider(widget.courseId, widget.sectionId),
          ),
        ),
        data: (exercises) {
          if (exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.checkCircle(PhosphorIconsStyle.duotone),
                    size: 64,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No exercises for this section',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This section is complete!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final sortedExercises = List<Exercise>.from(exercises)
            ..sort((a, b) => a.order.compareTo(b.order));
            final scorableExercises = sortedExercises.where((e) => e.type != ExerciseType.photo).toList();

          return Column(
            children: [
              // Progress bar
              if (!_isSubmitted && scorableExercises.isNotEmpty)
                _ProgressBar(
                  answered: _answers.keys.where((id) =>
                    sortedExercises.any((e) => e.id == id && e.type != ExerciseType.photo)
                  ).length,
                  total: scorableExercises.length,
                ),

              // Result banner
              if (_isSubmitted) _ResultBanner(score: _overallScore),

              // Exercise list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: sortedExercises.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.divider,
                      thickness: 1.5,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final exercise = sortedExercises[index];
                    return _buildExerciseWidget(exercise, index);
                  },
                ),
              ),

              // Submit / Retry button
              if (scorableExercises.isNotEmpty)
                _BottomBar(
                  isSubmitted: _isSubmitted,
                  canSubmit: _answers.length == scorableExercises.length,
                  passed: _overallScore >= AppConstants.passThreshold,
                  onSubmit: () => _submit(scorableExercises),
                  onRetry: _retry,
                  onContinue: _handleContinue,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExerciseWidget(Exercise exercise, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Question ${index + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
              letterSpacing: 0.8,
            ),
          ),
        ),
        switch (exercise.type) {
          ExerciseType.mcq => McqExercise(
              exercise: exercise,
              selectedAnswer:
                  _answers[exercise.id]?.isNotEmpty == true ? _answers[exercise.id]!.first : null,
              isSubmitted: _isSubmitted,
              onAnswerSelected: (answer) {
                setState(() {
                  _answers[exercise.id] = [answer];
                });
              },
            ),
          ExerciseType.trueFalse => TrueFalseExercise(
              exercise: exercise,
              selectedAnswer:
                  _answers[exercise.id]?.isNotEmpty == true ? _answers[exercise.id]!.first : null,
              isSubmitted: _isSubmitted,
              onAnswerSelected: (answer) {
                setState(() {
                  _answers[exercise.id] = [answer];
                });
              },
            ),
          ExerciseType.fillBlank => FillBlankExercise(
              exercise: exercise,
              controller: _getTextController(exercise.id),
              isSubmitted: _isSubmitted,
            ),
          ExerciseType.matching => MatchingExercise(
              exercise: exercise,
              userMatches: _matchingAnswers[exercise.id] ?? {},
              isSubmitted: _isSubmitted,
              onMatchSelected: (left, right) {
                setState(() {
                  _matchingAnswers.putIfAbsent(exercise.id, () => {});
                  _matchingAnswers[exercise.id]![left] = right;
                  // Convert to the "left:right" format for scoring.
                  _answers[exercise.id] = _matchingAnswers[exercise.id]!
                      .entries
                      .map((e) => '${e.key}:${e.value}')
                      .toList();
                });
              },
            ),
          ExerciseType.openEnded => OpenEndedExercise(
              exercise: exercise,
              controller: _getTextController(exercise.id),
              isSubmitted: _isSubmitted,
              score: _isSubmitted
                  ? ExerciseScorer.score(
                      exercise, [_getTextController(exercise.id).text])
                  : null,
            ),
          ExerciseType.photo => PhotoExerciseWidget(
              exercise: exercise,
            ),
        },
        // Explanation (shown after submission)
        if (_isSubmitted && exercise.explanation != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhosphorIcon(
                  PhosphorIcons.info(),
                  size: 18,
                  color: AppColors.info,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    exercise.explanation!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  TextEditingController _getTextController(String exerciseId) {
    return _textControllers.putIfAbsent(
      exerciseId,
      () {
        final controller = TextEditingController();
        controller.addListener(() {
          if (controller.text.trim().isNotEmpty) {
            _answers[exerciseId] = [controller.text];
          } else {
            _answers.remove(exerciseId);
          }
          if (mounted) setState(() {});
        });
        return controller;
      },
    );
  }

  Future<void> _submit(List<Exercise> exercises) async {
    // Ensure text controllers have their values captured.
    for (final exercise in exercises) {
      if (exercise.type == ExerciseType.fillBlank ||
          exercise.type == ExerciseType.openEnded) {
        final controller = _textControllers[exercise.id];
        if (controller != null && controller.text.trim().isNotEmpty) {
          _answers[exercise.id] = [controller.text];
        }
      }
    }

    final score = ExerciseScorer.scoreAll(exercises, _answers);

    setState(() {
      _isSubmitted = true;
      _overallScore = score;
    });

    // Save result and schedule review via practice provider.
    ref.read(practiceNotifierProvider.notifier).completeSectionPractice(
          courseId: widget.courseId,
          sectionId: widget.sectionId,
          totalExercises: exercises.length,
        );

    // Update enrollment progress if passed.
    if (score >= AppConstants.passThreshold) {
      final enrollment =
          await ref.read(enrollmentProvider(widget.courseId).future);
      final currentCompleted = enrollment?.completedSections ?? <int>[];
      final updatedCompleted =
          {...currentCompleted, widget.sectionOrder}.toList();

      final course =
          await ref.read(courseDetailProvider(widget.courseId).future);
      final total = course.totalSections;
      final percentage = total > 0 ? updatedCompleted.length / total : 0.0;

      ref.read(enrollmentNotifierProvider.notifier).updateProgress(
            widget.courseId,
            currentSectionOrder: widget.sectionOrder + 1,
            completedSections: [widget.sectionOrder],
            completionPercentage: percentage,
          );
    }
  }

  void _retry() {
    setState(() {
      _isSubmitted = false;
      _overallScore = 0.0;
      _answers.clear();
      _matchingAnswers.clear();
      for (final controller in _textControllers.values) {
        controller.clear();
      }
    });
    ref.read(practiceNotifierProvider.notifier).reset();
  }

  Future<void> _handleContinue() async {
    final passed = _overallScore >= AppConstants.passThreshold;

    // Failed attempt: just pop back to section content screen
    if (!passed) {
      Navigator.of(context).pop();
      return;
    }

    final sections = await ref.read(
      courseSectionsProvider(widget.courseId).future,
    );
    final sorted = List<Section>.from(sections)
      ..sort((a, b) => a.order.compareTo(b.order));
    final nextSection = sorted
        .where((s) => s.order == widget.sectionOrder + 1)
        .firstOrNull;

    if (!mounted) return;

    // Pop ExerciseScreen + SectionContentScreen (back to CourseDetailScreen)
    var count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);

    if (nextSection != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SectionContentScreen(
            courseId: widget.courseId,
            sectionId: nextSection.id,
            sectionTitle: nextSection.title,
          ),
        ),
      );
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final int answered;
  final int total;

  const _ProgressBar({required this.answered, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? answered / total : 0,
                minHeight: 6,
                backgroundColor: AppColors.progressTrack,
                valueColor: const AlwaysStoppedAnimation(AppColors.progressFill),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '$answered / $total',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final double score;

  const _ResultBanner({required this.score});

  @override
  Widget build(BuildContext context) {
    final passed = score >= AppConstants.passThreshold;
    final percentage = (score * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: passed
              ? [
                  AppColors.success.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.08),
                ]
              : [
                  AppColors.error.withValues(alpha: 0.1),
                  AppColors.warning.withValues(alpha: 0.08),
                ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.error.withValues(alpha: 0.15),
            ),
            child: Center(
              child: PhosphorIcon(
                passed
                    ? PhosphorIcons.trophy(PhosphorIconsStyle.fill)
                    : PhosphorIcons.arrowCounterClockwise(),
                size: 28,
                color: passed ? AppColors.success : AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passed ? 'Great work!' : 'Keep practicing!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: passed ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  passed
                      ? 'You scored $percentage% — section unlocked!'
                      : 'You scored $percentage% — need ${(AppConstants.passThreshold * 100).round()}% to pass',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Score circle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: passed ? AppColors.success : AppColors.error,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: passed ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isSubmitted;
  final bool canSubmit;
  final bool passed;
  final VoidCallback onSubmit;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const _BottomBar({
    required this.isSubmitted,
    required this.canSubmit,
    required this.passed,
    required this.onSubmit,
    required this.onRetry,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: isSubmitted
            ? Row(
                children: [
                  if (!passed)
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: onRetry,
                          icon: PhosphorIcon(
                            PhosphorIcons.arrowCounterClockwise(),
                            size: 20,
                          ),
                          label: const Text(
                            'Retry',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!passed) const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              passed ? AppColors.success : AppColors.secondary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          passed ? 'Continue' : 'Done',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: canSubmit ? onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.3),
                    disabledForegroundColor: Colors.white60,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Answers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
