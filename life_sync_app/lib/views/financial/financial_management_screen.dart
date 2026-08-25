import 'package:flutter/material.dart';

class FinancialManagementScreen extends StatelessWidget {
  const FinancialManagementScreen({super.key});

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
              // Header Title
              const Text(
                'Financial Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track and Manage your money here',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Total Balance Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total balance',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history,
                            color: Color(0xFF1E88E5),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '\$ 234.56',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Income, Expense, Saving Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(
                          icon: Icons.trending_up,
                          iconColor: Colors.green,
                          title: 'Income',
                          amount: '\$ 284.56',
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[200],
                        ),
                        _buildSummaryItem(
                          icon: Icons.trending_down,
                          iconColor: Colors.red,
                          title: 'Expense',
                          amount: '\$ 50.00',
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[200],
                        ),
                        _buildSummaryItem(
                          icon: Icons.savings_outlined,
                          iconColor: Color(0xFF1E88E5),
                          title: 'Saving',
                          amount: '\$ 70.00',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Saving Goal Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saving Goal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(color: Color(0xFF1E88E5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Saving Goal Cards List
              SizedBox(
                height: 135,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildGoalCard(
                      icon: Icons.beach_access,
                      iconBg: const Color(0xFFE0F7FA),
                      iconColor: const Color(0xFF00ACC1),
                      title: 'Siem Reap Trip',
                      percentage: '42%',
                      progress: 0.42,
                      amount: '\$150.00',
                    ),
                    const SizedBox(width: 12),
                    _buildGoalCard(
                      icon: Icons.school,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: Colors.green,
                      title: 'School tuition',
                      percentage: '34%',
                      progress: 0.34,
                      amount: '\$480.00',
                    ),
                    const SizedBox(width: 12),
                    _buildGoalCard(
                      icon: Icons.shield_outlined,
                      iconBg: const Color(0xFFEDE7F6),
                      iconColor: Colors.deepPurple,
                      title: 'Emergency',
                      percentage: '--',
                      progress: 0.0,
                      amount: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Transaction Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(color: Color(0xFF1E88E5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Transaction List
              _buildTransactionItem(
                title: 'Food',
                time: 'Today, 7:34 AM',
                amount: '-\$2.8',
                isNegative: true,
              ),
              _buildTransactionItem(
                title: 'Coffee',
                time: 'Today, 7:34 AM',
                amount: '-\$2',
                isNegative: true,
              ),
              _buildTransactionItem(
                title: 'Allowance',
                time: 'Yesterday, 8:00 PM',
                amount: '+\$30',
                isNegative: false,
              ),
              _buildTransactionItem(
                title: 'Save to Siem Reap...',
                time: 'Yesterday, 5:35 PM',
                amount: '\$35',
                isNeutral: true,
              ),
              const SizedBox(height: 80), // Padding for bottom bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false),
            _buildNavItem(Icons.track_changes, 'Goals', false),
            _buildNavItem(Icons.bar_chart, 'Finance', true),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF2979FF),
              mini: true,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String amount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String percentage,
    required double progress,
    required String amount,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: progress > 0 ? const Color(0xFF00ACC1) : Colors.grey,
                ),
              ),
              if (amount.isNotEmpty)
                Text(
                  amount,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0 ? const Color(0xFF00ACC1) : Colors.transparent,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String time,
    required String amount,
    bool isNegative = false,
    bool isNeutral = false,
  }) {
    Color amountColor = Colors.green;
    if (isNegative) amountColor = Colors.red;
    if (isNeutral) amountColor = const Color(0xFF1E88E5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
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

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? const Color(0xFF1E88E5) : Colors.grey),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
