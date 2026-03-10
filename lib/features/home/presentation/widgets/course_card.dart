import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../courses/domain/entities/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final double? progress;
  final String? actionLabel;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const CourseCard({
    super.key,
    required this.course,
    this.progress,
    this.actionLabel,
    this.onTap,
    this.onAction,
  });

  static const double cardWidth = 200;
  static const double _imageHeight = 120;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withAlpha(18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.primaryDark.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _CourseImage(imageUrl: course.imageUrl),
                if (progress != null && progress! >= 1.0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withAlpha(80),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.trophy(PhosphorIconsStyle.fill),
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'FINISHED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _CourseMetaRow(
                    sectionCount: course.totalSections,
                    enrollmentCount: course.enrollmentCount,
                  ),
                  if (progress != null) ...[
                    const SizedBox(height: 10),
                    _ProgressIndicator(progress: progress!),
                  ],
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 10),
                    _ActionButton(
                      label: actionLabel!,
                      onTap: onAction!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseImage extends StatelessWidget {
  final String imageUrl;

  const _CourseImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: CourseCard._imageHeight,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primarySurface,
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.graduationCap(),
                size: 40,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseMetaRow extends StatelessWidget {
  final int sectionCount;
  final int enrollmentCount;

  const _CourseMetaRow({
    required this.sectionCount,
    required this.enrollmentCount,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textHint,
          fontSize: 11,
        );

    return Row(
      children: [
        PhosphorIcon(
          PhosphorIcons.bookOpenText(),
          size: 13,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text('$sectionCount sections', style: style, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 10),
        PhosphorIcon(
          PhosphorIcons.users(),
          size: 13,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 3),
        Text('$enrollmentCount', style: style),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;

  const _ProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.progressTrack,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.progressFill,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          backgroundColor: AppColors.secondary.withAlpha(18),
          padding: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: VisualDensity.compact,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
