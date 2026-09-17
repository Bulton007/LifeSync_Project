import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';
import 'package:life_sync_app/features/personal_progress/presentation/controllers/personal_progress_controller.dart';

final class PersonalProgressScreen extends StatelessWidget {
  const PersonalProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PersonalProgressController>();
    return Scaffold(
      backgroundColor: context.lifeSyncColors.pageBackground,
      appBar: AppBar(title: const Text('Personal Progress')),
      body: Obx(() {
        final state = controller.state.value;
        if (state.status == ViewStatus.initial ||
            state.status == ViewStatus.loading) {
          return const AppLoadingView(message: 'Loading your progress…');
        }
        if (state.status == ViewStatus.error && state.data == null) {
          return AppErrorView(
            message:
                state.exception?.message ?? 'Progress could not be loaded.',
            onRetry: controller.load,
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.load(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
            children: [
              if (state.status == ViewStatus.error && state.exception != null)
                _InlineError(message: state.exception!.message),
              _RewardCard(controller: controller),
              const SizedBox(height: 18),
              _SummaryRow(data: controller.data),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Morning check-ins',
                actionLabel: 'Check in',
                onPressed: () => _checkingDialog(context, controller),
              ),
              if (controller.data.checkings.isEmpty)
                const _EmptyCard(
                  message: 'No check-ins yet. Record how this morning feels.',
                )
              else
                ...controller.data.checkings.map(
                  (item) =>
                      _CheckingTile(checking: item, controller: controller),
                ),
              const SizedBox(height: 22),
              _SectionHeader(
                title: 'Weekly reviews',
                actionLabel: 'Add review',
                onPressed: () => _reviewDialog(context, controller),
              ),
              if (controller.data.reviews.isEmpty)
                const _EmptyCard(
                  message: 'No reviews yet. Reflect on a completed week.',
                )
              else
                ...controller.data.reviews.map(
                  (item) => _ReviewTile(review: item, controller: controller),
                ),
              const SizedBox(height: 22),
              _SectionHeader(
                title: 'Wins',
                actionLabel: 'Record win',
                onPressed: () => _winDialog(context, controller),
              ),
              if (controller.data.wins.isEmpty)
                const _EmptyCard(
                  message: 'No wins recorded yet. Small wins count too.',
                )
              else
                ...controller.data.wins.map(
                  (item) => _WinTile(win: item, controller: controller),
                ),
            ],
          ),
        );
      }),
    );
  }
}

final class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.controller});

  final PersonalProgressController controller;

  @override
  Widget build(BuildContext context) {
    final reward = controller.data.reward;
    final points = reward?.points ?? 0;
    final level = reward?.level ?? 1;
    final progress = reward?.levelProgress ?? 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF00ACC1)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.auto_awesome_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$points progress points',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (reward != null || points > 0)
                IconButton(
                  tooltip: 'Reset reward progress',
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => _resetReward(context, controller),
                  icon: const Icon(Icons.restart_alt_rounded),
                  color: Colors.white,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${reward?.pointsIntoLevel ?? 0} / 100 points toward level ${level + 1}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => _pointsDialog(
                          context,
                          controller,
                          subtract: false,
                          currentPoints: points,
                        ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add points'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: points <= 0 || controller.isSubmitting.value
                      ? null
                      : () => _pointsDialog(
                          context,
                          controller,
                          subtract: true,
                          currentPoints: points,
                        ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white38,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  icon: const Icon(Icons.remove_rounded),
                  label: const Text('Remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.data});

  final PersonalProgressData data;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _MetricCard(
          icon: Icons.wb_sunny_outlined,
          value: data.averageMood?.toStringAsFixed(1) ?? '—',
          label: 'Avg. mood',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _MetricCard(
          icon: Icons.emoji_events_outlined,
          value: data.wins.length.toString(),
          label: 'Wins',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _MetricCard(
          icon: Icons.history_edu_outlined,
          value: data.reviews.length.toString(),
          label: 'Reviews',
        ),
      ),
    ],
  );
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colors.primaryText,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
            ),
          ),
        ),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}

final class _CheckingTile extends StatelessWidget {
  const _CheckingTile({required this.checking, required this.controller});

  final MorningCheckingModel checking;
  final PersonalProgressController controller;

  @override
  Widget build(BuildContext context) => _HistoryCard(
    leading: Text(
      '${checking.moodRating}/10',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    ),
    title: checking.notes?.isNotEmpty == true
        ? checking.notes!
        : 'Morning check-in',
    subtitle: _dateTime(checking.checkedInAt),
    onEdit: () => _checkingDialog(context, controller, existing: checking),
    onDelete: () => _delete(
      context,
      'Delete this check-in?',
      () => controller.deleteChecking(checking),
      controller,
    ),
  );
}

final class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.controller});

  final WeeklyReviewModel review;
  final PersonalProgressController controller;

  @override
  Widget build(BuildContext context) => _HistoryCard(
    leading: const Icon(Icons.history_edu_outlined, color: Color(0xFF7E57C2)),
    title: review.reviewSummary,
    subtitle: '${_date(review.startDate)} – ${_date(review.endDate)}',
    onEdit: () => _reviewDialog(context, controller, existing: review),
    onDelete: () => _delete(
      context,
      'Delete this weekly review?',
      () => controller.deleteReview(review),
      controller,
    ),
  );
}

final class _WinTile extends StatelessWidget {
  const _WinTile({required this.win, required this.controller});

  final WinModel win;
  final PersonalProgressController controller;

  @override
  Widget build(BuildContext context) => _HistoryCard(
    leading: const Icon(Icons.emoji_events_outlined, color: Color(0xFFFFA000)),
    title: win.title,
    subtitle: [
      if (win.description?.isNotEmpty == true) win.description!,
      _dateTime(win.createdAt),
    ].join(' • '),
    onEdit: () => _winDialog(context, controller, existing: win),
    onDelete: () => _delete(
      context,
      'Delete this win?',
      () => controller.deleteWin(win),
      controller,
    ),
  );
}

final class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Card(
      color: colors.cardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SizedBox(width: 42, child: Center(child: leading)),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: colors.secondaryText)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else {
              onDelete();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}

final class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colors.secondaryText, fontSize: 12),
      ),
    );
  }
}

final class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(message, style: TextStyle(color: Colors.red.shade800)),
  );
}

final class _CheckingDialog extends StatefulWidget {
  const _CheckingDialog({this.existing});

  final MorningCheckingModel? existing;

  @override
  State<_CheckingDialog> createState() => _CheckingDialogState();
}

final class _CheckingDialogState extends State<_CheckingDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late int _mood;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.existing?.notes ?? '',
    );
    _mood = (widget.existing?.moodRating ?? 5).clamp(1, 10);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Morning check-in' : 'Edit check-in',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _mood,
              decoration: const InputDecoration(labelText: 'Mood (1–10)'),
              items: [
                for (var value = 1; value <= 10; value++)
                  DropdownMenuItem(value: value, child: Text('$value / 10')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _mood = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLength: 2000,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, (
                mood: _mood,
                notes: _notesController.text.trim(),
              ));
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Future<void> _checkingDialog(
  BuildContext context,
  PersonalProgressController controller, {
  MorningCheckingModel? existing,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<({int mood, String notes})>(
    context: context,
    builder: (_) => _CheckingDialog(existing: existing),
  );
  if (result == null) return;
  final saved = existing == null
      ? await controller.createChecking(
          moodRating: result.mood,
          notes: result.notes.isEmpty ? null : result.notes,
        )
      : await controller.updateChecking(
          existing,
          moodRating: result.mood,
          notes: result.notes.isEmpty ? null : result.notes,
        );
  _showResult(messenger, controller, saved);
}

final class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog({this.existing});

  final WeeklyReviewModel? existing;

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

final class _ReviewDialogState extends State<_ReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _summaryController;
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _summaryController = TextEditingController(
      text: widget.existing?.reviewSummary ?? '',
    );
    _start =
        widget.existing?.startDate ?? now.subtract(const Duration(days: 6));
    _end = widget.existing?.endDate ?? now;
    if (_end.isBefore(_start)) {
      _end = _start;
    }
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Weekly review' : 'Edit review'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _summaryController,
                maxLength: 5000,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Review summary',
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Review summary is required.'
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start date'),
                subtitle: Text(_date(_start)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _start,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                  );
                  if (picked != null && mounted) {
                    setState(() {
                      _start = picked;
                      if (_end.isBefore(_start)) {
                        _end = _start;
                      }
                    });
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('End date'),
                subtitle: Text(_date(_end)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final effectiveInitial = _end.isBefore(_start)
                      ? _start
                      : _end;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: effectiveInitial,
                    firstDate: _start,
                    lastDate: DateTime(2200),
                  );
                  if (picked != null && mounted) {
                    setState(() => _end = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            if (_end.isBefore(_start)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('End date cannot be before start date.'),
                ),
              );
              return;
            }
            Navigator.pop(context, (
              summary: _summaryController.text.trim(),
              start: _start,
              end: _end,
            ));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Future<void> _reviewDialog(
  BuildContext context,
  PersonalProgressController controller, {
  WeeklyReviewModel? existing,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result =
      await showDialog<({String summary, DateTime start, DateTime end})>(
        context: context,
        builder: (_) => _ReviewDialog(existing: existing),
      );
  if (result == null) return;
  final startDate = DateTime(
    result.start.year,
    result.start.month,
    result.start.day,
  );
  final endDate = DateTime(
    result.end.year,
    result.end.month,
    result.end.day,
    23,
    59,
    59,
  );
  final saved = existing == null
      ? await controller.createReview(
          summary: result.summary,
          startDate: startDate,
          endDate: endDate,
        )
      : await controller.updateReview(
          existing,
          summary: result.summary,
          startDate: startDate,
          endDate: endDate,
        );
  _showResult(messenger, controller, saved);
}

final class _WinDialog extends StatefulWidget {
  const _WinDialog({this.existing});

  final WinModel? existing;

  @override
  State<_WinDialog> createState() => _WinDialogState();
}

final class _WinDialogState extends State<_WinDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existing?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existing?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Record a win' : 'Edit win'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 200,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Title is required.'
                  : null,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLength: 1000,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, (
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              ));
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Future<void> _winDialog(
  BuildContext context,
  PersonalProgressController controller, {
  WinModel? existing,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<({String title, String description})>(
    context: context,
    builder: (_) => _WinDialog(existing: existing),
  );
  if (result == null) return;
  final saved = existing == null
      ? await controller.createWin(
          title: result.title,
          description: result.description.isEmpty ? null : result.description,
        )
      : await controller.updateWin(
          existing,
          title: result.title,
          description: result.description.isEmpty ? null : result.description,
        );
  _showResult(messenger, controller, saved);
}

final class _PointsDialog extends StatefulWidget {
  const _PointsDialog({required this.subtract, this.currentPoints = 0});

  final bool subtract;
  final int currentPoints;

  @override
  State<_PointsDialog> createState() => _PointsDialogState();
}

final class _PointsDialogState extends State<_PointsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _pointsController = TextEditingController();
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subtract ? 'Remove points' : 'Add progress points'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _pointsController,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Points',
            helperText: widget.subtract
                ? 'Current balance: ${widget.currentPoints} points'
                : 'Adds to your total progress points',
          ),
          validator: (value) {
            final parsed = int.tryParse(value?.trim() ?? '');
            if (parsed == null || parsed <= 0) {
              return 'Enter a positive number.';
            }
            if (widget.subtract && parsed > widget.currentPoints) {
              return 'Cannot remove more than current ${widget.currentPoints} points.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, int.parse(_pointsController.text.trim()));
            }
          },
          child: Text(widget.subtract ? 'Remove' : 'Add'),
        ),
      ],
    );
  }
}

Future<void> _pointsDialog(
  BuildContext context,
  PersonalProgressController controller, {
  required bool subtract,
  int currentPoints = 0,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<int>(
    context: context,
    builder: (_) =>
        _PointsDialog(subtract: subtract, currentPoints: currentPoints),
  );
  if (result == null) return;
  final saved = subtract
      ? await controller.subtractPoints(result)
      : await controller.addPoints(result);
  _showResult(messenger, controller, saved);
}

Future<void> _resetReward(
  BuildContext context,
  PersonalProgressController controller,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Reset reward progress?'),
      content: const Text('This removes the current points and level record.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final saved = await controller.resetReward();
  _showResult(messenger, controller, saved);
}

Future<void> _delete(
  BuildContext context,
  String title,
  Future<bool> Function() operation,
  PersonalProgressController controller,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final saved = await operation();
  _showResult(messenger, controller, saved);
}

void _showResult(
  ScaffoldMessengerState messenger,
  PersonalProgressController controller,
  bool success,
) {
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        success
            ? 'Progress updated successfully.'
            : controller.errorMessage.value ?? 'Progress could not be updated.',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: success
          ? const Color(0xFF10B981)
          : const Color(0xFFEF4444),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ),
  );
}

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}/${value.year}';

String _dateTime(DateTime value) =>
    '${_date(value)} '
    '${value.hour.toString().padLeft(2, '0')}:'
    '${value.minute.toString().padLeft(2, '0')}';
