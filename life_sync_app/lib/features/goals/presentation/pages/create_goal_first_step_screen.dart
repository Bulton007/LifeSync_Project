import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_sync_app/features/goals/presentation/widgets/milestone_editor_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';
import 'package:life_sync_app/features/goals/presentation/widgets/goal_creation_steps.dart';

class CreateGoalFirstStepScreen extends StatefulWidget {
  const CreateGoalFirstStepScreen({super.key});
  @override
  State<CreateGoalFirstStepScreen> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<CreateGoalFirstStepScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _target = TextEditingController();
  final _current = TextEditingController(text: '0.00');
  final _drafts = <MilestoneDraft>[];
  late final GoalController _controller;
  GoalModel? _editing;
  GoalModel? _created;
  late DateTime _deadline;
  int _step = 0;
  int _savedMilestones = 0;
  bool _saving = false;
  String? _error;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GoalController>();
    _deadline = _today.add(const Duration(days: 30));
    final argument = Get.arguments;
    if (argument is GoalModel) {
      _editing = argument;
      _title.text = argument.title;
      _description.text = argument.description ?? '';
      _target.text = argument.targetAmount.toApiString();
      _current.text = argument.currentAmount.toApiString();
      _deadline = argument.deadline;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _target.dispose();
    _current.dispose();
    super.dispose();
  }

  String? _money(String? value, {bool positive = false}) {
    try {
      final amount = MoneyAmount.parse(value ?? '');
      return (positive
              ? amount.minorUnits <= BigInt.zero
              : amount.minorUnits < BigInt.zero)
          ? (positive
                    ? 'Enter an amount above zero'
                    : 'Amount cannot be negative')
                .tr
          : null;
    } on FormatException {
      return 'Use at most two decimal places'.tr;
    }
  }

  Future<void> _pickDeadline() async {
    final first = DateTime(_today.year, _today.month, _today.day + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline.isBefore(first) ? first : _deadline,
      firstDate: first,
      lastDate: DateTime(2200),
    );
    if (picked != null && mounted) setState(() => _deadline = picked);
  }

  Future<void> _editMilestone([int? index]) async {
    final original = index == null ? null : _drafts[index];
    final draft = await showModalBottomSheet<MilestoneDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => MilestoneEditorSheet(
        original: original,
        firstDate: _today,
        lastDate: _deadline,
      ),
    );
    if (draft != null && mounted) {
      setState(() {
        if (index == null) {
          _drafts.add(draft);
        } else {
          _drafts[index] = draft;
        }
      });
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_deadline.isAfter(_today)) {
      setState(() {
        _step = 0;
        _error = 'Deadline must be in the future';
      });
      return;
    }
    if (_editing != null && !(_form.currentState?.validate() ?? false)) return;
    if (_drafts.any(
      (draft) => draft.date.isBefore(_today) || draft.date.isAfter(_deadline),
    )) {
      setState(() {
        _step = 1;
        _error = 'Milestone dates must be within the goal dates.';
      });
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_editing != null) {
        final success = await _controller.updateGoal(
          goal: _editing!,
          title: _title.text,
          description: _description.text,
          targetAmount: MoneyAmount.parse(_target.text),
          currentAmount: MoneyAmount.parse(_current.text),
          deadline: _deadline,
        );
        if (!mounted) return;
        if (success) {
          Navigator.pop(context);
          return;
        }
        setState(
          () =>
              _error = _controller.errorMessage.value ?? 'Could not save goal.',
        );
        return;
      }
      if (_created == null) {
        final success = await _controller.createGoal(
          title: _title.text,
          description: _description.text,
          targetAmount: MoneyAmount.parse(_target.text),
          currentAmount: MoneyAmount.parse(_current.text),
          deadline: _deadline,
        );
        if (!success) {
          if (mounted) {
            setState(
              () => _error =
                  _controller.errorMessage.value ?? 'Could not save goal.',
            );
          }
          return;
        }
        _created = _controller.lastCreatedGoal;
      }
      if (_created == null) return;
      while (_savedMilestones < _drafts.length) {
        final draft = _drafts[_savedMilestones];
        final success = await _controller.createMilestone(
          _created!.id,
          draft.title,
          draft.date,
        );
        if (!success) {
          if (mounted) {
            setState(
              () => _error =
                  'Goal saved. Retry to save the remaining milestones.',
            );
          }
          return;
        }
        _savedMilestones++;
      }
      if (mounted) setState(() => _step = 3);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = _created == null
              ? 'Could not save goal.'
              : 'Goal saved. Retry to save the remaining milestones.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(
    TextEditingController input,
    String label,
    String key, {
    bool money = false,
    bool required = false,
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      key: ValueKey(key),
      controller: input,
      maxLines: maxLines,
      maxLength: money ? null : (maxLines > 1 ? 250 : 100),
      keyboardType: money
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: money
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      decoration: InputDecoration(
        labelText: label.tr,
        prefixText: money ? r'$ ' : null,
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) => money
          ? _money(value, positive: key == 'goal-target')
          : required && (value == null || value.trim().isEmpty)
          ? 'Goal title is required'.tr
          : null,
    ),
  );

  Widget _summary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.lifeSyncColors.inputSurface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag_rounded, color: context.lifeSyncColors.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _title.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.lifeSyncColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        if (_description.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _description.text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          'Target: @amount'.trParams({
            'amount': MoneyAmount.parse(_target.text).format(),
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Due @date'.trParams({
            'date': MaterialLocalizations.of(
              context,
            ).formatMediumDate(_deadline),
          }),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );

  Widget _milestones({bool review = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Milestones'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          if (!review)
            TextButton.icon(
              key: const ValueKey('add-draft-milestone'),
              onPressed: () => _editMilestone(),
              icon: const Icon(Icons.add),
              label: Text('Add Milestone'.tr),
            ),
        ],
      ),
      const SizedBox(height: 8),
      if (_drafts.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'Add checkpoints to your goal, or continue without milestones.'.tr,
          ),
        ),
      for (var index = 0; index < _drafts.length; index++)
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: context.lifeSyncColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: Container(
              width: 32,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: context.lifeSyncColors.primaryBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}'.padLeft(2, '0'),
                style: TextStyle(color: context.lifeSyncColors.primaryBlue),
              ),
            ),
            title: Text(
              _drafts[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            subtitle: Text(
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(_drafts[index].date),
              style: const TextStyle(fontSize: 11),
            ),
            trailing: review
                ? const Icon(Icons.flag_outlined, size: 18)
                : PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editMilestone(index);
                      } else {
                        setState(() => _drafts.removeAt(index));
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text('Edit'.tr)),
                      PopupMenuItem(value: 'delete', child: Text('Delete'.tr)),
                    ],
                  ),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final editing = _editing != null;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        backgroundColor: colors.cardSurface,
        appBar: _step == 3
            ? null
            : AppBar(
                backgroundColor: colors.cardSurface,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  onPressed: _saving ? null : () => Navigator.maybePop(context),
                  icon: const Icon(Icons.chevron_left),
                ),
                title: Text(
                  (editing ? 'Edit Goal' : 'Create Goal').tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    if (!editing && _step < 3) ...[
                      GoalCreationSteps(currentStep: _step),
                      const SizedBox(height: 30),
                    ],
                    if (_step == 0)
                      Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _field(
                              _title,
                              'Goal',
                              'goal-title',
                              required: true,
                            ),
                            _field(
                              _description,
                              'What Success Will Look Like?',
                              'goal-description',
                              maxLines: 3,
                            ),
                            _field(
                              _target,
                              'Target amount',
                              'goal-target',
                              money: true,
                            ),
                            _field(
                              _current,
                              'Current amount',
                              'goal-current',
                              money: true,
                            ),
                            ListTile(
                              key: const ValueKey('goal-deadline'),
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                              title: Text('Deadline'.tr),
                              subtitle: Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(_deadline),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: _pickDeadline,
                            ),
                          ],
                        ),
                      ),
                    if (_step == 1) _milestones(),
                    if (_step == 2) ...[
                      _summary(),
                      const SizedBox(height: 22),
                      _milestones(review: true),
                    ],
                    if (_step == 3) ...[
                      const SizedBox(height: 36),
                      SvgPicture.asset(
                        LifeSyncSvgAssets.createdGoalSuccess,
                        height: 220,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'The journey starts now!'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.primaryBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your goal is set — every step brings you closer.'.tr,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      _summary(),
                      const SizedBox(height: 14),
                      Text(
                        '@done/@total milestones'.trParams({
                          'done': '$_savedMilestones',
                          'total': '${_drafts.length}',
                        }),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _error!.tr,
                          style: TextStyle(color: colors.negative),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Row(
                  children: [
                    if (_step > 0 && _step < 3 && _created == null) ...[
                      OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => setState(() {
                                _step--;
                                _error = null;
                              }),
                        child: Text('Back & Edit'.tr),
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (_step == 3) ...[
                      OutlinedButton(
                        onPressed: () => Get.offNamed<void>(
                          AppRoutes.goalDetails,
                          arguments: _created,
                        ),
                        child: Text('View Goal'.tr),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: FilledButton(
                        key: const ValueKey('goal-next'),
                        onPressed: _saving
                            ? null
                            : () {
                                if (_step == 3) {
                                  Navigator.pop(context);
                                } else if (editing || _step == 2) {
                                  _save();
                                } else if (_step == 1 ||
                                    (_form.currentState?.validate() ?? false)) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _step++;
                                    _error = null;
                                  });
                                }
                              },
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                (editing
                                        ? 'Update Goal'
                                        : _step == 0
                                        ? 'Next: Plan Goal'
                                        : _step == 1
                                        ? 'Next: Review Goal'
                                        : _step == 2
                                        ? (_created == null
                                              ? 'Create Goal'
                                              : 'Try again')
                                        : 'Done')
                                    .tr,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
