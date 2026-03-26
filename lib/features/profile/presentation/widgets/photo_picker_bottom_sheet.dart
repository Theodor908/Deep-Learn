import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';

enum PhotoPickerOption { camera, gallery, remove, editName }

class PhotoPickerBottomSheet extends StatelessWidget {
  final bool hasExistingPhoto;

  const PhotoPickerBottomSheet({super.key, required this.hasExistingPhoto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Change Profile Photo',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _OptionTile(
                icon: PhosphorIcons.camera(),
                label: 'Take Photo',
                onTap: () => Navigator.pop(context, PhotoPickerOption.camera),
              ),
              _OptionTile(
                icon: PhosphorIcons.image(),
                label: 'Choose from Gallery',
                onTap: () => Navigator.pop(context, PhotoPickerOption.gallery),
              ),
              if (hasExistingPhoto)
                _OptionTile(
                  icon: PhosphorIcons.trash(),
                  label: 'Remove Photo',
                  color: AppColors.error,
                  onTap: () => Navigator.pop(context, PhotoPickerOption.remove),
                ),
              const Divider(height: 1),
              _OptionTile(
                icon: PhosphorIcons.pencilSimple(),
                label: 'Edit Display Name',
                onTap: () => Navigator.pop(context, PhotoPickerOption.editName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: PhosphorIcon(icon, color: tileColor, size: 24),
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: tileColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
