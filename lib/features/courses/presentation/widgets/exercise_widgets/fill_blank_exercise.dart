import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/exercise.dart';

class FillBlankExercise extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;
  final bool isSubmitted;

  const FillBlankExercise({
    super.key,
    required this.exercise,
    required this.controller,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = isSubmitted && _checkAnswer();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Fill in the Blank',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryDark,
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
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          enabled: !isSubmitted,
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            hintStyle: TextStyle(
              color: AppColors.textHint,
              fontSize: 15,
            ),
            filled: true,
            fillColor: isSubmitted
                ? (isCorrect
                    ? AppColors.success.withValues(alpha: 0.06)
                    : AppColors.error.withValues(alpha: 0.06))
                : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isSubmitted
                    ? (isCorrect ? AppColors.success : AppColors.error)
                    : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isCorrect ? AppColors.success : AppColors.error,
                width: 1.5,
              ),
            ),
            suffixIcon: isSubmitted
                ? (isCorrect
                    ? PhosphorIcon(
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        color: AppColors.success,
                      )
                    : PhosphorIcon(
                        PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                        color: AppColors.error,
                      ))
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: isSubmitted
                ? (isCorrect ? AppColors.success : AppColors.error)
                : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isSubmitted && !isCorrect) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.lightbulb(),
                  size: 18,
                  color: AppColors.success,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Correct answer: ${exercise.correctAnswer.join(" or ")}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
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

  bool _checkAnswer() {
    final userText = controller.text.trim().toLowerCase();
    for (final correct in exercise.correctAnswer) {
      if (userText == correct.trim().toLowerCase()) return true;
    }
    return false;
  }
}
