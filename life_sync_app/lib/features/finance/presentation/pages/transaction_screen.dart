import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Expense, 2: Income, 3: Saving
  String _allDropdownValue = 'All';

  final List<String> _filters = ['All', 'Expense', 'Income', 'Saving'];

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
              // Top Bar with Back Button, Title, and Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colors.cardSurface,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.border),
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
                        Flexible(
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _allDropdownValue,
                        dropdownColor: colors.elevatedSurface,
                        isDense: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: colors.secondaryText,
                        ),
                        items: ['All', 'Month', 'Year'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.primaryText,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _allDropdownValue = val!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filter Chips Row (All, Expense, Income, Saving)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    bool isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < _filters.length - 1 ? 10 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilterIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : colors.cardSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : colors.border,
                            ),
                            boxShadow: [
                              if (!isSelected)
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.1)
                                      : Colors.grey.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Text(
                            _filters[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : colors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Transaction Groups
              _buildTransactionGroup(
                dateHeader: 'Today',
                headerSummary: '\$ 128.68   \$ 56.40  12.50',
                transactions: [
                  _buildTransactionItem(
                    icon: Icons.fastfood_outlined,
                    iconBg: Colors.orange.shade50,
                    iconColor: Colors.orange,
                    title: 'Food',
                    time: 'Today, 7:34 AM',
                    amount: '-\$10.4',
                    amountColor: Colors.red,
                  ),
                  _buildTransactionItem(
                    icon: Icons.shopping_bag_outlined,
                    iconBg: Colors.purple.shade50,
                    iconColor: Colors.purple,
                    title: 'Shopping',
                    time: 'Today, 7:34 AM',
                    amount: '-\$46',
                    amountColor: Colors.red,
                  ),
                  _buildTransactionItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                    title: 'Allowance',
                    time: 'Today, 7:34 AM',
                    amount: '+\$128.68',
                    amountColor: Colors.green,
                  ),
                  _buildTransactionItem(
                    icon: Icons.beach_access,
                    iconBg: Colors.cyan.shade50,
                    iconColor: Colors.cyan,
                    title: 'Saved to Siem Reap Trip',
                    time: 'Today, 7:34 AM',
                    amount: '\$12.5',
                    amountColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTransactionGroup(
                dateHeader: '08 Aug 2026',
                headerSummary: '\$ 56.40  12.50',
                transactions: [
                  _buildTransactionItem(
                    icon: Icons.fastfood_outlined,
                    iconBg: Colors.orange.shade50,
                    iconColor: Colors.orange,
                    title: 'Food',
                    time: 'Today, 7:34 AM',
                    amount: '-\$10.4',
                    amountColor: Colors.red,
                  ),
                  _buildTransactionItem(
                    icon: Icons.shopping_bag_outlined,
                    iconBg: Colors.purple.shade50,
                    iconColor: Colors.purple,
                    title: 'Shopping',
                    time: 'Today, 7:34 AM',
                    amount: '-\$46',
                    amountColor: Colors.red,
                  ),
                  _buildTransactionItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                    title: 'Allowance',
                    time: 'Today, 7:34 AM',
                    amount: '+\$128.68',
                    amountColor: Colors.green,
                  ),
                  _buildTransactionItem(
                    icon: Icons.beach_access,
                    iconBg: Colors.cyan.shade50,
                    iconColor: Colors.cyan,
                    title: 'Saved to Siem Reap Trip',
                    time: 'Today, 7:34 AM',
                    amount: '\$12.5',
                    amountColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTransactionGroup(
                dateHeader: '07 Aug 2026',
                headerSummary: '\$ 56.40',
                transactions: [
                  _buildTransactionItem(
                    icon: Icons.fastfood_outlined,
                    iconBg: Colors.orange.shade50,
                    iconColor: Colors.orange,
                    title: 'Food',
                    time: 'Today, 7:34 AM',
                    amount: '-\$10.4',
                    amountColor: Colors.red,
                  ),
                  _buildTransactionItem(
                    icon: Icons.shopping_bag_outlined,
                    iconBg: Colors.purple.shade50,
                    iconColor: Colors.purple,
                    title: 'Shopping',
                    time: 'Today, 7:34 AM',
                    amount: '-\$46',
                    amountColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Builder for section grouped by date
  Widget _buildTransactionGroup({
    required String dateHeader,
    required String headerSummary,
    required List<Widget> transactions,
  }) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                  dateHeader,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                headerSummary,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.divider),
          const SizedBox(height: 8),
          ...transactions,
        ],
      ),
    );
  }

  // Builder for single transaction list row
  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String time,
    required String amount,
    required Color amountColor,
  }) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: colors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: colors.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
