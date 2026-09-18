import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';

class CreateGoalFirstStepScreen extends StatefulWidget {
  const CreateGoalFirstStepScreen({super.key});
  @override
  State<CreateGoalFirstStepScreen> createState() => _CreateGoalScreen1State();
}

class _CreateGoalScreen1State extends State<CreateGoalFirstStepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController();
  final _outcomeController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController(text: '0.00');
  late final GoalController _controller;
  GoalModel? _editing;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GoalController>();
    _deadline = DateTime.now().add(const Duration(days: 30));
    final argument = Get.arguments;
    if (argument is GoalModel) {
      _editing = argument;
      _goalController.text = argument.title;
      _outcomeController.text = argument.description ?? '';
      _targetController.text = argument.targetAmount.toApiString();
      _currentController.text = argument.currentAmount.toApiString();
      _deadline = argument.deadline;
    }
  }

  @override
  void dispose() {
    _goalController.dispose();
    _outcomeController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final target = MoneyAmount.parse(_targetController.text);
    final current = MoneyAmount.parse(_currentController.text);
    final editing = _editing;
    final ok = editing == null
        ? await _controller.createGoal(
            title: _goalController.text,
            description: _outcomeController.text,
            targetAmount: target,
            currentAmount: current,
            deadline: _deadline,
          )
        : await _controller.updateGoal(
            goal: editing,
            title: _goalController.text,
            description: _outcomeController.text,
            targetAmount: target,
            currentAmount: current,
            deadline: _deadline,
          );
    if (!mounted) {
      return;
    }
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.errorMessage.value ?? 'Could not save goal.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colors.elevatedSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: Get.back,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _editing == null ? 'Create Goal' : 'Edit Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    _step('1', 'Define', true),
                    Expanded(
                      child: Container(height: 2, color: colors.primaryBlue),
                    ),
                    _step('2', 'Track', false),
                    Expanded(
                      child: Container(height: 2, color: colors.divider),
                    ),
                    _step('3', 'Achieve', false),
                  ],
                ),
                const SizedBox(height: 36),
                TextFormField(
                  controller: _goalController,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 14,
                  ),
                  cursorColor: colors.primaryBlue,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Goal title is required'
                      : null,
                  decoration: _input('Goal', icon: Icons.edit_outlined),
                ),
                const SizedBox(height: 24),
                Text(
                  'What Success Will Look Like?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _outcomeController,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 14,
                  ),
                  cursorColor: colors.primaryBlue,
                  maxLines: 2,
                  decoration: _input('Outcome'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _targetController,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 14,
                        ),
                        cursorColor: colors.primaryBlue,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_moneyFormatter],
                        validator: _positiveMoney,
                        decoration: _input('Target amount', prefix: r'$ '),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _currentController,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 14,
                        ),
                        cursorColor: colors.primaryBlue,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [_moneyFormatter],
                        validator: _nonNegativeMoney,
                        decoration: _input('Current amount', prefix: r'$ '),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Deadline',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime(2200),
                    );
                    if (picked != null) {
                      setState(() => _deadline = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colors.inputSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 16, color: colors.secondaryText),
                            const SizedBox(width: 8),
                            Text(
                              _date(_deadline),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.unfold_more,
                          size: 16,
                          color: colors.secondaryText,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: _controller.isSubmitting.value ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        disabledBackgroundColor: const Color(0xFFEFEFF1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _controller.isSubmitting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _editing == null ? 'Save Goal' : 'Update Goal',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _step(String number, String label, bool active) => Column(
    children: [
      Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? context.lifeSyncColors.primaryBlue
              : context.lifeSyncColors.inputSurface,
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? Colors.transparent : context.lifeSyncColors.border,
          ),
        ),
        child: Text(
          number,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : context.lifeSyncColors.secondaryText,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active
              ? context.lifeSyncColors.primaryBlue
              : context.lifeSyncColors.secondaryText,
        ),
      ),
    ],
  );

  InputDecoration _input(String hint, {IconData? icon, String? prefix}) {
    final colors = context.lifeSyncColors;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colors.secondaryText,
        fontSize: 14,
      ),
      prefixText: prefix,
      prefixStyle: TextStyle(
        color: colors.primaryText,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: icon == null
          ? null
          : Icon(icon, size: 20, color: colors.secondaryText),
      filled: true,
      fillColor: colors.inputSurface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colors.primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  String? _positiveMoney(String? value) {
    try {
      return MoneyAmount.parse(value ?? '').minorUnits > BigInt.zero
          ? null
          : 'Enter an amount above zero';
    } on FormatException {
      return 'Use at most two decimal places';
    }
  }

  String? _nonNegativeMoney(String? value) {
    try {
      return MoneyAmount.parse(value ?? '').minorUnits >= BigInt.zero
          ? null
          : 'Amount cannot be negative';
    } on FormatException {
      return 'Use at most two decimal places';
    }
  }

  static final _moneyFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{0,10}(?:\.\d{0,2})?'),
  );
}

String _date(DateTime date) => '${date.day}/${date.month}/${date.year}';
