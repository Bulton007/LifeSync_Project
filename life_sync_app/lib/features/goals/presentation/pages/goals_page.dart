import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'.tr),
        actions: [
          IconButton(
            onPressed: () => _openCreateGoal(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _GoalOverview(),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Goals Progress'.tr, style: AppTextStyles.titleM),
              TextButton.icon(
                onPressed: () => _openCreateGoal(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text('New goal'.tr),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _GoalCard(
            title: 'Be an Outstanding Student',
            outcome: 'Get 4.0 GPA on this Semester',
            progress: 0.38,
            milestoneText: '1/4 Milestones',
            daysLeft: '82 days left',
            status: 'Active',
            color: AppColors.primary,
            icon: Icons.school_outlined,
            onTap: () => _openDetails(context),
          ),
          const SizedBox(height: AppSpacing.md),
          _GoalCard(
            title: 'Build Emergency Savings',
            outcome: 'Save \$5,000 for emergencies',
            progress: 1,
            milestoneText: '4/4 Milestones',
            daysLeft: 'Completed',
            status: 'Completed',
            color: AppColors.success,
            icon: Icons.savings_outlined,
            onTap: () => _openDetails(context),
          ),
          const SizedBox(height: AppSpacing.md),
          _GoalCard(
            title: 'Improve Physical Health',
            outcome: 'Exercise at least four times a week',
            progress: 0.25,
            milestoneText: '1/4 Milestones',
            daysLeft: 'No due date',
            status: 'Inactive',
            color: AppColors.disabledBackground,
            icon: Icons.fitness_center_outlined,
            onTap: () => _openDetails(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateGoal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openCreateGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateGoalPage()),
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GoalDetailsPage()),
    );
  }
}

// ============================================================================
// GOAL TRACKER
// ============================================================================

class _GoalOverview extends StatelessWidget {
  const _GoalOverview();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview'.tr, style: AppTextStyles.button),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                SizedBox(
                  width: 92,
                  height: 92,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: 0.63,
                          strokeWidth: 7,
                          backgroundColor: AppColors.accent,
                          color: AppColors.primary,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('63%', style: AppTextStyles.titleM),
                          Text('Overall'.tr, style: AppTextStyles.micro),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    children: [
                      _OverviewRow(
                        label: 'Active Goals'.tr,
                        value: '5',
                        color: AppColors.info,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _OverviewRow(
                        label: 'Completed'.tr,
                        value: '3',
                        color: AppColors.success,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _OverviewRow(
                        label: 'Inactive Goals'.tr,
                        value: '1',
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 16,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+8.2% this week',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OverviewRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.caption)),
          Text(value, style: AppTextStyles.button.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final String outcome;
  final double progress;
  final String milestoneText;
  final String daysLeft;
  final String status;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.outcome,
    required this.progress,
    required this.milestoneText,
    required this.daysLeft,
    required this.status,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(title, style: AppTextStyles.button)),
                  const Icon(Icons.more_horiz),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Outcome: $outcome', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current Progress'.tr, style: AppTextStyles.micro),
                  _StatusBadge(text: status, color: color),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  color: color,
                  backgroundColor: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(child: Text(daysLeft, style: AppTextStyles.micro)),
                  Text(milestoneText, style: AppTextStyles.micro),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'View Detail'.tr,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// GOAL DETAILS
// ============================================================================

class GoalDetailsPage extends StatelessWidget {
  const GoalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final milestones = [
      ('Build Strong Study Routine', '4/4 tasks completed', true),
      ('Improve Academic Performance', '2/4 tasks completed', false),
      ('Prepare for Mid-Term', '0/4 tasks completed', false),
      ('Prepare for Final', '0/4 tasks completed', false),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Goal Details'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            color: AppColors.primary50,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Be an Outstanding Student',
                              style: AppTextStyles.titleM.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Outcome: Get 4.0 GPA on this Semester',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 15),
                      SizedBox(width: AppSpacing.xs),
                      Text('Started on 1 June 2026'),
                      Spacer(),
                      Icon(Icons.event_outlined, size: 15),
                      SizedBox(width: AppSpacing.xs),
                      Text('Due 10 Oct 2026'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Goal Progress'.tr, style: AppTextStyles.button),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '38%',
                    style: AppTextStyles.titleL.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const LinearProgressIndicator(
                    value: 0.38,
                    minHeight: 7,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary100,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _GoalMetric(
                          label: 'Milestones'.tr,
                          value: '1/4',
                        ),
                      ),
                      Expanded(
                        child: _GoalMetric(label: 'Tasks'.tr, value: '8/24'),
                      ),
                      Expanded(
                        child: _GoalMetric(
                          label: 'Health'.tr,
                          value: 'On Track',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('Milestones'.tr, style: AppTextStyles.titleM),
              ),
              TextButton.icon(
                onPressed: () => showMilestoneEditor(context),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text('Edit Milestone'.tr),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: List.generate(
                  milestones.length,
                  (index) => _MilestoneRow(
                    number: index + 1,
                    title: milestones[index].$1,
                    subtitle: milestones[index].$2,
                    completed: milestones[index].$3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalMetric extends StatelessWidget {
  final String label;
  final String value;

  const _GoalMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: AppTextStyles.button),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.micro,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============================================================================
// CREATE GOAL
// ============================================================================

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  int currentStep = 0;

  final goalController = TextEditingController(
    text: 'Be an Outstanding Student',
  );

  final outcomeController = TextEditingController(
    text: 'Get 4.0 GPA on this Semester',
  );

  final List<String> milestones = [
    'Build Strong Study Routine',
    'Improve Academic Performance',
    'Prepare for Mid-Term',
    'Prepare for Final',
  ];

  @override
  void dispose() {
    goalController.dispose();
    outcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Goal'.tr)),
      body: SafeArea(
        child: Column(
          children: [
            _GoalStepIndicator(currentStep: currentStep),
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: [
                  _buildDefineStep(),
                  _buildPlanStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefineStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Define your goal'.tr, style: AppTextStyles.titleL),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Start with a clear goal and desired outcome.'.tr,
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.xl),
        TextFormField(
          controller: goalController,
          style: TextStyle(color: context.lifeSyncColors.primaryText),
          decoration: InputDecoration(
            labelText: 'Goal'.tr,
            prefixIcon: const Icon(Icons.flag_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: outcomeController,
          style: TextStyle(color: context.lifeSyncColors.primaryText),
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'What does success look like?'.tr,
            hintText: 'Enter your expected outcome'.tr,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                initialValue: '08 Aug 2026',
                decoration: InputDecoration(
                  labelText: 'Start Date'.tr,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                readOnly: true,
                initialValue: '10 Oct 2026',
                decoration: InputDecoration(
                  labelText: 'Due Date'.tr,
                  prefixIcon: const Icon(Icons.event_outlined),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Milestones'.tr, style: AppTextStyles.titleM),
                  Text(
                    'Set milestones for goal progression'.tr,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            _AiAssistantButton(onPressed: () {}),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (milestones.isEmpty)
          _EmptyMilestones(onCreate: () => _addMilestone())
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  for (int i = 0; i < milestones.length; i++)
                    _EditableMilestoneRow(
                      number: i + 1,
                      title: milestones[i],
                      onEdit: () => _editMilestone(i),
                      onDelete: () {
                        setState(() => milestones.removeAt(i));
                      },
                    ),
                  TextButton.icon(
                    onPressed: _addMilestone,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text('Add Milestone'.tr),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Card(
          color: AppColors.primary50,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalController.text,
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Outcome: ${outcomeController.text}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Milestones'.tr, style: AppTextStyles.titleM),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: List.generate(
                milestones.length,
                (index) => _MilestoneRow(
                  number: index + 1,
                  title: milestones[index],
                  subtitle: '4 tasks',
                  completed: false,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.lifeSyncColors.cardSurface,
        border: Border(top: BorderSide(color: context.lifeSyncColors.border)),
      ),
      child: Row(
        children: [
          if (currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => currentStep--),
                child: Text('Back & Edit'.tr),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (currentStep < 2) {
                  setState(() => currentStep++);
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GoalSuccessPage(
                      goalTitle: goalController.text,
                      milestoneCount: milestones.length,
                    ),
                  ),
                );
              },
              child: Text(
                currentStep == 0
                    ? 'Next: Build Your Plan'
                    : currentStep == 1
                    ? 'Next: Review Goal'
                    : 'Create Goal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMilestone() async {
    final result = await showMilestoneEditor(context);

    if (result != null && result.trim().isNotEmpty) {
      setState(() => milestones.add(result.trim()));
    }
  }

  Future<void> _editMilestone(int index) async {
    final result = await showMilestoneEditor(
      context,
      initialName: milestones[index],
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() => milestones[index] = result.trim());
    }
  }
}

class _GoalStepIndicator extends StatelessWidget {
  final int currentStep;

  const _GoalStepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const labels = ['Define', 'Plan', 'Review'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: List.generate(3, (index) {
          final active = index <= currentStep;

          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: active
                          ? AppColors.primary
                          : AppColors.disabled,
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: active
                              ? AppColors.textOnPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      labels[index],
                      style: AppTextStyles.micro.copyWith(
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        bottom: 16,
                      ),
                      color: index < currentStep
                          ? AppColors.primary
                          : AppColors.disabled,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// MILESTONE EDITOR
// ============================================================================

Future<String?> showMilestoneEditor(
  BuildContext context, {
  String? initialName,
}) {
  return Navigator.push<String>(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => MilestoneEditorPage(initialName: initialName),
    ),
  );
}

class MilestoneEditorPage extends StatefulWidget {
  final String? initialName;

  const MilestoneEditorPage({super.key, this.initialName});

  @override
  State<MilestoneEditorPage> createState() => _MilestoneEditorPageState();
}

class _MilestoneEditorPageState extends State<MilestoneEditorPage> {
  late final TextEditingController nameController;
  final descriptionController = TextEditingController();

  final List<String> tasks = [
    'Review lesson notes',
    'Complete practice exercise',
    'Study for one focused hour',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initialName != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: Text(editing ? 'Edit Milestone' : 'Add Milestone'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(
              context,
              nameController.text.isEmpty
                  ? 'New Milestone'
                  : nameController.text,
            ),
            icon: const Icon(Icons.check, size: 17),
            label: Text('Save'.tr),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            controller: nameController,
            maxLength: 60,
            decoration: InputDecoration(
              labelText: 'Milestone Name'.tr,
              hintText: 'Set a major step for your goal'.tr,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: descriptionController,
            maxLength: 250,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description (Optional)'.tr,
              hintText: 'Add context'.tr,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tasks'.tr, style: AppTextStyles.titleM),
                    Text(
                      'Assign at least one task'.tr,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              _AiAssistantButton(onPressed: () {}),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            tasks.length,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: TextFormField(
                initialValue: tasks[index],
                decoration: InputDecoration(
                  prefixText: '${index + 1}.  ',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => tasks.removeAt(index));
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() => tasks.add(''));
              },
              icon: const Icon(Icons.add_circle_outline),
              label: Text('Add Task'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUCCESS PAGE
// ============================================================================

class GoalSuccessPage extends StatelessWidget {
  final String goalTitle;
  final int milestoneCount;

  const GoalSuccessPage({
    super.key,
    required this.goalTitle,
    required this.milestoneCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_circle_outlined,
                  size: 110,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'The journey starts now!'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleXL.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '“$goalTitle” is ready. Every step from here brings '
                'you closer to the finish line.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyPrimary,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  Expanded(
                    child: _SuccessMetric(
                      icon: Icons.flag_outlined,
                      label: 'Milestones'.tr,
                      value: '$milestoneCount',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _SuccessMetric(
                      icon: Icons.task_alt_outlined,
                      label: 'Tasks'.tr,
                      value: '24',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _SuccessMetric(
                      icon: Icons.calendar_today_outlined,
                      label: 'Due Date'.tr,
                      value: '10 Oct',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => GoalDetailsPage()),
                        );
                      },
                      child: Text('View Goal'.tr),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => GoalsPage()),
                          (route) => route.isFirst,
                        );
                      },
                      child: Text('Done'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SHARED GOAL WIDGETS
// ============================================================================

class _MilestoneRow extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final bool completed;

  const _MilestoneRow({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: completed ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.primary),
        ),
        child: completed
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                number.toString().padLeft(2, '0'),
                style: AppTextStyles.micro.copyWith(color: AppColors.primary),
              ),
      ),
      title: Text(title, style: AppTextStyles.button),
      subtitle: Text(subtitle, style: AppTextStyles.micro),
      trailing: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

class _EditableMilestoneRow extends StatelessWidget {
  final int number;
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EditableMilestoneRow({
    required this.number,
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          number.toString().padLeft(2, '0'),
          style: AppTextStyles.micro.copyWith(color: AppColors.primary),
        ),
      ),
      title: Text(title, style: AppTextStyles.button),
      subtitle: Text('4 tasks', style: AppTextStyles.micro),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMilestones extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyMilestones({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fact_check_outlined,
            size: 100,
            color: AppColors.disabledBackground,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'You do not have any milestones yet.'.tr,
            style: AppTextStyles.bodyPrimary,
          ),
          TextButton(onPressed: onCreate, child: Text('Create one'.tr)),
        ],
      ),
    );
  }
}

class _AiAssistantButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AiAssistantButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary50,
        foregroundColor: AppColors.primary,
      ),
      icon: const Icon(Icons.auto_awesome, size: 16),
      label: Text('AI Assistant'.tr),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(text, style: AppTextStyles.micro.copyWith(color: color)),
    );
  }
}

class _SuccessMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SuccessMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.micro),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.button),
        ],
      ),
    );
  }
}
