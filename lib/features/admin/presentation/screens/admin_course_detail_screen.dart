import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../courses/domain/entities/enrollment.dart';
import '../../../courses/domain/entities/section.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../providers/admin_provider.dart';
import 'admin_course_editor_screen.dart';
import 'admin_section_editor_screen.dart';
import 'admin_exercise_editor_screen.dart';

class AdminCourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const AdminCourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final sectionsAsync = ref.watch(courseSectionsProvider(courseId));
    final enrollmentsAsync = ref.watch(courseEnrollmentsProvider(courseId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: courseAsync.when(
            data: (course) => Text(
              course.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            loading: () => const Text('Loading...'),
            error: (_, __) => const Text('Error'),
          ),
          actions: [
            courseAsync.whenOrNull(
                  data: (course) => IconButton(
                    icon: PhosphorIcon(PhosphorIcons.pencilSimple(), size: 22),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdminCourseEditorScreen(course: course),
                      ),
                    ),
                  ),
                ) ??
                const SizedBox.shrink(),
          ],
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Sections'),
              Tab(text: 'Enrolled Users'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Sections tab
            _SectionsTab(
              courseId: courseId,
              sectionsAsync: sectionsAsync,
            ),
            // Enrolled users tab
            _EnrolledUsersTab(
              enrollmentsAsync: enrollmentsAsync,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionsTab extends ConsumerWidget {
  final String courseId;
  final AsyncValue<List<Section>> sectionsAsync;

  const _SectionsTab({
    required this.courseId,
    required this.sectionsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () {
          final nextOrder =
              (sectionsAsync.valueOrNull?.length ?? 0) + 1;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AdminSectionEditorScreen(
                courseId: courseId,
                nextOrder: nextOrder,
              ),
            ),
          );
        },
        child: PhosphorIcon(PhosphorIcons.plus(), size: 20),
      ),
      body: sectionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (sections) {
          if (sections.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.bookOpenText(),
                    size: 48,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No sections yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final sorted = List<Section>.from(sections)
            ..sort((a, b) => a.order.compareTo(b.order));

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final section = sorted[index];
              return _AdminSectionTile(
                section: section,
                courseId: courseId,
              );
            },
          );
        },
      ),
    );
  }
}

class _AdminSectionTile extends StatelessWidget {
  final Section section;
  final String courseId;

  const _AdminSectionTile({
    required this.section,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${section.order}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    section.summary,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Edit section button
            IconButton(
              icon: PhosphorIcon(
                PhosphorIcons.pencilSimple(),
                size: 18,
                color: AppColors.primary,
              ),
              tooltip: 'Edit section',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminSectionEditorScreen(
                    courseId: courseId,
                    nextOrder: section.order,
                    section: section,
                  ),
                ),
              ),
            ),
            // Exercises button
            IconButton(
              icon: PhosphorIcon(
                PhosphorIcons.exam(),
                size: 18,
                color: AppColors.secondary,
              ),
              tooltip: 'Exercises',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminExerciseEditorScreen(
                    courseId: courseId,
                    sectionId: section.id,
                    sectionTitle: section.title,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrolledUsersTab extends ConsumerWidget {
  final AsyncValue<List<Enrollment>> enrollmentsAsync;

  const _EnrolledUsersTab({required this.enrollmentsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return enrollmentsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (enrollments) {
        if (enrollments.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PhosphorIcon(
                  PhosphorIcons.users(),
                  size: 48,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 12),
                Text(
                  'No enrolled users yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: enrollments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final enrollment = enrollments[index];
            return _EnrolledUserTile(enrollment: enrollment);
          },
        );
      },
    );
  }
}

class _EnrolledUserTile extends ConsumerWidget {
  final Enrollment enrollment;

  const _EnrolledUserTile({required this.enrollment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(enrollment.userId));

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // User avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
              child: Center(
                child: userAsync.when(
                  data: (user) => Text(
                    _getInitials(user),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  error: (_, __) => const Text(
                    '?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userAsync.when(
                    data: (user) => Text(
                      user?.displayName ?? 'Unknown User',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    loading: () => Text(
                      'Loading...',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.textHint),
                    ),
                    error: (_, __) => Text(
                      'User not found',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.error),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${(enrollment.completionPercentage * 100).round()}% complete',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                      ),
                      if (enrollment.rating > 0) ...[
                        const SizedBox(width: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (i) {
                            return PhosphorIcon(
                              i < enrollment.rating
                                  ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                                  : PhosphorIcons.star(),
                              size: 12,
                              color: i < enrollment.rating
                                  ? AppColors.warning
                                  : AppColors.textHint,
                            );
                          }),
                        ),
                      ],
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

  String _getInitials(AppUser? user) {
    if (user == null || user.displayName.isEmpty) return '?';
    return user.displayName
        .trim()
        .split(' ')
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();
  }
}
