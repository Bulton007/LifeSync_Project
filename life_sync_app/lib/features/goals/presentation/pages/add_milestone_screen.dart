import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

class AddMilestoneScreen extends StatefulWidget {
  const AddMilestoneScreen({super.key});

  @override
  State<AddMilestoneScreen> createState() => _MilestoneFormScreenState();
}

class _MilestoneFormScreenState extends State<AddMilestoneScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Tasks list for the milestone
  final List<String> _tasks = [];

  void _generateAiTasks() {
    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = 'Build Strong Study Routine';
      }

      _tasks.clear();

      _tasks.addAll([
        'Create a daily study schedule',
        'Study for at least 1 hour each day',
        'Review notes after each lesson',
        'Complete weekly practice exercises',
      ]);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Save milestone
  void _saveMilestone() {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a milestone name')),
      );
      return;
    }

    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one task')),
      );
      return;
    }

    final milestone = {
      'name': name,
      'description': description,
      'tasks': List<String>.from(_tasks),
    };

    Navigator.pop(context, milestone);
  }

  // Add a task
  void _addTask() {
    final controller = TextEditingController();
    final colors = context.lifeSyncColors;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 100,
            style: TextStyle(color: colors.primaryText),
            cursorColor: colors.primaryBlue,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              hintStyle: TextStyle(color: colors.secondaryText),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final task = controller.text.trim();

                if (task.isEmpty) {
                  return;
                }

                setState(() {
                  _tasks.add(task);
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  // Edit an existing task
  void _editTask(int index) {
    final controller = TextEditingController(text: _tasks[index]);
    final colors = context.lifeSyncColors;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 100,
            style: TextStyle(color: colors.primaryText),
            cursorColor: colors.primaryBlue,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              hintStyle: TextStyle(color: colors.secondaryText),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final task = controller.text.trim();

                if (task.isEmpty) {
                  return;
                }

                setState(() {
                  _tasks[index] = task;
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // TOP BAR
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: colors.border),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: colors.primaryText,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Text(
                    'New Milestone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryText,
                    ),
                  ),

                  OutlinedButton.icon(
                    onPressed: _saveMilestone,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2979FF),
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
                      size: 16,
                      color: Color(0xFF2979FF),
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==========================================
              // MILESTONE NAME
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Milestone Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  Text(
                    '${_nameController.text.length}/60',
                    style: TextStyle(fontSize: 11, color: colors.secondaryText),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                maxLength: 60,
                style: TextStyle(color: colors.primaryText, fontSize: 14),
                cursorColor: colors.primaryBlue,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Set a Major Step for Your Goal',
                  hintStyle: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 14,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: colors.inputSurface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colors.primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // DESCRIPTION
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Description (Optional)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  Text(
                    '${_descController.text.length}/250',
                    style: TextStyle(fontSize: 11, color: colors.secondaryText),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _descController,
                maxLength: 250,
                style: TextStyle(color: colors.primaryText, fontSize: 14),
                cursorColor: colors.primaryBlue,
                onChanged: (_) {
                  setState(() {});
                },
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add Context',
                  hintStyle: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 14,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: colors.inputSurface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colors.primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // TASK HEADER
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Assign Task into the Milestone at least 1',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),

                  OutlinedButton.icon(
                    onPressed: _generateAiTasks,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark
                          ? colors.elevatedSurface
                          : const Color(0xFFE8F1FC),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Color(0xFF2979FF),
                    ),
                    label: const Text(
                      'A.I Assistant',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2979FF),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==========================================
              // TASK LIST
              // ==========================================
              if (_tasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 32,
                        color: colors.secondaryText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No tasks added yet',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add at least one task to continue',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.disabledText,
                        ),
                      ),
                    ],
                  ),
                ),

              ..._tasks.asMap().entries.map((entry) {
                final index = entry.key;
                final task = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${index + 1}.  $task',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colors.primaryText,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          _editTask(index);
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Color(0xFF2979FF),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const SizedBox(width: 14),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            _tasks.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),

              // ==========================================
              // ADD TASK
              // ==========================================
              TextButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add, size: 16, color: Color(0xFF2979FF)),
                label: const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2979FF),
                  ),
                ),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
