import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/section.dart';

enum SectionStatus { preview, unlocked, completed, locked, enrollToUnlock }

class SectionTile extends StatelessWidget {
  final Section section;
  final SectionStatus status;
  final VoidCallback? onTap;

  const SectionTile({
    super.key,
    required this.section,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAccessible =
        status == SectionStatus.preview ||
        status == SectionStatus.unlocked ||
        status == SectionStatus.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isAccessible ? AppColors.surface : AppColors.divider.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        elevation: isAccessible ? 1 : 0,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        child: InkWell(
          onTap: isAccessible ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Section number badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: status == SectionStatus.completed
                        ? PhosphorIcon(
                            PhosphorIcons.check(PhosphorIconsStyle.bold),
                            size: 20,
                            color: Colors.white,
                          )
                        : (status == SectionStatus.locked ||
                              status == SectionStatus.enrollToUnlock)
                            ? PhosphorIcon(
                                PhosphorIcons.lock(),
                                size: 18,
                                color: AppColors.textHint,
                              )
                            : Text(
                                '${section.order}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: isAccessible
                                      ? Colors.white
                                      : AppColors.textHint,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 14),
                // Section info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              section.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: isAccessible
                                        ? AppColors.textPrimary
                                        : AppColors.textHint,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          if (status == SectionStatus.preview)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'PREVIEW',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryDark,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          if (status == SectionStatus.completed)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'COMPLETED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        section.summary,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isAccessible
                                  ? AppColors.textSecondary
                                  : AppColors.textHint,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (status == SectionStatus.locked) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.info(),
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Complete previous section to unlock',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (status == SectionStatus.enrollToUnlock) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.graduationCap(),
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Enroll to unlock',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (isAccessible) ...[
                  const SizedBox(width: 8),
                  PhosphorIcon(
                    PhosphorIcons.caretRight(),
                    size: 20,
                    color: AppColors.textHint,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color get _badgeColor => switch (status) {
        SectionStatus.completed => AppColors.success,
        SectionStatus.preview => AppColors.secondary,
        SectionStatus.unlocked => AppColors.primary,
        SectionStatus.locked => AppColors.locked.withValues(alpha: 0.4),
        SectionStatus.enrollToUnlock => AppColors.locked.withValues(alpha: 0.4),
      };
}
