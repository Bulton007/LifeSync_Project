import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/core/widgets/analytics_charts.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:life_sync_app/features/finance/presentation/controllers/finance_controller.dart';
import 'package:life_sync_app/features/finance/presentation/models/finance_analytics.dart';

class FinancialDashboardScreen extends StatefulWidget {
  const FinancialDashboardScreen({
    this.controller,
    this.initialDate,
    super.key,
  });
  final FinanceController? controller;
  final DateTime? initialDate;
  @override
  State<FinancialDashboardScreen> createState() =>
      _FinancialDashboardScreenState();
}

class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
  late final FinanceController _finance;
  late DateTime _anchor;
  FinancePeriod _period = FinancePeriod.month;
  FinanceGrouping _grouping = FinanceGrouping.weekly;
  String _series = 'All';
  FinanceEntryType _categoryType = FinanceEntryType.expense;
  bool _allCategories = false;
  static const _palette = [
    Color(0xFF6654ED),
    Color(0xFFF7963C),
    Color(0xFF50BDCD),
    Color(0xFF4C83FF),
    Color(0xFFEE5D75),
    Color(0xFF71B858),
  ];
  @override
  void initState() {
    super.initState();
    _anchor = widget.initialDate ?? DateTime.now();
    _finance =
        widget.controller ?? FinanceController(Get.find<FinanceRepository>());
    _finance.load();
  }

  String _periodTitle(BuildContext context, FinanceAnalytics analytics) {
    final dates = MaterialLocalizations.of(context);
    return switch (_period) {
      FinancePeriod.month => dates.formatMonthYear(analytics.start),
      FinancePeriod.quarter =>
        'Q${((analytics.start.month - 1) ~/ 3) + 1} · ${analytics.start.year}',
      FinancePeriod.year => '${analytics.start.year}',
    };
  }

  void _shift(int direction, FinanceAnalytics analytics) => setState(() {
    _anchor = DateTime(
      analytics.start.year,
      analytics.start.month + direction * analytics.monthCount,
    );
  });

  String _change(MoneyAmount current, MoneyAmount previous) {
    if (previous.minorUnits == BigInt.zero) return 'No previous data'.tr;
    final tenths =
        ((current.minorUnits - previous.minorUnits) * BigInt.from(1000)) ~/
        previous.minorUnits.abs();
    final percentage = tenths.toDouble() / 10;
    return '@percent% vs previous'.trParams({
      'percent': '${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(1)}',
    });
  }

  Widget _selector<T>(
    String key,
    T value,
    List<T> choices,
    String Function(T) label,
    ValueChanged<T> change,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: context.lifeSyncColors.inputSurface,
      border: Border.all(color: context.lifeSyncColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        key: ValueKey(key),
        value: value,
        isDense: true,
        padding: const EdgeInsets.symmetric(vertical: 9),
        style: TextStyle(
          fontSize: 11,
          color: context.lifeSyncColors.primaryText,
        ),
        borderRadius: BorderRadius.circular(14),
        items: choices
            .map(
              (choice) => DropdownMenuItem(
                value: choice,
                child: Text(label(choice).tr),
              ),
            )
            .toList(),
        onChanged: (next) {
          if (next != null) change(next);
        },
      ),
    ),
  );

  Widget _panel(List<Widget> children, {bool filled = false}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: filled
          ? context.lifeSyncColors.inputSurface
          : context.lifeSyncColors.cardSurface,
      borderRadius: BorderRadius.circular(18),
      border: filled ? null : Border.all(color: context.lifeSyncColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      backgroundColor: colors.cardSurface,
      appBar: AppBar(
        backgroundColor: colors.cardSurface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Financial Analysis'.tr,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          tooltip: 'Back'.tr,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          _selector(
            'finance-period',
            _period,
            FinancePeriod.values,
            (value) => value.name.capitalizeFirst!,
            (next) {
              setState(() {
                _period = next;
                _grouping = next == FinancePeriod.month
                    ? FinanceGrouping.weekly
                    : FinanceGrouping.monthly;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        final state = _finance.state.value;
        if (state.status == ViewStatus.initial ||
            state.status == ViewStatus.loading) {
          return const AppLoadingView(message: 'Loading finances…');
        }
        if (state.status == ViewStatus.error && state.data == null) {
          return AppErrorView(
            message:
                state.exception?.message ??
                'Finance data could not be loaded.'.tr,
            onRetry: _finance.load,
          );
        }
        final analytics = FinanceAnalytics(_finance.history, _anchor, _period);
        final previous = analytics.previous;
        final income = analytics.total(FinanceEntryType.income);
        final expense = analytics.total(FinanceEntryType.expense);
        final incomeValues = analytics.values(
          FinanceEntryType.income,
          _grouping,
        );
        final expenseValues = analytics.values(
          FinanceEntryType.expense,
          _grouping,
        );
        final dates = MaterialLocalizations.of(context);
        final labels = analytics
            .buckets(_grouping)
            .map(
              (date) => _grouping == FinanceGrouping.monthly
                  ? dates
                        .formatShortMonthDay(date)
                        .replaceFirst(RegExp(r'\s*1$'), '')
                  : '${date.day}',
            )
            .toList();
        double decimal(MoneyAmount value) => value.minorUnits.toDouble() / 100;
        final chartSeries = [
          if (_series == 'All' || _series == 'Income')
            ChartSeries(
              'Income'.tr,
              incomeValues.map(decimal).toList(),
              const Color(0xFF4DAF65),
            ),
          if (_series == 'All' || _series == 'Expense')
            ChartSeries(
              'Expense'.tr,
              expenseValues.map(decimal).toList(),
              const Color(0xFFEF5350),
            ),
          if (_series == 'All' || _series == 'Balance')
            ChartSeries(
              'Balance'.tr,
              List.generate(
                incomeValues.length,
                (index) => decimal(incomeValues[index] - expenseValues[index]),
              ),
              colors.primaryBlue,
            ),
        ];
        final categories = analytics.categories(_categoryType).entries.toList()
          ..sort((first, second) => second.value.compareTo(first.value));
        final total = analytics.total(_categoryType);
        final today = DateTime.now();
        final nextStart = analytics.end;
        return RefreshIndicator(
          onRefresh: () => _finance.load(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            children: [
              Row(
                children: [
                  IconButton(
                    key: const ValueKey('finance-previous'),
                    tooltip: 'Previous period'.tr,
                    onPressed: () => _shift(-1, analytics),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      _periodTitle(context, analytics),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('finance-next'),
                    tooltip: 'Next period'.tr,
                    onPressed: nextStart.isAfter(today)
                        ? null
                        : () => _shift(1, analytics),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              if (state.status == ViewStatus.error)
                Text(
                  'Unable to refresh. Showing saved data.'.tr,
                  style: TextStyle(color: colors.negative),
                ),
              _panel([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summary(
                      'Income',
                      income,
                      previous.total(FinanceEntryType.income),
                      Icons.trending_up,
                      const Color(0xFF4DAF65),
                    ),
                    _summary(
                      'Expense',
                      expense,
                      previous.total(FinanceEntryType.expense),
                      Icons.trending_down,
                      const Color(0xFFEF5350),
                    ),
                    _summary(
                      'Balance',
                      analytics.balance,
                      previous.balance,
                      Icons.savings_outlined,
                      colors.primaryBlue,
                    ),
                  ],
                ),
              ], filled: true),
              const SizedBox(height: 18),
              _panel([
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Overview Trends'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _selector(
                      'finance-series',
                      _series,
                      ['All', 'Income', 'Expense', 'Balance'],
                      (value) => value,
                      (next) => setState(() => _series = next),
                    ),
                    _selector(
                      'finance-grouping',
                      _grouping,
                      FinanceGrouping.values,
                      (value) => value.name.capitalizeFirst!,
                      (next) => setState(() => _grouping = next),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnalyticsBarChart(
                  labels: labels,
                  series: chartSeries,
                  unit: r'$',
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: chartSeries
                      .map(
                        (series) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 7, color: series.color),
                            const SizedBox(width: 4),
                            Text(
                              series.label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                if (analytics.selected.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text('No transactions for this period.'.tr),
                  ),
              ]),
              const SizedBox(height: 18),
              _panel([
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Sort by Categories'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _selector(
                      'finance-category',
                      _categoryType,
                      FinanceEntryType.values,
                      (value) => value.name.capitalizeFirst!,
                      (next) => setState(() => _categoryType = next),
                    ),
                    if (categories.length > 4)
                      TextButton(
                        onPressed: () =>
                            setState(() => _allCategories = !_allCategories),
                        child: Text(
                          (_allCategories ? 'Show less' : 'View All').tr,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final donut = AnalyticsDonut(
                      values: categories
                          .map((entry) => decimal(entry.value))
                          .toList(),
                      colors: List.generate(
                        categories.length,
                        (index) => _palette[index % _palette.length],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _categoryType.name.capitalizeFirst!.tr,
                            style: const TextStyle(fontSize: 10),
                          ),
                          FittedBox(
                            child: Text(
                              total.format(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    final legend = Column(
                      children: [
                        if (categories.isEmpty)
                          Text('No transactions for this period.'.tr),
                        for (
                          var index = 0;
                          index <
                              (_allCategories
                                  ? categories.length
                                  : categories.length.clamp(0, 4));
                          index++
                        )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: _palette[index % _palette.length],
                                  size: 9,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _finance
                                                .categoryFor(
                                                  categories[index].key,
                                                )
                                                ?.name ??
                                            'Uncategorized'.tr,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      LinearProgressIndicator(
                                        value: categories[index].value.ratioOf(
                                          total,
                                        ),
                                        minHeight: 3,
                                        color:
                                            _palette[index % _palette.length],
                                      ),
                                      Text(
                                        '${categories[index].value.format()} · ${(categories[index].value.ratioOf(total) * 100).round()}%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                    return constraints.maxWidth < 310
                        ? Column(
                            children: [
                              Center(child: donut),
                              const SizedBox(height: 16),
                              legend,
                            ],
                          )
                        : Row(
                            children: [
                              donut,
                              const SizedBox(width: 14),
                              Expanded(child: legend),
                            ],
                          );
                  },
                ),
              ]),
              const SizedBox(height: 12),
              Text(
                'Balance is income minus expenses, not a separate savings account.'
                    .tr,
                style: TextStyle(fontSize: 11, color: colors.secondaryText),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _summary(
    String label,
    MoneyAmount amount,
    MoneyAmount previous,
    IconData icon,
    Color color,
  ) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: color.withValues(alpha: .08),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            label.tr,
            style: TextStyle(
              fontSize: 10,
              color: context.lifeSyncColors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              amount.format(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _change(amount, previous),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: context.lifeSyncColors.secondaryText,
            ),
          ),
        ],
      ),
    ),
  );
}
