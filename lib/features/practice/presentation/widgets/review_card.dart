import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/sm2_algorithm.dart';
import '../../domain/entities/review_item.dart';

class ReviewCard extends StatelessWidget {
  final ReviewItem item;
  final String courseTitle;
  final String sectionTitle;
  final VoidCallback onTap;

  const ReviewCard({
    super.key,
    required this.item,
    required this.courseTitle,
    required this.sectionTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final urgency = Sm2Algorithm.urgencyLevel(item);
    final description = Sm2Algorithm.overdueDescription(item);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 1.5,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _urgencyBorderColor(urgency),
                width: urgency == 2 ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Urgency indicator
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _urgencyColor(urgency).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: PhosphorIcon(
                      _urgencyIcon(urgency),
                      size: 26,
                      color: _urgencyColor(urgency),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        sectionTitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _urgencyColor(urgency).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _urgencyColor(urgency),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Review count & arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.repeat(),
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.reviewCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PhosphorIcon(
                      PhosphorIcons.caretRight(),
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _urgencyColor(int urgency) => switch (urgency) {
        2 => AppColors.error,
        1 => AppColors.warning,
        _ => AppColors.secondary,
      };

  Color _urgencyBorderColor(int urgency) => switch (urgency) {
        2 => AppColors.error.withValues(alpha: 0.3),
        1 => AppColors.warning.withValues(alpha: 0.2),
        _ => AppColors.border,
      };

  IconData _urgencyIcon(int urgency) => switch (urgency) {
        2 => PhosphorIcons.fire(PhosphorIconsStyle.fill),
        1 => PhosphorIcons.clock(),
        _ => PhosphorIcons.calendarCheck(),
      };
}
