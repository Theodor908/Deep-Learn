import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/section.dart';
import '../providers/course_provider.dart';
import '../providers/enrollment_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/auth_wall.dart';
import '../widgets/section_tile.dart';
import 'section_content_screen.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final sectionsAsync = ref.watch(courseSectionsProvider(widget.courseId));
    final authState = ref.watch(authStateProvider);
    final enrollmentAsync = ref.watch(enrollmentProvider(widget.courseId));
    final isAuthenticated = authState.valueOrNull != null;
    final reviewsAsync = ref.watch(courseReviewsProvider(widget.courseId));
    final userReviewAsync = ref.watch(userReviewProvider(widget.courseId));

    return Scaffold(
      body: courseAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PhosphorIcon(
                PhosphorIcons.warningCircle(),
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load course',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(courseDetailProvider(widget.courseId)),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (course) {
          final enrollment = enrollmentAsync.valueOrNull;

          return CustomScrollView(
            slivers: [
              // Hero image with gradient overlay
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primary,
                leading: _BackButton(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: course.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primarySurface,
                          child: Center(
                            child: PhosphorIcon(
                              PhosphorIcons.image(),
                              size: 48,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primarySurface,
                          child: Center(
                            child: PhosphorIcon(
                              PhosphorIcons.image(),
                              size: 48,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay for readability
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color(0xCC1A1A2E),
                            ],
                            stops: [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                      // Course title overlay
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _InfoChip(
                                  icon: PhosphorIcons.bookOpenText(),
                                  label: '${course.totalSections} sections',
                                ),
                                const SizedBox(width: 12),
                                _InfoChip(
                                  icon: PhosphorIcons.users(),
                                  label: '${course.enrollmentCount} enrolled',
                                ),
                                if (course.ratingCount > 0) ...[
                                  const SizedBox(width: 12),
                                  _InfoChip(
                                    icon: PhosphorIcons.star(PhosphorIconsStyle.fill),
                                    label: '${course.averageRating.toStringAsFixed(1)} (${course.ratingCount})',
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
              ),

              // Enrollment progress bar (if enrolled)
              if (enrollment != null)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: AppColors.primaryDark),
                            ),
                            Text(
                              '${(enrollment.completionPercentage * 100).round()}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: enrollment.completionPercentage,
                            minHeight: 8,
                            backgroundColor: AppColors.progressTrack,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.progressFill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Rate this course (if enrolled)
              if (enrollment != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _RatingBar(
                      currentRating: enrollment.rating,
                      onRate: (rating) => ref
                          .read(enrollmentNotifierProvider.notifier)
                          .rateCourse(widget.courseId, rating),
                    ),
                  ),
                ),

              // Description (collapsible)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(
                          () => _isDescriptionExpanded = !_isDescriptionExpanded,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'About this course',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: _isDescriptionExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: PhosphorIcon(
                                PhosphorIcons.caretDown(),
                                size: 22,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: _isDescriptionExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Text(
                          course.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: AppColors.textSecondary,
                              ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: Text(
                          course.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Enroll button (if not enrolled and authenticated)
              if (enrollment == null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    child: isAuthenticated
                        ? _EnrollButton(courseId: widget.courseId)
                        : const SizedBox.shrink(),
                  ),
                ),

              // Sections header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Sections',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (sectionsAsync.hasValue)
                        Text(
                          '${sectionsAsync.value!.length} sections',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),

              // Sections list
              sectionsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: ErrorDisplay(
                    error: error,
                    onRetry: () =>
                        ref.invalidate(courseSectionsProvider(widget.courseId)),
                  ),
                ),
                data: (sections) {
                  final sortedSections = List<Section>.from(sections)
                    ..sort((a, b) => a.order.compareTo(b.order));

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final section = sortedSections[index];
                        final sectionStatus = _getSectionStatus(
                          section: section,
                          enrollment: enrollment,
                          isAuthenticated: isAuthenticated,
                        );

                        return SectionTile(
                          section: section,
                          status: sectionStatus,
                          onTap: () => _onSectionTap(
                            context,
                            section,
                            sectionStatus,
                            isAuthenticated,
                          ),
                        );
                      },
                      childCount: sortedSections.length,
                    ),
                  );
                },
              ),

              // Ratings & Reviews header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Ratings & Reviews',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (course.ratingCount > 0)
                        Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.star(PhosphorIconsStyle.fill),
                              size: 18,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.averageRating.toStringAsFixed(1)} (${course.ratingCount})',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Write/Edit review button (enrolled users only)
              if (enrollment != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: userReviewAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (existingReview) => SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showReviewDialog(
                            context,
                            courseId: widget.courseId,
                            existingReview: existingReview,
                            enrollment: enrollment,
                          ),
                          icon: PhosphorIcon(
                            existingReview != null
                                ? PhosphorIcons.pencilSimple()
                                : PhosphorIcons.chatText(),
                            size: 18,
                          ),
                          label: Text(
                            existingReview != null
                                ? 'Edit Your Review'
                                : 'Write a Review',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Reviews list
              reviewsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),
                error: (_, __) => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              PhosphorIcon(
                                PhosphorIcons.chatText(),
                                size: 40,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No reviews yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textHint),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _ReviewCard(review: reviews[index]),
                      childCount: reviews.length,
                    ),
                  );
                },
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  SectionStatus _getSectionStatus({
    required Section section,
    required dynamic enrollment,
    required bool isAuthenticated,
  }) {
    // Guest users: only section 1 is free preview, rest locked
    if (!isAuthenticated) {
      return section.order == 1 ? SectionStatus.preview : SectionStatus.locked;
    }

    // Authenticated but not enrolled: first section shows enroll prompt, rest locked
    if (enrollment == null) {
      return section.order == 1
          ? SectionStatus.enrollToUnlock
          : SectionStatus.locked;
    }

    final completedSections = enrollment.completedSections as List<int>;
    if (completedSections.contains(section.order)) return SectionStatus.completed;

    // First section is always unlocked for enrolled users
    if (section.order == 1) return SectionStatus.unlocked;
    if (completedSections.contains(section.order - 1)) return SectionStatus.unlocked;

    return SectionStatus.locked;
  }

  void _onSectionTap(
    BuildContext context,
    Section section,
    SectionStatus status,
    bool isAuthenticated,
  ) {
    if (!isAuthenticated && section.order != 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const AuthWall(),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SectionContentScreen(
          courseId: section.courseId,
          sectionId: section.id,
          sectionTitle: section.title,
        ),
      ),
    );
  }

  void _showReviewDialog(
    BuildContext context, {
    required String courseId,
    Review? existingReview,
    required dynamic enrollment,
  }) {
    final textController = TextEditingController(
      text: existingReview?.text ?? '',
    );
    int selectedRating = existingReview?.rating ?? enrollment.rating;
    if (selectedRating == 0) selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            20, 20, 20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                existingReview != null ? 'Edit Review' : 'Write a Review',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () =>
                        setSheetState(() => selectedRating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PhosphorIcon(
                        i < selectedRating
                            ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                            : PhosphorIcons.star(),
                        size: 32,
                        color: i < selectedRating
                            ? AppColors.warning
                            : AppColors.textHint,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  hintStyle: TextStyle(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final text = textController.text.trim();
                    if (text.isEmpty) return;
                    Navigator.pop(ctx);

                    final notifier =
                        ref.read(reviewNotifierProvider.notifier);
                    if (existingReview != null) {
                      notifier.updateReview(
                        courseId: courseId,
                        reviewId: existingReview.id,
                        text: text,
                        rating: selectedRating,
                      );
                    } else {
                      final user =
                          ref.read(authStateProvider).valueOrNull;
                      notifier.addReview(
                        courseId: courseId,
                        displayName:
                            user?.displayName ?? 'Anonymous',
                        rating: selectedRating,
                        text: text,
                      );
                    }

                    ref
                        .read(enrollmentNotifierProvider.notifier)
                        .rateCourse(courseId, selectedRating);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    existingReview != null
                        ? 'Update Review'
                        : 'Submit Review',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnrollButton extends ConsumerWidget {
  final String courseId;

  const _EnrollButton({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollNotifier = ref.watch(enrollmentNotifierProvider);
    final isLoading = enrollNotifier.isLoading;

    // Show error feedback when enrollment fails.
    ref.listen(enrollmentNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FirebaseErrorMapper.mapToUserMessage(next.error!),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () => ref.read(enrollmentNotifierProvider.notifier).enroll(courseId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(PhosphorIcons.graduationCap(), size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'Enroll in this Course',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int currentRating;
  final ValueChanged<int> onRate;

  const _RatingBar({required this.currentRating, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Rate this course',
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        ...List.generate(5, (index) {
          final starIndex = index + 1;
          final isFilled = starIndex <= currentRating;
          return GestureDetector(
            onTap: () => onRate(starIndex),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: PhosphorIcon(
                isFilled
                    ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                    : PhosphorIcons.star(),
                size: 24,
                color: isFilled ? AppColors.warning : AppColors.textHint,
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final initials = review.displayName.isNotEmpty
        ? review.displayName
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.displayName,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            return PhosphorIcon(
                              i < review.rating
                                  ? PhosphorIcons.star(
                                      PhosphorIconsStyle.fill)
                                  : PhosphorIcons.star(),
                              size: 13,
                              color: i < review.rating
                                  ? AppColors.warning
                                  : AppColors.textHint,
                            );
                          }),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(review.updatedAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
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
            const SizedBox(height: 10),
            Text(
              review.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
