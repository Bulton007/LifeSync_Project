import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';

class AddTodoFullScreen extends StatefulWidget {
  const AddTodoFullScreen({super.key});

  @override
  State<AddTodoFullScreen> createState() => _AddTodoFullScreenState();
}

class _AddTodoFullScreenState extends State<AddTodoFullScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final TaskController _taskController;
  late final TaskModel? _editingTask;
  late DateTime _dueDate;
  late TaskPriority _priority;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _taskController = Get.find<TaskController>();
    _editingTask = Get.arguments is TaskModel
        ? Get.arguments as TaskModel
        : null;
    final task = _editingTask;
    final requestedDate = Get.arguments is DateTime
        ? Get.arguments as DateTime
        : null;
    _dueDate = task?.dueDate ?? requestedDate ?? DateTime.now();
    _priority = task?.priority ?? TaskPriority.normal;
    _status = task?.status ?? TaskStatus.pending;
    _titleController.text = task?.title ?? '';
    _descriptionController.text = task?.description ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _taskController.errorMessage.value = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final task = _editingTask;
    final saved = task == null
        ? await _taskController.createTask(
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _dueDate,
            priority: _priority,
          )
        : await _taskController.updateTask(
            task: task,
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _dueDate,
            priority: _priority,
            status: _status,
          );
    if (saved) Get.back<void>();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _dueDate = selected);
  }

  Future<void> _pickPriority() async {
    final selected = await _pickOption<TaskPriority>(
      TaskPriority.values,
      _priority,
      _priorityLabel,
      Icons.flag_outlined,
    );
    if (selected != null) setState(() => _priority = selected);
  }

  Future<void> _pickStatus() async {
    final selected = await _pickOption<TaskStatus>(
      TaskStatus.values,
      _status,
      _statusLabel,
      Icons.fact_check_outlined,
    );
    if (selected != null) setState(() => _status = selected);
  }

  Future<T?> _pickOption<T>(
    List<T> values,
    T selected,
    String Function(T) label,
    IconData icon,
  ) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final value in values)
              ListTile(
                leading: Icon(icon),
                title: Text(label(value)),
                trailing: value == selected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, value),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Obx(
                      () => OutlinedButton.icon(
                        onPressed: _taskController.isSubmitting.value
                            ? null
                            : _submit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        icon: _taskController.isSubmitting.value
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.check,
                                size: 16,
                                color: AppColors.primary,
                              ),
                        label: const Text(
                          'Save',
                          style: TextStyle(
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
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _metaChip(
                      Icons.calendar_today_outlined,
                      '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                      AppColors.primary,
                      _pickDate,
                    ),
                    _metaChip(
                      Icons.flag_outlined,
                      _priorityLabel(_priority),
                      Colors.black87,
                      _pickPriority,
                      arrow: true,
                    ),
                    if (_editingTask != null)
                      _metaChip(
                        Icons.fact_check_outlined,
                        _statusLabel(_status),
                        Colors.black87,
                        _pickStatus,
                        arrow: true,
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What do you need to get done today?',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Task title is required.';
                    if (title.length > 200) {
                      return 'Task title must not exceed 200 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Add Description',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) => (value?.length ?? 0) > 1000
                      ? 'Description must not exceed 1000 characters.'
                      : null,
                ),
                Obx(() {
                  final message = _taskController.errorMessage.value;
                  if (message == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metaChip(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap, {
    bool arrow = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (arrow) ...[
              const SizedBox(width: 4),
              const Icon(Icons.unfold_more, size: 14, color: Colors.grey),
            ],
          ],
        ),
      ),
    );
  }

  static String _priorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Low',
      TaskPriority.normal => 'Normal',
      TaskPriority.high => 'High',
      TaskPriority.urgent => 'Urgent',
    };
  }

  static String _statusLabel(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => 'Pending',
      TaskStatus.inProgress => 'In progress',
      TaskStatus.completed => 'Completed',
    };
  }
}
