import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MilestoneEditorPage extends StatelessWidget {
  /// false = Add Milestone
  /// true = Edit Milestone
  final bool editMode;

  const MilestoneEditorPage({super.key, this.editMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 19),
          ),
        ),
        title: Text(editMode ? 'Edit Milestone' : 'Add Milestone'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: _SaveButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _MilestoneNameField(editMode: editMode),
            const SizedBox(height: AppSpacing.md),
            _DescriptionField(editMode: editMode),
            const SizedBox(height: AppSpacing.xl),
            const _TasksHeader(),
            const SizedBox(height: AppSpacing.md),
            if (editMode) const _FilledTaskList() else const _AddTaskButton(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SAVE BUTTON
// ============================================================================

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Save',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FORM FIELDS
// ============================================================================

class _MilestoneNameField extends StatelessWidget {
  final bool editMode;

  const _MilestoneNameField({required this.editMode});

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Milestone Name',
      counter: editMode ? '26/60' : '0/60',
      child: TextField(
        controller: TextEditingController(
          text: editMode ? 'Build Strong Study Routine' : '',
        ),
        maxLength: 60,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) {
              return null;
            },
        decoration: const InputDecoration(
          hintText: 'Set a Major Step for Your Goal',
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final bool editMode;

  const _DescriptionField({required this.editMode});

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Description (Optional)',
      counter: editMode ? '52/250' : '0/250',
      child: TextField(
        controller: TextEditingController(
          text: editMode
              ? 'Create a consistent study routine for each week.'
              : '',
        ),
        maxLength: 250,
        maxLines: 3,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) {
              return null;
            },
        decoration: const InputDecoration(
          hintText: 'Add Context',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _FieldSection extends StatelessWidget {
  final String label;
  final String counter;
  final Widget child;

  const _FieldSection({
    required this.label,
    required this.counter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(counter, style: AppTextStyles.micro),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

// ============================================================================
// TASK SECTION
// ============================================================================

class _TasksHeader extends StatelessWidget {
  const _TasksHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tasks', style: AppTextStyles.titleM),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Assign at least one task to this milestone',
                style: AppTextStyles.micro,
              ),
            ],
          ),
        ),
        const _AiAssistantBadge(),
      ],
    );
  }
}

class _AiAssistantBadge extends StatelessWidget {
  const _AiAssistantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 15, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'AI Assistant',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ADD MODE
// ============================================================================

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        // Static UI only.
        onPressed: () {},
        icon: const Icon(Icons.add_circle_outline, size: 19),
        label: const Text('Add Task'),
      ),
    );
  }
}

// ============================================================================
// EDIT MODE
// ============================================================================

class _FilledTaskList extends StatelessWidget {
  const _FilledTaskList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TaskField(number: 1, title: 'Create a weekly study schedule'),
        SizedBox(height: AppSpacing.sm),
        _TaskField(number: 2, title: 'Review lesson notes every evening'),
        SizedBox(height: AppSpacing.sm),
        _TaskField(number: 3, title: 'Study for one focused hour'),
        SizedBox(height: AppSpacing.sm),
        _TaskField(number: 4, title: 'Prepare tomorrow’s materials'),
        SizedBox(height: AppSpacing.sm),
        Align(alignment: Alignment.centerLeft, child: _AddTaskButton()),
      ],
    );
  }
}

class _TaskField extends StatelessWidget {
  final int number;
  final String title;

  const _TaskField({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            '$number.',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.delete_outline, size: 19, color: AppColors.error),
        ],
      ),
    );
  }
}
