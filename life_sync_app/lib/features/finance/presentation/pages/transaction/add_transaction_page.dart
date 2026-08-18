import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_back_button.dart';
import '../../widgets/finance/finance_form_field.dart';
import '../../widgets/transaction/transaction_type_selector.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 16,
                    ),
                    label: const Text('Save'),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              const TransactionTypeSelector(
                selectedIndex: 1,
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              const FinanceFormField(
                label: 'Date',
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Friday, 10 July 2024',
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              const FinanceFormField(
                label: 'Amount',
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$ ',
                    suffixIcon: Icon(
                      Icons.attach_money_rounded,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              FinanceFormField(
                label: 'Category',
                child: DropdownButtonFormField<String>(
                  value: null,
                  hint: const Text(
                    'Choose Category',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Food',
                      child: Text('Food'),
                    ),
                    DropdownMenuItem(
                      value: 'Shopping',
                      child: Text('Shopping'),
                    ),
                    DropdownMenuItem(
                      value: 'Allowance',
                      child: Text('Allowance'),
                    ),
                    DropdownMenuItem(
                      value: 'Saving',
                      child: Text('Saving'),
                    ),
                  ],
                  onChanged: (_) {},
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              const FinanceFormField(
                label: 'Note',
                child: TextField(
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add note',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}