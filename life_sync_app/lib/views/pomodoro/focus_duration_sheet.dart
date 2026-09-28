import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FocusDurationSheet extends StatefulWidget {
  const FocusDurationSheet({required this.initialMinutes, super.key});
  final int initialMinutes;
  @override
  State<FocusDurationSheet> createState() => _FocusDurationSheetState();
}

class _FocusDurationSheetState extends State<FocusDurationSheet> {
  final _form = GlobalKey<FormState>();
  late final _input = TextEditingController(text: '${widget.initialMinutes}');
  @override
  void dispose() {
    _input.dispose();
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
            Text(
              'Focus duration'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('focus-duration-input'),
              controller: _input,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Minutes (1–180)'.tr),
              validator: (value) {
                final number = int.tryParse(value ?? '');
                return number == null || number < 1 || number > 180
                    ? 'Enter 1 to 180 minutes.'.tr
                    : null;
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [5, 15, 25, 45, 60]
                  .map(
                    (minutes) => ActionChip(
                      label: Text('$minutes'),
                      onPressed: () => _input.text = '$minutes',
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('save-focus-duration'),
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    Navigator.pop(context, int.parse(_input.text));
                  }
                },
                child: Text('Save'.tr),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
