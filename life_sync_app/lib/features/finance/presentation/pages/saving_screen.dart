import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SavingScreen extends StatefulWidget {
  const SavingScreen({super.key});

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  // Track selected transaction type: 0 = Income, 1 = Expense, 2 = Transfer
  int _selectedTypeIndex = 1;

  final TextEditingController _dateController = TextEditingController(
    text: 'Friday, 10 July 2024',
  );
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedCategory = 'Choose Category';

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
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
              // Top Bar with Back Button and Save Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.08),
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

                  // Save Button
                  OutlinedButton.icon(
                    onPressed: () {
                      // Handle save action here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Transaction Type Selector (Income, Expense, Transfer)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTypeButton('Income', 0)),
                    Expanded(child: _buildTypeButton('Expense', 1)),
                    Expanded(child: _buildTypeButton('Transfer', 2)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Date Field
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                readOnly: true,
                style: TextStyle(color: colors.primaryText),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.inputSurface,
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: colors.secondaryText,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Amount Field
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: colors.primaryText),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.inputSurface,
                  suffixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: colors.secondaryText,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown/Selector
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.inputSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: colors.elevatedSurface,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.secondaryText,
                    ),
                    items:
                        <String>[
                          'Choose Category',
                          'Food',
                          'Coffee',
                          'Shopping',
                          'Transport',
                          'Bills',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: value == 'Choose Category'
                                    ? colors.secondaryText
                                    : colors.primaryText,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note Field
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: TextStyle(color: colors.primaryText),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.inputSurface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Income / Expense / Transfer buttons
  Widget _buildTypeButton(String title, int index) {
    final colors = context.lifeSyncColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedTypeIndex == index;

    // Dynamic styling based on selection state
    Color textColor = colors.secondaryText;
    Color? backgroundColor = Colors.transparent;
    Border? border;

    if (isSelected) {
      if (index == 1) {
        // Expense active state (Red theme matching design)
        textColor = Colors.red;
        backgroundColor = isDark ? Colors.red.withValues(alpha: 0.15) : Colors.white;
        border = Border.all(color: Colors.red.shade300, width: 1.2);
      } else {
        // Income or Transfer active state
        textColor = colors.primaryText;
        backgroundColor = colors.elevatedSurface;
        border = Border.all(color: colors.border, width: 1.2);
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTypeIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
