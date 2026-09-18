import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FinancialDashboardScreen extends StatefulWidget {
  const FinancialDashboardScreen({super.key});

  @override
  State<FinancialDashboardScreen> createState() =>
      _FinancialDashboardScreenState();
}

class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
  // Main top timeframe selector: 'Month', 'Quoter', 'Year'
  String _mainTimeframe = 'Month';

  // Overview Trends filters
  String _overviewFilter = 'All';
  String _overviewPeriod = 'Weekly';

  String _categoryFilter = 'Expense';

  // Updates dependent dropdown options automatically based on requirements
  void _onMainTimeframeChanged(String? newValue) {
    if (newValue == null) return;
    setState(() {
      _mainTimeframe = newValue;
      if (_mainTimeframe == 'Quoter') {
        _overviewPeriod = 'Monthly';
      } else if (_mainTimeframe == 'Year') {
        _overviewPeriod = 'Yearly';
      } else {
        _overviewPeriod = 'Weekly';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Button, Title, and Main Timeframe Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.cardSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: colors.primaryText,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Financial Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _mainTimeframe,
                        dropdownColor: colors.cardSurface,
                        isDense: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: colors.secondaryText,
                        ),
                        items: ['Month', 'Quoter', 'Year'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.primaryText,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: _onMainTimeframeChanged,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Range Navigator Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 18,
                        color: colors.secondaryText,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      _mainTimeframe == 'Quoter'
                          ? 'June ,July, Aug 2026'
                          : 'August 2026',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: colors.secondaryText,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary Cards Row (Income, Expense, Savings)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        icon: Icons.trending_up,
                        iconBg: isDark ? const Color(0xFF1B382B) : Colors.green.shade50,
                        iconColor: Colors.green,
                        title: 'Income',
                        amount: '\$284.56',
                        change: '8.2% vs Last Quoter',
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: colors.divider,
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        icon: Icons.trending_down,
                        iconBg: isDark ? const Color(0xFF3E1F24) : Colors.red.shade50,
                        iconColor: Colors.red,
                        title: 'Expense',
                        amount: '\$50.00',
                        change: '8.2% vs Last Quoter',
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: colors.divider,
                    ),
                    Expanded(
                      child: _buildSummaryItem(
                        icon: Icons.savings_outlined,
                        iconBg: isDark ? const Color(0xFF1E2E4A) : Colors.blue.shade50,
                        iconColor: AppColors.primary,
                        title: 'Savings',
                        amount: '\$70.00',
                        change: '8.2% vs Last Quoter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Overview Trends Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Overview Trends',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            _buildDropdownFilter(
                              _overviewFilter,
                              ['All', 'Expense', 'Income', 'Saving'],
                              (val) {
                                setState(() => _overviewFilter = val!);
                              },
                            ),
                            const SizedBox(width: 8),
                            // If Main Timeframe is Quoter or Year, disable/lock the period selector or sync state
                            _buildDropdownFilter(
                              _overviewPeriod,
                              _mainTimeframe == 'Month'
                                  ? ['Weekly', 'Daily']
                                  : [_overviewPeriod],
                              _mainTimeframe == 'Month'
                                  ? (val) {
                                      setState(() => _overviewPeriod = val!);
                                    }
                                  : null, // Disabled when forced by Quoter/Year
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Dynamic Chart based on selected period
                    SizedBox(
                      height: 150,
                      child: _overviewPeriod == 'Daily'
                          ? _buildDailyBarChart()
                          : _mainTimeframe == 'Quoter'
                          ? _buildMonthlyBarChart()
                          : _buildWeeklyBarChart(),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(Colors.green, 'Income'),
                        const SizedBox(width: 16),
                        _buildLegendItem(Colors.red, 'Expense'),
                        const SizedBox(width: 16),
                        _buildLegendItem(AppColors.primary, 'Saving'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sort by Categories Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Sort by Categories',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            _buildDropdownFilter(
                              _categoryFilter,
                              ['Expense', 'Income'],
                              (val) {
                                setState(() => _categoryFilter = val!);
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 30),
                              ),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 12,
                                backgroundColor: colors.inputSurface,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.orange,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Income',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: colors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    '\$ 284.56',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              _buildCategoryRow(
                                Icons.fastfood_outlined,
                                Colors.orange,
                                'Food',
                                '\$ 213.24',
                                0.75,
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Icons.card_travel,
                                Colors.purple,
                                'Allowance',
                                '\$ 213.24',
                                0.75,
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Icons.shopping_bag_outlined,
                                Colors.cyan,
                                'Allowance',
                                '\$ 213.24',
                                0.75,
                              ),
                              const SizedBox(height: 8),
                              _buildCategoryRow(
                                Icons.more_horiz,
                                Colors.grey,
                                'More',
                                '\$ 213.24',
                                0.75,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String amount,
    required String change,
  }) {
    final colors = context.lifeSyncColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 12, color: iconColor),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colors.primaryText,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.arrow_downward, size: 9, color: Colors.red),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                change,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(
    String value,
    List<String> items,
    ValueChanged<String?>? onChanged,
  ) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.inputSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: colors.elevatedSurface,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: colors.secondaryText,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: 11, color: colors.primaryText),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Weekly bar view (for default Monthly view with Weekly breakdown)
  Widget _buildWeeklyBarChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBarGroup('1-7 Aug', 1.0, 0.5, 0.35),
        _buildBarGroup('8-14 Aug', 0.15, 0.65, 0.25),
        _buildBarGroup('15-21 Aug', 0.0, 0.48, 0.3),
        _buildBarGroup('22-31 Aug', 0.35, 0.52, 0.0),
      ],
    );
  }

  // Monthly bar view (when Quoter is selected)
  Widget _buildMonthlyBarChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBarGroup('June', 0.9, 0.4, 0.6),
        _buildBarGroup('July', 1.0, 0.7, 0.4),
        _buildBarGroup('August', 0.8, 0.5, 0.5),
      ],
    );
  }

  // Daily thin bar chart view (when Daily is selected)
  Widget _buildDailyBarChart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(31, (index) {
          int day = index + 1;
          double factor = (day % 3 == 0) ? 0.7 : (day % 2 == 0 ? 0.4 : 0.2);
          if (day == 5 || day == 15 || day == 22) factor = 0.9;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 5,
                  height: 90 * factor,
                  decoration: BoxDecoration(
                    color: day % 2 == 0 ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 6),
                 if (day == 1 ||
                    day == 5 ||
                    day == 10 ||
                    day == 15 ||
                    day == 20 ||
                    day == 25 ||
                    day == 31)
                  Text(
                    day < 10 ? '0$day' : '$day',
                    style: TextStyle(
                      fontSize: 9,
                      color: context.lifeSyncColors.secondaryText,
                    ),
                  )
                else
                  const Text('', style: TextStyle(fontSize: 9)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBarGroup(
    String label,
    double incomeFactor,
    double expenseFactor,
    double savingFactor,
  ) {
    final colors = context.lifeSyncColors;
    bool showIncome = _overviewFilter == 'All' || _overviewFilter == 'Income';
    bool showExpense = _overviewFilter == 'All' || _overviewFilter == 'Expense';
    bool showSaving = _overviewFilter == 'All' || _overviewFilter == 'Saving';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showIncome && incomeFactor > 0)
              Container(
                width: 8,
                height: 80 * incomeFactor,
                color: Colors.green,
              ),
            if (showIncome && incomeFactor > 0 && (showExpense || showSaving))
              const SizedBox(width: 2),
            if (showExpense && expenseFactor > 0)
              Container(
                width: 8,
                height: 80 * expenseFactor,
                color: Colors.red,
              ),
            if (showExpense && expenseFactor > 0 && showSaving)
              const SizedBox(width: 2),
            if (showSaving && savingFactor > 0)
              Container(
                width: 8,
                height: 80 * savingFactor,
                color: AppColors.primary,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: colors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: colors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    IconData icon,
    Color color,
    String title,
    String amount,
    double progress,
  ) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 12, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyle(fontSize: 9, color: colors.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: colors.inputSurface,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 2.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '75%',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
