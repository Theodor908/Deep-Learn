import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../courses/domain/entities/section.dart';
import '../providers/search_provider.dart';

class SearchResultsList extends ConsumerStatefulWidget {
  const SearchResultsList({super.key});

  @override
  ConsumerState<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends ConsumerState<SearchResultsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      ref.read(searchNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);
    final query = notifier.currentQuery;
    final sectionResults = query.isNotEmpty
        ? ref.watch(sectionSearchResultsProvider)
        : const AsyncValue<List<Section>>.data([]);

    return searchState.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      ),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: () => ref.invalidate(searchNotifierProvider),
      ),
      data: (courses) {
        final sections = sectionResults.valueOrNull ?? [];
        final hasSections = sections.isNotEmpty && query.isNotEmpty;

        if (courses.isEmpty && !hasSections) {
          return const _EmptyState();
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Course results
            if (courses.isNotEmpty) ...[
              if (hasSections)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Courses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ...List.generate(courses.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 14),
                  child: CourseCard(course: courses[index]),
                );
              }),
              if (notifier.hasMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ],

            // Section results
            if (hasSections) ...[
              const SizedBox(height: 20),
              Text(
                'Sections',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              ...sections.map((section) => _SectionResultTile(section: section)),
            ],
          ],
        );
      },
    );
  }
}

class _SectionResultTile extends StatelessWidget {
  final Section section;

  const _SectionResultTile({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go('/course/${section.courseId}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIcons.bookOpenText(),
                      size: 18,
                      color: AppColors.primary,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Section ${section.order}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                PhosphorIcon(
                  PhosphorIcons.caretRight(),
                  size: 18,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primarySurface,
                    AppColors.secondary.withAlpha(30),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.magnifyingGlass(),
                    size: 44,
                    color: AppColors.primary.withAlpha(100),
                  ),
                  Positioned(
                    right: 24,
                    bottom: 28,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: PhosphorIcon(
                        PhosphorIcons.question(),
                        size: 16,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No results found',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term or\nadjust your category filters',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textHint,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIcons.warningCircle(),
              size: 48,
              color: AppColors.error.withAlpha(160),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: AppColors.textHint),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onRetry,
              icon: PhosphorIcon(PhosphorIcons.arrowClockwise(), size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
