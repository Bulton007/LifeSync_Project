import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/presentation/controllers/finance_controller.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';

class FinancialManagementScreen extends StatelessWidget {
  const FinancialManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Get.find<FinanceController>();
    final goals = Get.find<GoalController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Obx(() {
          final view = finance.state.value;
          if (view.status == ViewStatus.initial ||
              view.status == ViewStatus.loading) {
            return const AppLoadingView(message: 'Loading finances…');
          }
          if (view.status == ViewStatus.error && view.data == null) {
            return AppErrorView(
              message:
                  view.exception?.message ??
                  'Finance data could not be loaded.',
              onRetry: finance.load,
            );
          }
          return RefreshIndicator(
            onRefresh: () => finance.load(refresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Financial Management',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Track and manage your money here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.primary,
                        ),
                        onSelected: (value) {
                          if (value == 'categories') {
                            _manageCategoriesDialog(context, finance);
                          } else {
                            _budgetDialog(context, finance);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'categories',
                            child: Text('Manage categories'),
                          ),
                          PopupMenuItem(
                            value: 'budget',
                            child: Text('Add budget'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RepaintBoundary(child: _BalanceCard(finance: finance)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _entryDialog(
                            context,
                            finance,
                            FinanceEntryType.income,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.trending_up, size: 20),
                          label: const Text(
                            'Add Income',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _entryDialog(
                            context,
                            finance,
                            FinanceEntryType.expense,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.trending_down, size: 20),
                          label: const Text(
                            'Add Expense',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(
                    title: 'Saving Goals',
                    action: 'View goals',
                    onTap: () => Get.toNamed<void>(AppRoutes.goalEditor),
                  ),
                  const SizedBox(height: 12),
                  RepaintBoundary(
                    child: SizedBox(
                      height: 135,
                      child: goals.goals.where((goal) => !goal.archived).isEmpty
                          ? const _InlineEmpty(message: 'No saving goals yet.')
                          : ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: goals.goals
                                  .where((goal) => !goal.archived)
                                  .take(6)
                                  .length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, index) {
                                final goal = goals.goals
                                    .where((item) => !item.archived)
                                    .take(6)
                                    .elementAt(index);
                                return _SavingGoalCard(goal: goal);
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    title: 'Budgets',
                    action: 'Add',
                    onTap: () => _budgetDialog(context, finance),
                  ),
                  const SizedBox(height: 10),
                  if (finance.data.budgets.isEmpty)
                    const _InlineEmpty(message: 'No budgets configured.')
                  else
                    for (final budget in finance.data.budgets.take(4)) ...[
                      _BudgetRow(budget: budget, finance: finance),
                      const SizedBox(height: 10),
                    ],
                  const SizedBox(height: 14),
                  _SectionTitle(
                    title: 'Recent Transactions',
                    action: _filterLabel(finance),
                    onTap: () => _filterDialog(context, finance),
                  ),
                  const SizedBox(height: 8),
                  if (finance.history.isEmpty)
                    const _InlineEmpty(
                      message: 'No transactions in this period.',
                    )
                  else
                    for (final entry in finance.history.take(10))
                      _TransactionRow(entry: entry, finance: finance),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.finance});
  final FinanceController finance;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total balance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFFF0F5FF),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          finance.balance.format(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: finance.balance.minorUnits.isNegative
                ? Colors.red
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Summary(
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Income',
              amount: finance.incomeTotal.format(),
            ),
            Container(height: 30, width: 1, color: Colors.grey.shade200),
            _Summary(
              icon: Icons.trending_down,
              color: Colors.red,
              title: 'Expense',
              amount: finance.expenseTotal.format(),
            ),
            Container(height: 30, width: 1, color: Colors.grey.shade200),
            _Summary(
              icon: Icons.receipt_long_outlined,
              color: AppColors.primary,
              title: 'Entries',
              amount: '${finance.history.length}',
            ),
          ],
        ),
      ],
    ),
  );
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String amount;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        amount,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(action, style: const TextStyle(color: AppColors.primary)),
      ),
    ],
  );
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
  );
}

class _SavingGoalCard extends StatelessWidget {
  const _SavingGoalCard({required this.goal});
  final GoalModel goal;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Get.toNamed<void>(AppRoutes.goalDetails, arguments: goal),
    child: Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.savings_outlined, color: Color(0xFF00ACC1)),
              Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            goal.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(goal.progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ACC1),
                ),
              ),
              Text(
                goal.currentAmount.format(),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: goal.progress,
            minHeight: 4,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF00ACC1),
          ),
        ],
      ),
    ),
  );
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.budget, required this.finance});
  final BudgetModel budget;
  final FinanceController finance;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: budget.progress >= 1
            ? Colors.red.shade200
            : Colors.grey.shade200,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                budget.category,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${budget.spentAmount.format()} / ${budget.limitAmount.format()}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _budgetDialog(context, finance, existing: budget);
                } else {
                  finance.deleteBudget(budget);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: budget.progress,
          minHeight: 6,
          backgroundColor: Colors.grey.shade200,
          color: budget.progress >= 1 ? Colors.red : AppColors.primary,
        ),
      ],
    ),
  );
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.entry, required this.finance});
  final FinanceEntryModel entry;
  final FinanceController finance;
  @override
  Widget build(BuildContext context) {
    final category = finance.categoryFor(entry.categoryId);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: entry.isExpense
            ? Colors.red.shade50
            : Colors.green.shade50,
        child: Icon(
          entry.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
          color: entry.isExpense ? Colors.red : Colors.green,
          size: 18,
        ),
      ),
      title: Text(
        entry.title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${category?.name ?? 'Category'} • ${_date(entry.date)}',
        style: const TextStyle(fontSize: 11),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${entry.isExpense ? '-' : '+'}${entry.amount.format()}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: entry.isExpense ? Colors.red : Colors.green,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _entryDialog(context, finance, entry.type, existing: entry);
              } else {
                finance.deleteEntry(entry);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _entryDialog(
  BuildContext context,
  FinanceController finance,
  FinanceEntryType type, {
  FinanceEntryModel? existing,
}) async {
  if (finance.data.categories.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Create a category first.')));
    return;
  }
  final title = TextEditingController(text: existing?.title ?? '');
  final description = TextEditingController(text: existing?.description ?? '');
  final amount = TextEditingController(
    text: existing?.amount.toApiString() ?? '',
  );
  var category =
      finance.categoryFor(
        existing?.categoryId ?? finance.data.categories.first.id,
      ) ??
      finance.data.categories.first;
  var date = existing?.date ?? DateTime.now();
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '${existing == null ? 'Add' : 'Edit'} ${type == FinanceEntryType.income ? 'Income' : 'Expense'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_moneyInput],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: r'$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FinanceCategoryModel>(
                initialValue: category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: finance.data.categories
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item.name)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                  );
                  if (picked != null) setState(() => date = picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                    ),
                  ),
                  child: Text(
                    _date(date),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                Navigator.pop(
                  dialogContext,
                  title.text.trim().isNotEmpty &&
                      MoneyAmount.parse(amount.text).minorUnits > BigInt.zero,
                );
              } on FormatException {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Enter a valid amount.')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  if (saved == true) {
    final money = MoneyAmount.parse(amount.text);
    if (existing == null) {
      await finance.createEntry(
        type: type,
        categoryId: category.id,
        title: title.text,
        description: description.text,
        amount: money,
        date: date,
      );
    } else {
      await finance.updateEntry(
        existing,
        categoryId: category.id,
        title: title.text,
        description: description.text,
        amount: money,
        date: date,
      );
    }
  }
  title.dispose();
  description.dispose();
  amount.dispose();
}

Future<void> _categoryDialog(
  BuildContext context,
  FinanceController finance, {
  FinanceCategoryModel? existing,
}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final description = TextEditingController(text: existing?.description ?? '');
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(existing == null ? 'Add category' : 'Edit category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: name,
            maxLength: 60,
            decoration: InputDecoration(
              labelText: 'Category name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: description,
            maxLength: 160,
            decoration: InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(dialogContext, name.text.trim().isNotEmpty),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (saved == true) {
    if (existing == null) {
      await finance.createCategory(
        name.text,
        description: description.text,
        icon: 'category',
        color: '#2979FF',
      );
    } else {
      await finance.updateCategory(
        existing,
        name.text,
        description: description.text,
        icon: existing.icon ?? 'category',
        color: existing.color ?? '#2979FF',
      );
    }
  }
  name.dispose();
  description.dispose();
}

Future<void> _manageCategoriesDialog(
  BuildContext context,
  FinanceController finance,
) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => Obx(
      () => AlertDialog(
        title: const Text('Manage categories'),
        content: SizedBox(
          width: 420,
          child: finance.data.categories.isEmpty
              ? const Text('No categories yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: finance.data.categories.length,
                  itemBuilder: (context, index) {
                    final category = finance.data.categories[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(category.name),
                      subtitle:
                          category.description == null ||
                              category.description!.isEmpty
                          ? null
                          : Text(category.description!),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await _categoryDialog(
                              context,
                              finance,
                              existing: category,
                            );
                          } else {
                            final deleted = await finance.deleteCategory(
                              category,
                            );
                            if (!deleted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    finance.errorMessage.value ??
                                        'Category could not be deleted.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () async => _categoryDialog(context, finance),
            child: const Text('Add category'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _budgetDialog(
  BuildContext context,
  FinanceController finance, {
  BudgetModel? existing,
}) async {
  if (finance.data.categories.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Create a category first.')));
    return;
  }
  final amount = TextEditingController(
    text: existing?.limitAmount.toApiString() ?? '',
  );
  var category =
      finance.categoryFor(
        existing?.categoryId ?? finance.data.categories.first.id,
      ) ??
      finance.data.categories.first;
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Add budget' : 'Edit budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FinanceCategoryModel>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: finance.data.categories
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text(item.name)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => category = value);
              },
            ),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [_moneyInput],
              decoration: const InputDecoration(
                labelText: 'Limit',
                prefixText: r'$ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                Navigator.pop(
                  dialogContext,
                  MoneyAmount.parse(amount.text).minorUnits > BigInt.zero,
                );
              } on FormatException {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Enter a valid limit.')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  if (saved == true) {
    final limit = MoneyAmount.parse(amount.text);
    if (existing == null) {
      await finance.createBudget(category, limit);
    } else {
      await finance.updateBudget(existing, category, limit);
    }
  }
  amount.dispose();
}

Future<void> _filterDialog(
  BuildContext context,
  FinanceController finance,
) async {
  DateTime? start = finance.filterStart.value;
  DateTime? end = finance.filterEnd.value;
  final apply = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Filter by date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(start == null ? 'Start date' : _date(start!)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: start ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2200),
                );
                if (picked != null) setState(() => start = picked);
              },
            ),
            ListTile(
              title: Text(end == null ? 'End date' : _date(end!)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: end ?? DateTime.now(),
                  firstDate: start ?? DateTime(2000),
                  lastDate: DateTime(2200),
                );
                if (picked != null) setState(() => end = picked);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              start = null;
              end = null;
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: start != null && end != null
                ? () => Navigator.pop(dialogContext, true)
                : null,
            child: const Text('Apply'),
          ),
        ],
      ),
    ),
  );
  if (apply == true) await finance.setDateFilter(start, end);
}

String _filterLabel(FinanceController finance) =>
    finance.filterStart.value == null
    ? 'Filter'
    : '${_date(finance.filterStart.value!)} – ${_date(finance.filterEnd.value!)}';
String _date(DateTime value) => '${value.day}/${value.month}/${value.year}';
final _moneyInput = FilteringTextInputFormatter.allow(
  RegExp(r'^\d{0,10}(?:\.\d{0,2})?'),
);
