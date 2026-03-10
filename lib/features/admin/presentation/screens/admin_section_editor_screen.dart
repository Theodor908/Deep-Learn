import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../courses/domain/entities/section.dart';
import '../providers/admin_provider.dart';

class AdminSectionEditorScreen extends ConsumerStatefulWidget {
  final String courseId;
  final int nextOrder;
  final Section? section; // null = create mode, non-null = edit mode

  const AdminSectionEditorScreen({
    super.key,
    required this.courseId,
    required this.nextOrder,
    this.section,
  });

  @override
  ConsumerState<AdminSectionEditorScreen> createState() =>
      _AdminSectionEditorScreenState();
}

class _AdminSectionEditorScreenState
    extends ConsumerState<AdminSectionEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _summaryController;
  late final TextEditingController _contentController;

  bool get _isEditing => widget.section != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.section?.title ?? '');
    _summaryController =
        TextEditingController(text: widget.section?.summary ?? '');
    _contentController =
        TextEditingController(text: widget.section?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(adminCourseNotifierProvider);
    final isLoading = notifier.isLoading;

    ref.listen(adminCourseNotifierProvider, (prev, next) {
      if (next.hasValue && prev?.isLoading == true) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Section updated' : 'Section added'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          _isEditing
              ? 'Edit Section ${widget.section!.order}'
              : 'Add Section ${widget.nextOrder}',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Title', _titleController, 'Section title'),
            const SizedBox(height: 20),
            _buildField('Summary', _summaryController,
                'Brief summary of this section',
                maxLines: 3),
            const SizedBox(height: 20),
            _buildField(
                'Content', _contentController, 'Full section content...',
                maxLines: 10),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.5),
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
                    : Text(
                        _isEditing ? 'Save Changes' : 'Add Section',
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
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _save() {
    final title = _titleController.text.trim();
    final summary = _summaryController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Title and content are required'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final notifier = ref.read(adminCourseNotifierProvider.notifier);
    if (_isEditing) {
      notifier.updateSection(
        courseId: widget.courseId,
        sectionId: widget.section!.id,
        title: title,
        summary: summary.isEmpty ? title : summary,
        content: content,
      );
    } else {
      notifier.addSection(
        courseId: widget.courseId,
        title: title,
        summary: summary.isEmpty ? title : summary,
        content: content,
        order: widget.nextOrder,
      );
    }
  }
}
