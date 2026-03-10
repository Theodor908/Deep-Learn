import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/exercise.dart';

class MatchingExercise extends StatelessWidget {
  final Exercise exercise;
  final Map<String, String> userMatches;
  final bool isSubmitted;
  final void Function(String left, String right) onMatchSelected;

  const MatchingExercise({
    super.key,
    required this.exercise,
    required this.userMatches,
    required this.isSubmitted,
    required this.onMatchSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Parse left items and right items from correctAnswer format "left:right"
    final pairs = <String, String>{};
    for (final pair in exercise.correctAnswer) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        pairs[parts[0].trim()] = parts[1].trim();
      }
    }

    final leftItems = pairs.keys.toList();
    final rightItems = pairs.values.toList()..shuffle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Matching',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
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
        Text(
          'Match each item on the left with its pair on the right',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        ...leftItems.map((leftItem) {
          final userMatch = userMatches[leftItem];
          final correctMatch = pairs[leftItem]!;
          final isCorrectMatch = isSubmitted &&
              userMatch != null &&
              userMatch.trim().toLowerCase() ==
                  correctMatch.trim().toLowerCase();
          final isWrongMatch = isSubmitted && userMatch != null && !isCorrectMatch;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSubmitted
                    ? (isCorrectMatch
                        ? AppColors.success.withValues(alpha: 0.05)
                        : isWrongMatch
                            ? AppColors.error.withValues(alpha: 0.05)
                            : AppColors.surface)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSubmitted
                      ? (isCorrectMatch
                          ? AppColors.success
                          : isWrongMatch
                              ? AppColors.error
                              : AppColors.border)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  // Left item
                  Expanded(
                    flex: 2,
                    child: Text(
                      leftItem,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  // Arrow
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: PhosphorIcon(
                      PhosphorIcons.arrowRight(),
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
                  // Right item dropdown
                  Expanded(
                    flex: 3,
                    child: isSubmitted
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userMatch ?? '—',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isCorrectMatch
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ),
                              if (isCorrectMatch)
                                PhosphorIcon(
                                  PhosphorIcons.checkCircle(
                                      PhosphorIconsStyle.fill),
                                  size: 20,
                                  color: AppColors.success,
                                ),
                              if (isWrongMatch)
                                PhosphorIcon(
                                  PhosphorIcons.xCircle(
                                      PhosphorIconsStyle.fill),
                                  size: 20,
                                  color: AppColors.error,
                                ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: userMatch,
                                isExpanded: true,
                                hint: Text(
                                  'Select...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                icon: PhosphorIcon(
                                  PhosphorIcons.caretDown(),
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                items: rightItems
                                    .map(
                                      (right) => DropdownMenuItem(
                                        value: right,
                                        child: Text(
                                          right,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    onMatchSelected(leftItem, value);
                                  }
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (isSubmitted) ...[
          const SizedBox(height: 8),
          ...leftItems.where((left) {
            final userMatch = userMatches[left];
            final correctMatch = pairs[left]!;
            return userMatch == null ||
                userMatch.trim().toLowerCase() !=
                    correctMatch.trim().toLowerCase();
          }).map(
            (left) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  PhosphorIcon(
                    PhosphorIcons.lightbulb(),
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$left → ${pairs[left]}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
