import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/category_chip_bar.dart';
import '../../../courses/presentation/providers/category_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/search_results_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: PhosphorIcon(
                            PhosphorIcons.magnifyingGlass(
                                PhosphorIconsStyle.fill),
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Deep Learn',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Search field
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _hasFocus
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(20),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) => notifier.updateQuery(value),
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search courses, topics...',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textHint,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 10),
                          child: PhosphorIcon(
                            PhosphorIcons.magnifyingGlass(),
                            size: 20,
                            color: _hasFocus
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 0,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  notifier.updateQuery('');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: PhosphorIcon(
                                    PhosphorIcons.xCircle(
                                        PhosphorIconsStyle.fill),
                                    size: 20,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              )
                            : null,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 0,
                        ),
                        filled: true,
                        fillColor:
                            _hasFocus ? AppColors.surface : AppColors.divider,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: AppColors.border.withAlpha(100),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Category chips
            categoriesAsync.when(
              loading: () => const SizedBox(height: 44),
              error: (_, _) => const SizedBox.shrink(),
              data: (categories) {
                final selectedIds = notifier.selectedCategoryIds;
                return CategoryChipBar(
                  categories: categories,
                  selectedIds: selectedIds,
                  onToggle: (id) {
                    notifier.toggleCategory(id);
                    setState(() {});
                  },
                );
              },
            ),
            const SizedBox(height: 6),

            // Subtle divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: AppColors.divider),
            ),

            // Results
            const Expanded(child: SearchResultsList()),
          ],
        ),
      ),
    );
  }
}
