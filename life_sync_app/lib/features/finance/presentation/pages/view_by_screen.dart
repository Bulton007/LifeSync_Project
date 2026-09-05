import 'package:flutter/material.dart';

class ViewByScreen extends StatefulWidget {
  const ViewByScreen({super.key});

  @override
  State<ViewByScreen> createState() => _ViewByScreenState();
}

class _ViewByScreenState extends State<ViewByScreen> {
  // Selected radio option for "View By"
  String _selectedViewBy = 'Month';

  // Dropdown states for components
  String _component69Value = 'Daily';
  String _component70Value = 'Weekly';
  String _component71Value = 'Expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // View By Radio Selection Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: RadioGroup<String>(
                  groupValue: _selectedViewBy,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => _selectedViewBy = value);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'View By',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRadioOption('Month'),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildRadioOption('Quarter'),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildRadioOption('Year'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Components Row / Display
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  // Component 69 (Dropdown with Daily selected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Component 69',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      _buildCustomDropdown(
                        value: _component69Value,
                        items: ['Weekly', 'Daily'],
                        onChanged: (val) =>
                            setState(() => _component69Value = val!),
                      ),
                    ],
                  ),

                  // Component 70 (Dropdown with Weekly selected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Component 70',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      _buildCustomDropdown(
                        value: _component70Value,
                        items: ['Weekly', 'Daily'],
                        onChanged: (val) =>
                            setState(() => _component70Value = val!),
                      ),
                    ],
                  ),

                  // Component 71 (Filter type selection dropdown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Component 71',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      _buildFilterDropdown(
                        value: _component71Value,
                        items: ['Expense', 'Income', 'Saving'],
                        onChanged: (val) =>
                            setState(() => _component71Value = val!),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for Radio List Option
  Widget _buildRadioOption(String title) {
    return InkWell(
      onTap: () => setState(() => _selectedViewBy = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Radio<String>(value: title, activeColor: const Color(0xFF2979FF)),
          ],
        ),
      ),
    );
  }

  // Helper builder for Component 69 & 70 style popup dropdown buttons
  Widget _buildCustomDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black87,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Helper builder for Component 71 style dropdown with dot indicators
  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    Color getIndicatorColor(String item) {
      if (item == 'Expense') return Colors.red;
      if (item == 'Income') return Colors.green;
      return Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black87,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: getIndicatorColor(item),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
