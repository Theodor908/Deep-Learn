import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/app_colors.dart';
import '../../features/courses/domain/entities/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('/course/${course.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withAlpha(80)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: course.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: AppColors.primarySurface,
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIcons.image(),
                      size: 32,
                      color: AppColors.primary.withAlpha(60),
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.primarySurface,
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIcons.imageSquare(),
                      size: 32,
                      color: AppColors.primary.withAlpha(80),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    course.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Bottom row: sections count + enrollment
                  Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.bookOpenText(),
                        size: 14,
                        color: AppColors.primary.withAlpha(160),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.totalSections} sections',
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 12),
                      PhosphorIcon(
                        PhosphorIcons.users(),
                        size: 14,
                        color: AppColors.secondary.withAlpha(180),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEnrollment(course.enrollmentCount),
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatEnrollment(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k';
    }
    return '$count';
  }
}
