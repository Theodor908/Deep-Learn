import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../features/courses/domain/entities/category.dart';

class CategoryChipBar extends StatelessWidget {
  final List<Category> categories;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedIds.contains(category.id);
          return FilterChip(
            label: Text(category.name),
            selected: isSelected,
            onSelected: (_) => onToggle(category.id),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.primary,
              letterSpacing: 0.1,
            ),
            backgroundColor: AppColors.primarySurface,
            selectedColor: AppColors.primary,
            checkmarkColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.primary.withAlpha(60),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
