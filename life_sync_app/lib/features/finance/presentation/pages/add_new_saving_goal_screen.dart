import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddSavingGoalScreen extends StatefulWidget {
  const AddSavingGoalScreen({super.key});

  @override
  State<AddSavingGoalScreen> createState() => _AddSavingGoalScreenState();
}

class _AddSavingGoalScreenState extends State<AddSavingGoalScreen> {
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: 'Friday, 10 July 2024',
  );

  // Selected color index from the palette
  int _selectedColorIndex = 1;

  final List<Color> _colors = [
    Colors.transparent, // Placeholder for the gradient picker icon
    const Color(0xFF0077B6), // Blue
    const Color(0xFF6A0DAD), // Purple
    const Color(0xFFFFD700), // Yellow
    const Color(0xFFC70039), // Red/Maroon
    const Color(0xFF7B68EE), // Medium Slate Blue
    const Color(0xFFFF1493), // Deep Pink
  ];

  @override
  void dispose() {
    _purposeController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Close Button and Save Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  Container(
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: colors.primaryText),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Save Button
                  OutlinedButton.icon(
                    onPressed: () {
                      // Handle save action here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primaryBlue,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    icon: Icon(
                      Icons.check,
                      size: 18,
                      color: colors.primaryBlue,
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

              // Purpose Field
              TextField(
                controller: _purposeController,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 14,
                ),
                cursorColor: colors.primaryBlue,
                decoration: InputDecoration(
                  hintText: 'Purpose',
                  hintStyle: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colors.inputSurface,
                  prefixIcon: Icon(
                    Icons.edit_outlined,
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
                    borderSide: BorderSide(color: colors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Color Palette Section
              const Text(
                'Color',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_colors.length, (index) {
                  if (index == 0) {
                    // Gradient / Rainbow picker icon container
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Colors.purple,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: _selectedColorIndex == index
                              ? Border.all(color: Colors.black87, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }

                  // Solid color circles
                  bool isSelected = _selectedColorIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorIndex = index),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black87, width: 2)
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Target Amount Field
              Text(
                'Target Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 14,
                ),
                cursorColor: colors.primaryBlue,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. \$168',
                  hintStyle: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 14,
                  ),
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
                    borderSide: BorderSide(color: colors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Estimated Complete Date Field
              Text(
                'Est. Complete Date',
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
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 14,
                ),
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
                    borderSide: BorderSide(color: colors.primaryBlue),
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
}
