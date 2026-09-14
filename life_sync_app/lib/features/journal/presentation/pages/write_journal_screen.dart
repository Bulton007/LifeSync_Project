import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';

final class WriteJournalScreen extends StatefulWidget {
  const WriteJournalScreen({super.key});

  @override
  State<WriteJournalScreen> createState() => _WriteJournalScreenState();
}

final class _WriteJournalScreenState extends State<WriteJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  late final JournalController _controller;
  late DateTime _date;
  JournalEntry? _original;
  final _tags = <String>[];
  final _attachments = <String>[];
  bool _dirty = false;
  bool _forcePop = false;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<JournalController>();
    _original = Get.arguments is JournalEntry
        ? Get.arguments as JournalEntry
        : null;
    _date =
        _original?.createdAt ??
        _withCurrentTime(_controller.selectedDate.value);
    _titleController.text = _original?.title ?? '';
    _bodyController.text = _original?.body ?? '';
    _tags.addAll(_original?.tags ?? const []);
    _attachments.addAll(_original?.attachments ?? const []);
    _titleController.addListener(_markDirty);
    _bodyController.addListener(_markDirty);
  }

  DateTime _withCurrentTime(DateTime day) {
    final now = DateTime.now();
    return DateTime(day.year, day.month, day.day, now.hour, now.minute);
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('Your unsaved journal changes will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep editing'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _requestPop() async {
    if (!await _confirmDiscard() || !mounted) return;
    setState(() => _forcePop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final saved = await _controller.save(
      JournalEntry(
        id: _original?.id,
        title: _titleController.text,
        body: _bodyController.text,
        tags: List.unmodifiable(_tags),
        attachments: List.unmodifiable(_attachments),
        createdAt: _original?.createdAt ?? _date,
        updatedAt: now,
      ),
    );
    if (!saved || !mounted) return;
    setState(() {
      _dirty = false;
      _forcePop = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _delete() async {
    final entry = _original;
    if (entry == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete journal entry?'),
        content: const Text('This local journal entry cannot be recovered.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await _controller.delete(entry);
    if (!deleted || !mounted) return;
    setState(() => _forcePop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _date.hour,
        _date.minute,
      );
      _dirty = true;
    });
  }

  Future<void> _addTag() async {
    final input = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add tag'),
        content: TextField(
          controller: input,
          autofocus: true,
          maxLength: 30,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'e.g. Holiday'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    input.dispose();
    final normalized = value?.trim();
    if (normalized == null ||
        normalized.isEmpty ||
        _tags.contains(normalized)) {
      return;
    }
    setState(() {
      _tags.add(normalized);
      _dirty = true;
    });
  }

  Future<void> _pickImage() async {
    if (_attachments.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can attach up to three images.')),
      );
      return;
    }
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      imageQuality: 78,
      requestFullMetadata: false,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _attachments.add(base64Encode(bytes));
      _dirty = true;
    });
  }

  void _insertPrefix(String prefix) {
    final selection = _bodyController.selection;
    final start = selection.isValid
        ? selection.start
        : _bodyController.text.length;
    _bodyController.value = _bodyController.value.copyWith(
      text: _bodyController.text.replaceRange(start, start, prefix),
      selection: TextSelection.collapsed(offset: start + prefix.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return PopScope(
      canPop: _forcePop || !_dirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _requestPop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.viewInsetsOf(context).bottom + 28,
              ),
              children: [
                Row(
                  children: [
                    Material(
                      color: colors.navigationSelected,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Back',
                        onPressed: _requestPop,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                    ),
                    const Spacer(),
                    if (_original != null)
                      IconButton(
                        tooltip: 'Delete entry',
                        onPressed: _delete,
                        icon: Icon(
                          Icons.delete_outline,
                          color: colors.negative,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Obx(
                      () => OutlinedButton.icon(
                        onPressed: _controller.isSubmitting.value
                            ? null
                            : _save,
                        icon: _controller.isSubmitting.value
                            ? const SizedBox.square(
                                dimension: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check, size: 16),
                        label: const Text('Done'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ActionChip(
                      avatar: Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: colors.primaryBlue,
                      ),
                      label: Text(
                        '${_weekdays[_date.weekday - 1]} | '
                        '${_months[_date.month - 1]} '
                        '${_date.day.toString().padLeft(2, '0')}, ${_date.year}',
                      ),
                      onPressed: _chooseDate,
                    ),
                    ..._tags.map(
                      (tag) => InputChip(
                        label: Text('# $tag'),
                        onDeleted: () => setState(() {
                          _tags.remove(tag);
                          _dirty = true;
                        }),
                      ),
                    ),
                    ActionChip(
                      avatar: Icon(
                        Icons.label_outline,
                        size: 15,
                        color: colors.primaryBlue,
                      ),
                      label: const Text('Add Tag'),
                      onPressed: _addTag,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _titleController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Give this memory a title',
                  ),
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'A title is required.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.inputSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _bodyController,
                        minLines: 8,
                        maxLines: 16,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          filled: false,
                          hintText: 'Write your story here',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (value) => (value?.trim().isEmpty ?? true)
                            ? 'Write something before saving.'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Bulleted list',
                            onPressed: () => _insertPrefix('• '),
                            icon: const Icon(Icons.format_list_bulleted),
                          ),
                          IconButton(
                            tooltip: 'Numbered list',
                            onPressed: () => _insertPrefix('1. '),
                            icon: const Icon(Icons.format_list_numbered),
                          ),
                          IconButton(
                            tooltip: 'Insert emphasis markers',
                            onPressed: () => _insertPrefix('**'),
                            icon: const Icon(Icons.format_bold),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Attach image',
                            onPressed: _pickImage,
                            icon: const Icon(Icons.image_outlined),
                          ),
                          const Tooltip(
                            message:
                                'Voice recording is unavailable in this build.',
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.mic_none_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_attachments.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _attachments.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              base64Decode(_attachments[index]),
                              width: 112,
                              height: 92,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: IconButton.filledTonal(
                              tooltip: 'Remove image',
                              visualDensity: VisualDensity.compact,
                              onPressed: () => setState(() {
                                _attachments.removeAt(index);
                                _dirty = true;
                              }),
                              icon: const Icon(Icons.close, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                Obx(() {
                  final error = _controller.errorMessage.value;
                  return error == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            error,
                            style: TextStyle(color: colors.negative),
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
}
