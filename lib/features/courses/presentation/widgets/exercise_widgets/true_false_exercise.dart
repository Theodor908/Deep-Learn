import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/exercise.dart';

class TrueFalseExercise extends StatelessWidget {
  final Exercise exercise;
  final String? selectedAnswer;
  final bool isSubmitted;
  final ValueChanged<String> onAnswerSelected;

  const TrueFalseExercise({
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'True or False',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.info,
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
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TrueFalseButton(
                label: 'True',
                icon: PhosphorIcons.checkCircle(),
                isSelected: selectedAnswer == 'true',
                isCorrect: isSubmitted &&
                    exercise.correctAnswer.isNotEmpty &&
                    exercise.correctAnswer.first.toLowerCase() == 'true',
                isWrong: isSubmitted &&
                    selectedAnswer == 'true' &&
                    exercise.correctAnswer.isNotEmpty &&
                    exercise.correctAnswer.first.toLowerCase() != 'true',
                isSubmitted: isSubmitted,
                onTap: () => onAnswerSelected('true'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _TrueFalseButton(
                label: 'False',
                icon: PhosphorIcons.xCircle(),
                isSelected: selectedAnswer == 'false',
                isCorrect: isSubmitted &&
                    exercise.correctAnswer.isNotEmpty &&
                    exercise.correctAnswer.first.toLowerCase() == 'false',
                isWrong: isSubmitted &&
                    selectedAnswer == 'false' &&
                    exercise.correctAnswer.isNotEmpty &&
                    exercise.correctAnswer.first.toLowerCase() != 'false',
                isSubmitted: isSubmitted,
                onTap: () => onAnswerSelected('false'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isSubmitted;
  final VoidCallback onTap;

  const _TrueFalseButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.isSubmitted,
    required this.onTap,
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

    return Material(
      color: isSubmitted && isCorrect
          ? AppColors.success.withValues(alpha: 0.08)
          : isWrong
              ? AppColors.error.withValues(alpha: 0.08)
              : isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isSubmitted ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color, width: isSelected ? 2.5 : 1.5),
          ),
          child: Column(
            children: [
              PhosphorIcon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: color == AppColors.border
                      ? AppColors.textPrimary
                      : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
