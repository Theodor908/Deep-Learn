import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../courses/domain/entities/exercise.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../providers/admin_provider.dart';

class AdminExerciseEditorScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String sectionId;
  final String sectionTitle;

  const AdminExerciseEditorScreen({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.sectionTitle,
  });

  @override
  ConsumerState<AdminExerciseEditorScreen> createState() =>
      _AdminExerciseEditorScreenState();
}

class _AdminExerciseEditorScreenState
    extends ConsumerState<AdminExerciseEditorScreen> {
  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(
      sectionExercisesProvider(widget.courseId, widget.sectionId),
    );

    ref.listen(adminCourseNotifierProvider, (prev, next) {
      if (next.hasValue && prev?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Exercise saved'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercises',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              widget.sectionTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () => _showExerciseDialog(
          context,
          nextOrder: (exercisesAsync.valueOrNull?.length ?? 0) + 1,
        ),
        child: PhosphorIcon(PhosphorIcons.plus(), size: 20),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (exercises) {
          if (exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.exam(),
                    size: 48,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No exercises yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap + to add one',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            );
          }

          final sorted = List<Exercise>.from(exercises)
            ..sort((a, b) => a.order.compareTo(b.order));

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final exercise = sorted[index];
              return _ExerciseTile(
                exercise: exercise,
                onTap: () => _showExerciseDialog(
                  context,
                  exercise: exercise,
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _typeLabel(ExerciseType type) {
    return switch (type) {
      ExerciseType.mcq => 'MCQ',
      ExerciseType.trueFalse => 'True/False',
      ExerciseType.fillBlank => 'Fill Blank',
      ExerciseType.matching => 'Matching',
      ExerciseType.openEnded => 'Open Ended',
    };
  }

  void _showExerciseDialog(
    BuildContext context, {
    Exercise? exercise,
    int? nextOrder,
  }) {
    final isEditing = exercise != null;
    final questionController =
        TextEditingController(text: exercise?.question ?? '');
    final optionsController =
        TextEditingController(text: exercise?.options.join(', ') ?? '');
    final correctAnswerController = TextEditingController(
        text: exercise?.correctAnswer.join(', ') ?? '');
    final explanationController =
        TextEditingController(text: exercise?.explanation ?? '');
    String selectedType = exercise?.type.name ?? 'mcq';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            20, 20, 20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEditing ? 'Edit Exercise' : 'Add Exercise',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),

                // Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'mcq', child: Text('Multiple Choice')),
                    DropdownMenuItem(
                        value: 'trueFalse', child: Text('True / False')),
                    DropdownMenuItem(
                        value: 'fillBlank', child: Text('Fill in the Blank')),
                    DropdownMenuItem(
                        value: 'matching', child: Text('Matching')),
                    DropdownMenuItem(
                        value: 'openEnded', child: Text('Open Ended')),
                  ],
                  onChanged: (v) =>
                      setSheetState(() => selectedType = v!),
                ),
                const SizedBox(height: 14),

                // Question
                TextField(
                  controller: questionController,
                  maxLines: 2,
                  decoration: _inputDecoration('Question'),
                ),
                const SizedBox(height: 14),

                // Options
                TextField(
                  controller: optionsController,
                  decoration:
                      _inputDecoration('Options (comma-separated)'),
                ),
                const SizedBox(height: 14),

                // Correct answer
                TextField(
                  controller: correctAnswerController,
                  decoration: _inputDecoration('Correct Answer'),
                ),
                const SizedBox(height: 14),

                // Explanation
                TextField(
                  controller: explanationController,
                  maxLines: 2,
                  decoration:
                      _inputDecoration('Explanation (optional)'),
                ),
                const SizedBox(height: 20),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final question = questionController.text.trim();
                      final correctAnswer =
                          correctAnswerController.text.trim();
                      if (question.isEmpty || correctAnswer.isEmpty) return;

                      Navigator.pop(ctx);

                      final options = optionsController.text
                          .split(',')
                          .map((o) => o.trim())
                          .where((o) => o.isNotEmpty)
                          .toList();

                      final notifier = ref
                          .read(adminCourseNotifierProvider.notifier);

                      if (isEditing) {
                        notifier.updateExercise(
                          courseId: widget.courseId,
                          sectionId: widget.sectionId,
                          exerciseId: exercise.id,
                          type: selectedType,
                          question: question,
                          options: options,
                          correctAnswer: correctAnswer,
                          explanation:
                              explanationController.text.trim().isNotEmpty
                                  ? explanationController.text.trim()
                                  : null,
                        );
                      } else {
                        notifier.addExercise(
                          courseId: widget.courseId,
                          sectionId: widget.sectionId,
                          type: selectedType,
                          question: question,
                          options: options,
                          correctAnswer: correctAnswer,
                          order: nextOrder ?? 1,
                          explanation:
                              explanationController.text.trim().isNotEmpty
                                  ? explanationController.text.trim()
                                  : null,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Add Exercise',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseTile({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${exercise.order}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.question,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _typeLabel(exercise.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (exercise.options.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${exercise.options.length} options',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textHint,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PhosphorIcon(
                PhosphorIcons.pencilSimple(),
                size: 18,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(ExerciseType type) {
    return switch (type) {
      ExerciseType.mcq => 'MCQ',
      ExerciseType.trueFalse => 'True/False',
      ExerciseType.fillBlank => 'Fill Blank',
      ExerciseType.matching => 'Matching',
      ExerciseType.openEnded => 'Open Ended',
    };
  }
}
