import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MilestoneDraft {
  const MilestoneDraft(this.title, this.date);
  final String title;
  final DateTime date;
}

class MilestoneEditorSheet extends StatefulWidget {
  const MilestoneEditorSheet({
    super.key,
    required this.original,
    required this.firstDate,
    required this.lastDate,
  });
  final MilestoneDraft? original;
  final DateTime firstDate;
  final DateTime lastDate;
  @override
  State<MilestoneEditorSheet> createState() => _MilestoneEditorSheetState();
}

class _MilestoneEditorSheetState extends State<MilestoneEditorSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.original?.title ?? '',
  );
  final _form = GlobalKey<FormState>();
  late DateTime _date = _initialDate();
  DateTime _initialDate() {
    final original = widget.original?.date ?? widget.lastDate;
    return original.isBefore(widget.firstDate)
        ? widget.firstDate
        : original.isAfter(widget.lastDate)
        ? widget.lastDate
        : original;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    (widget.original == null
                            ? 'Add Milestone'
                            : 'Edit milestone')
                        .tr,
                  ),
                ),
                OutlinedButton(
                  key: const ValueKey('save-draft-milestone'),
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      Navigator.pop(
                        context,
                        MilestoneDraft(_title.text.trim(), _date),
                      );
                    }
                  },
                  child: Text('Save'.tr),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const ValueKey('milestone-title'),
              controller: _title,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: 'Milestone Name'.tr,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Milestone title is required.'.tr
                  : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text('Deadline'.tr),
              subtitle: Text(
                MaterialLocalizations.of(context).formatMediumDate(_date),
              ),
              onTap: () async {
                final initial = _date.isBefore(widget.firstDate)
                    ? widget.firstDate
                    : _date.isAfter(widget.lastDate)
                    ? widget.lastDate
                    : _date;
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                );
                if (picked != null && mounted) setState(() => _date = picked);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
