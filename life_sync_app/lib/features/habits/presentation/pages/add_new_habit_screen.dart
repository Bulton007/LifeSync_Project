import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';

class AddNewHabitScreen extends StatefulWidget {
  const AddNewHabitScreen({super.key});

  @override
  State<AddNewHabitScreen> createState() => _AddNewHabitScreenState();
}

class _AddNewHabitScreenState extends State<AddNewHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _habitNameController = TextEditingController();
  late final HabitController _controller;
  HabitModel? _editing;

  int _selectedColorIndex = 1;

  String _repeatFrequency = 'Weekly';

  final List<bool> _selectedDays = [
    false,
    true,
    true,
    false,
    true,
    true,
    false,
  ];

  final List<String> _checklist = [];

  bool _reminderEnabled = false;
  String _reminderTime = '10:00 PM';

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HabitController>();
    final argument = Get.arguments;
    if (argument is HabitModel) {
      _editing = argument;
      _habitNameController.text = argument.name;
      _repeatFrequency = switch (argument.frequencyKind) {
        'DAILY' => 'Daily',
        'MONTHLY' => 'Monthly',
        _ => 'Weekly',
      };
      if (argument.scheduledDays.isNotEmpty) {
        const codes = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
        for (var index = 0; index < codes.length; index++) {
          _selectedDays[index] = argument.scheduledDays.contains(codes[index]);
        }
      }
      _startDate = argument.startDate ?? DateTime.now();
      _endDate = argument.endDate;
      if (argument.description?.trim().isNotEmpty ?? false) {
        _checklist.addAll(argument.description!.split('\n'));
      }
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_repeatFrequency == 'Weekly' && !_selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one scheduled day.')),
      );
      return;
    }
    final description = _checklist.isEmpty ? null : _checklist.join('\n');
    final editing = _editing;
    final ok = editing == null
        ? await _controller.createHabit(
            name: _habitNameController.text,
            description: description,
            frequency: _frequencyPayload(),
            startDate: _startDate,
            endDate: _endDate,
          )
        : await _controller.updateHabit(
            habit: editing,
            name: _habitNameController.text,
            description: description,
            frequency: _frequencyPayload(),
            startDate: _startDate,
            endDate: _endDate,
          );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.errorMessage.value ?? 'Could not save habit.',
          ),
        ),
      );
    }
  }

  String _frequencyPayload() {
    if (_repeatFrequency == 'Daily') return 'DAILY';
    if (_repeatFrequency == 'Monthly') return 'MONTHLY';
    const codes = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final days = [
      for (var i = 0; i < codes.length; i++)
        if (_selectedDays[i]) codes[i],
    ];
    return 'WEEKLY:${days.join(',')}';
  }

  // Add a new checklist task
  void _addTask() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final task = controller.text.trim();

                if (task.isNotEmpty) {
                  setState(() {
                    _checklist.add(task);
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Select date
  Future<void> _selectDate({required bool isStartDate}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? _startDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = selectedDate;

        // If end date is before start date, remove it.
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      } else {
        _endDate = selectedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // TOP BAR
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    Text(
                      _editing == null ? 'New Habit' : 'Edit Habit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    Obx(
                      () => OutlinedButton.icon(
                        onPressed: _controller.isSubmitting.value
                            ? null
                            : _saveHabit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E88E5),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        icon: _controller.isSubmitting.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.check,
                                size: 16,
                                color: Color(0xFF1E88E5),
                              ),
                        label: Text(
                          _editing == null ? 'Save' : 'Update',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =========================
                // HABIT NAME
                // =========================
                TextFormField(
                  controller: _habitNameController,
                  textInputAction: TextInputAction.done,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Habit name is required'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Habit Name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.edit_outlined,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF1E88E5)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // COLOR
                // =========================
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
                  children: List.generate(7, (index) {
                    final colors = [
                      null,
                      const Color(0xFF0077B6),
                      const Color(0xFF6A0DAD),
                      const Color(0xFFFFD700),
                      const Color(0xFFC70039),
                      const Color(0xFF7B68EE),
                      const Color(0xFFFF1493),
                    ];

                    final isSelected = _selectedColorIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[index],
                          gradient: index == 0
                              ? const LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.yellow,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.purple,
                                  ],
                                )
                              : null,
                          border: isSelected
                              ? Border.all(color: Colors.black87, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // =========================
                // REPEAT
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Repeat',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _repeatFrequency,
                          isDense: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'Weekly',
                              child: Text('Weekly'),
                            ),
                            DropdownMenuItem(
                              value: 'Daily',
                              child: Text('Daily'),
                            ),
                            DropdownMenuItem(
                              value: 'Monthly',
                              child: Text('Monthly'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _repeatFrequency = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =========================
                // DAYS
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .asMap()
                      .entries
                      .map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        final isSelected = _selectedDays[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDays[index] = !_selectedDays[index];
                                });
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2979FF)
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  day[0],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? const Color(0xFF2979FF)
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      })
                      .toList(),
                ),

                const SizedBox(height: 24),

                // =========================
                // CHECKLIST
                // =========================
                const Text(
                  'Checklist',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                ..._checklist.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}.  $task',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            setState(() {
                              _checklist.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                TextButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xFF1E88E5),
                  ),
                  label: const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 13, color: Color(0xFF1E88E5)),
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // REMINDER
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reminder',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    Row(
                      children: [
                        Switch(
                          value: _reminderEnabled,
                          activeColor: const Color(0xFF1E88E5),
                          onChanged: (value) {
                            setState(() {
                              _reminderEnabled = value;
                            });
                          },
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _reminderEnabled
                                ? Colors.white
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _reminderTime,
                              isDense: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.black54,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: '10:00 PM',
                                  child: Text('10:00 PM'),
                                ),
                                DropdownMenuItem(
                                  value: '8:00 AM',
                                  child: Text('8:00 AM'),
                                ),
                                DropdownMenuItem(
                                  value: '1:00 PM',
                                  child: Text('1:00 PM'),
                                ),
                              ],
                              onChanged: _reminderEnabled
                                  ? (value) {
                                      if (value == null) return;

                                      setState(() {
                                        _reminderTime = value;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // =========================
                // START DATE
                // =========================
                _buildDateRow(
                  label: 'Start Date',
                  value: _formatDate(_startDate),
                  onTap: () => _selectDate(isStartDate: true),
                ),

                const SizedBox(height: 12),

                // =========================
                // END DATE
                // =========================
                _buildDateRow(
                  label: 'End Date',
                  value: _endDate == null ? 'Never' : _formatDate(_endDate!),
                  onTap: () => _selectDate(isStartDate: false),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDateRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF1E88E5),
                ),

                const SizedBox(width: 10),

                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
