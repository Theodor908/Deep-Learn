import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/exercise.dart';

class McqExercise extends StatelessWidget {
  final Exercise exercise;
  final String? selectedAnswer;
  final bool isSubmitted;
  final ValueChanged<String> onAnswerSelected;

  const McqExercise({
    super.key,
    required this.exercise,
    required this.selectedAnswer,
    required this.isSubmitted,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _QuestionHeader(exercise: exercise),
        const SizedBox(height: 20),
        ...exercise.options.map((option) {
          final isSelected = selectedAnswer == option;
          final isCorrect = isSubmitted &&
              exercise.correctAnswer.isNotEmpty &&
              option.trim().toLowerCase() ==
                  exercise.correctAnswer.first.trim().toLowerCase();
          final isWrong = isSubmitted && isSelected && !isCorrect;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: _optionColor(isSelected, isCorrect, isWrong, isSubmitted),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: isSubmitted ? null : () => onAnswerSelected(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _borderColor(isSelected, isCorrect, isWrong, isSubmitted),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      _RadioIndicator(
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        isWrong: isWrong,
                        isSubmitted: isSubmitted,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSubmitted && isCorrect
                                ? AppColors.success
                                : isWrong
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSubmitted && isCorrect)
                        PhosphorIcon(
                          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                          size: 22,
                          color: AppColors.success,
                        ),
                      if (isWrong)
                        PhosphorIcon(
                          PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                          size: 22,
                          color: AppColors.error,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _optionColor(bool selected, bool correct, bool wrong, bool submitted) {
    if (submitted && correct) return AppColors.success.withValues(alpha: 0.06);
    if (wrong) return AppColors.error.withValues(alpha: 0.06);
    if (selected) return AppColors.primary.withValues(alpha: 0.06);
    return AppColors.surface;
  }

  Color _borderColor(bool selected, bool correct, bool wrong, bool submitted) {
    if (submitted && correct) return AppColors.success;
    if (wrong) return AppColors.error;
    if (selected) return AppColors.primary;
    return AppColors.border;
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isSubmitted;

  const _RadioIndicator({
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSubmitted && isCorrect
        ? AppColors.success
        : isWrong
            ? AppColors.error
            : isSelected
                ? AppColors.primary
                : AppColors.border;

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            )
          : null,
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final Exercise exercise;

  const _QuestionHeader({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Multiple Choice',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          exercise.question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}
