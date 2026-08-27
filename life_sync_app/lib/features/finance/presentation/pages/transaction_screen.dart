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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
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
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.black87,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _allDropdownValue,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: Colors.black54,
                        ),
                        items: ['All', 'Month', 'Year'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_filters.length, (index) {
                  bool isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
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
                        color: isSelected
                            ? const Color(0xFF1E88E5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E88E5)
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.04),
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
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }),
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
                    amountColor: const Color(0xFF1E88E5),
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
                    amountColor: const Color(0xFF1E88E5),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
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
              Text(
                dateHeader,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                headerSummary,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
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
