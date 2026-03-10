import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/exercise.dart';

class OpenEndedExercise extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;
  final bool isSubmitted;
  final double? score;

  const OpenEndedExercise({
    super.key,
    required this.exercise,
    required this.controller,
    required this.isSubmitted,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveScore = score ?? 0.0;
    final isGood = effectiveScore >= 0.7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Open Ended',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
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
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(
            hintText: 'Write your answer here...',
            hintStyle: TextStyle(
              color: AppColors.textHint,
              fontSize: 15,
            ),
            filled: true,
            fillColor: isSubmitted
                ? (isGood
                    ? AppColors.success.withValues(alpha: 0.04)
                    : AppColors.warning.withValues(alpha: 0.04))
                : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
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
                color: isGood ? AppColors.success : AppColors.warning,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
          ),
        ),
        if (isSubmitted) ...[
          const SizedBox(height: 14),
          // Score indicator
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isGood
                  ? AppColors.success.withValues(alpha: 0.06)
                  : AppColors.warning.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isGood
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PhosphorIcon(
                      isGood
                          ? PhosphorIcons.checkCircle()
                          : PhosphorIcons.warning(),
                      size: 18,
                      color: isGood ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Keyword match: ${(effectiveScore * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isGood ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Key terms to include: ${exercise.correctAnswer.join(", ")}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
