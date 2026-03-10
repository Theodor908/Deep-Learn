import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../courses/domain/entities/course.dart';
import 'course_card.dart';

class HorizontalCourseList extends StatelessWidget {
  final List<Course> courses;
  final Map<String, double>? progressMap;
  final String? actionLabel;
  final ValueChanged<Course>? onCourseTap;
  final ValueChanged<Course>? onAction;

  const HorizontalCourseList({
    super.key,
    required this.courses,
    this.progressMap,
    this.actionLabel,
    this.onCourseTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return _EmptyState();
    }

    return SizedBox(
      height: _computeHeight(),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final course = courses[index];
          final progress = progressMap?[course.id];
          return CourseCard(
            course: course,
            progress: progress,
            actionLabel: actionLabel,
            onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
            onAction: onAction != null ? () => onAction!(course) : null,
          );
        },
      ),
    );
  }

  double _computeHeight() {
    // Base: image (120) + title area (~62) + meta (~18) + padding
    double height = 230;
    if (progressMap != null) height += 30;
    if (actionLabel != null) height += 36;
    return height;
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withAlpha(120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withAlpha(25),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIcons.bookOpen(),
              size: 32,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 8),
            Text(
              'No courses yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
