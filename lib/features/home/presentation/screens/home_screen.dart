import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/entities/enrollment.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../../../courses/presentation/providers/enrollment_provider.dart';
import '../../../practice/domain/entities/review_item.dart';
import '../../../practice/presentation/providers/practice_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/cta_banner.dart';
import '../widgets/horizontal_course_list.dart';
import '../widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;
    final isAuthenticated = user != null;

    return Scaffold(
      appBar: _buildAppBar(context, ref, isAuthenticated),
      body: isAuthenticated
          ? _AuthenticatedBody(
              displayName: user.displayName, photoUrl: user.photoUrl)
          : const _GuestBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, WidgetRef ref, bool isAuthenticated) {
    if (isAuthenticated) {
      final user = ref.watch(authStateProvider).valueOrNull!;
      final surname = user.displayName.split(' ').last;

      return AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello $surname',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    letterSpacing: -0.3,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Ready to learn something new?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ],
        ),
        toolbarHeight: 72,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => context.go('/profile'),
              child: _ProfileAvatar(
                photoUrl: user.photoUrl,
                displayName: user.displayName,
              ),
            ),
          ),
        ],
      );
    }

    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: PhosphorIcon(
              PhosphorIcons.brain(PhosphorIconsStyle.fill),
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Deep Learn',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: -0.5,
                ),
          ),
        ],
      ),
      toolbarHeight: 64,
      actions: [
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(
            'Sign In',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Guest (non-authenticated) body
// ─────────────────────────────────────────────────

class _GuestBody extends ConsumerWidget {
  const _GuestBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mostEnrolled = ref.watch(mostEnrolledCoursesProvider);
    final recentCourses = ref.watch(recentCoursesProvider);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      children: [
        const SizedBox(height: 8),
        // ── Most Taken Paths ──
        SectionHeader(
          title: 'Most Taken Paths',
          onViewMore: () => context.go('/search'),
        ),
        const SizedBox(height: 12),
        mostEnrolled.when(
          data: (courses) => HorizontalCourseList(
            courses: courses,
            onCourseTap: (c) => context.go('/course/${c.id}'),
          ),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),

        const SizedBox(height: 28),

        // ── Recent Endeavours ──
        SectionHeader(
          title: 'Recent Endeavours',
          onViewMore: () => context.go('/search'),
        ),
        const SizedBox(height: 12),
        recentCourses.when(
          data: (courses) => HorizontalCourseList(
            courses: courses,
            onCourseTap: (c) => context.go('/course/${c.id}'),
          ),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),

        const SizedBox(height: 32),

        // ── CTA Banner ──
        CtaBanner(onRegister: () => context.go('/register')),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Authenticated body
// ─────────────────────────────────────────────────

class _AuthenticatedBody extends ConsumerWidget {
  final String displayName;
  final String? photoUrl;

  const _AuthenticatedBody({
    required this.displayName,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollments = ref.watch(userEnrollmentsProvider);
    final recentCourses = ref.watch(recentCoursesProvider);
    final recommended = ref.watch(recommendedCoursesProvider);
    final dueItems = ref.watch(dueReviewItemsProvider);

    // Build progress map from enrollments for course cards
    final enrollmentProgressMap = <String, double>{};
    if (enrollments.hasValue) {
      for (final e in enrollments.value!) {
        enrollmentProgressMap[e.courseId] = e.completionPercentage;
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      children: [
        const SizedBox(height: 8),

        // ── Your Learning Paths ──
        SectionHeader(
          title: 'Your Learning Paths',
          onViewMore: () => context.go('/search'),
        ),
        const SizedBox(height: 12),
        enrollments.when(
          data: (list) => _EnrolledCoursesList(enrollments: list),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),

        const SizedBox(height: 28),

        // ── Recent Endeavours ──
        SectionHeader(
          title: 'Recent Endeavours',
          onViewMore: () => context.go('/search'),
        ),
        const SizedBox(height: 12),
        recentCourses.when(
          data: (courses) => HorizontalCourseList(
            courses: courses,
            progressMap: enrollmentProgressMap,
            onCourseTap: (c) => context.go('/course/${c.id}'),
          ),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),

        const SizedBox(height: 28),

        // ── Suggested For You ──
        SectionHeader(
          title: 'Suggested For You',
          onViewMore: () => context.go('/search'),
        ),
        const SizedBox(height: 12),
        recommended.when(
          data: (courses) => HorizontalCourseList(
            courses: courses,
            progressMap: enrollmentProgressMap,
            onCourseTap: (c) => context.go('/course/${c.id}'),
          ),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),

        const SizedBox(height: 28),

        // ── Practice to not forget ──
        SectionHeader(title: 'Practice to not forget'),
        const SizedBox(height: 12),
        dueItems.when(
          data: (items) => _PracticeReminderList(items: items),
          loading: () => const _SectionShimmer(),
          error: (_, __) => const _SectionError(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Enrolled courses — horizontal cards with progress
// ─────────────────────────────────────────────────

class _EnrolledCoursesList extends ConsumerWidget {
  final List<Enrollment> enrollments;

  const _EnrolledCoursesList({required this.enrollments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (enrollments.isEmpty) {
      return _EmptyPrompt(
        icon: PhosphorIcons.path(),
        message: 'No courses yet — start exploring!',
        actionLabel: 'Browse courses',
        onAction: () => context.go('/search'),
      );
    }

    final progressMap = <String, double>{};
    for (final e in enrollments) {
      progressMap[e.courseId] = e.completionPercentage;
    }

    // Fetch course details for each enrollment.
    final courseFutures = enrollments.map(
      (e) => ref.watch(courseDetailProvider(e.courseId)),
    );

    final courses = <Course>[];
    var isLoading = false;
    for (final future in courseFutures) {
      future.when(
        data: (course) => courses.add(course),
        loading: () => isLoading = true,
        error: (_, __) {},
      );
    }

    if (isLoading && courses.isEmpty) {
      return const _SectionShimmer();
    }

    return HorizontalCourseList(
      courses: courses,
      progressMap: progressMap,
      onCourseTap: (c) => context.go('/course/${c.id}'),
    );
  }
}

// ─────────────────────────────────────────────────
// Practice reminder cards
// ─────────────────────────────────────────────────

class _PracticeReminderList extends StatelessWidget {
  final List<ReviewItem> items;

  const _PracticeReminderList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyPrompt(
        icon: PhosphorIcons.checkCircle(),
        message: 'All caught up — nothing to review!',
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _PracticeCard(item: items[index]),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final ReviewItem item;

  const _PracticeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final overdueDays = now.difference(item.nextReviewAt).inDays;
    final isOverdue = overdueDays > 0;
    final urgencyLabel = isOverdue
        ? 'Overdue by $overdueDays day${overdueDays == 1 ? '' : 's'}'
        : 'Due today';
    final accentColor = isOverdue ? AppColors.warning : AppColors.secondary;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PhosphorIcon(
                isOverdue
                    ? PhosphorIcons.warning(PhosphorIconsStyle.fill)
                    : PhosphorIcons.brain(PhosphorIconsStyle.fill),
                size: 16,
                color: accentColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  urgencyLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            'Section review',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: TextButton(
              onPressed: () => context.go('/practice'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                backgroundColor: AppColors.secondary.withAlpha(18),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: const Text(
                'Practice now',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String displayName;

  const _ProfileAvatar({this.photoUrl, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final initials = displayName.isNotEmpty
        ? displayName
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: photoUrl != null
          ? ClipOval(
              child: Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _InitialsCircle(initials: initials),
              ),
            )
          : _InitialsCircle(initials: initials),
    );
  }
}

class _InitialsCircle extends StatelessWidget {
  final String initials;

  const _InitialsCircle({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyPrompt({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withAlpha(120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(25)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(icon, size: 28, color: AppColors.primaryLight),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionShimmer extends StatelessWidget {
  const _SectionShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => Container(
          width: CourseCard.cardWidth,
          decoration: BoxDecoration(
            color: AppColors.primarySurface.withAlpha(100),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withAlpha(40)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIcons.warningCircle(),
              size: 18,
              color: AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(
              'Could not load this section',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
