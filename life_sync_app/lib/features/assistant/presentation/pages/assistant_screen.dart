import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

final class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

final class _AssistantScreenState extends State<AssistantScreen> {
  final _input = TextEditingController();
  final _messages = <String>[];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _submit([String? suggestion]) {
    final message = (suggestion ?? _input.text).trim();
    if (message.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _messages.add(message);
      _input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.2,
                  colors: [colors.glow, colors.pageBackground],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: Get.back<void>,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Settings',
                        onPressed: () => Get.toNamed<void>(AppRoutes.settings),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _messages.isEmpty
                      ? _AssistantEmpty(onSuggestion: _submit)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          itemCount: _messages.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.cardSurface,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(_messages[index]),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'The AI service is not connected in this build. '
                                'Your request was not sent anywhere.',
                                style: TextStyle(
                                  color: colors.secondaryText,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      MediaQuery.viewInsetsOf(context).bottom > 0 ? 8 : 14,
                    ),
                    child: TextField(
                      controller: _input,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _submit,
                      decoration: InputDecoration(
                        hintText: 'What can you help me with?',
                        prefixIcon: const Icon(Icons.add),
                        suffixIcon: IconButton(
                          tooltip: 'Send',
                          onPressed: _submit,
                          icon: Icon(
                            Icons.send_rounded,
                            color: colors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _AssistantEmpty extends StatelessWidget {
  const _AssistantEmpty({required this.onSuggestion});
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/lifesync_assistant.png',
            width: 92,
            height: 92,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'Let’s Get Things Done',
            style: TextStyle(color: colors.primaryBlue, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell me what you need, and I’ll help you take the next step.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.secondaryText, fontSize: 11),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ActionChip(
                label: const Text('Create Task'),
                avatar: const Icon(Icons.task_alt, size: 16),
                onPressed: () => Get.toNamed<void>(AppRoutes.taskEditor),
              ),
              ActionChip(
                label: const Text('Plan a Goal'),
                avatar: const Icon(Icons.track_changes, size: 16),
                onPressed: () => Get.toNamed<void>(AppRoutes.goalEditor),
              ),
              ActionChip(
                label: const Text('Quick Journal'),
                avatar: const Icon(Icons.edit_note, size: 16),
                onPressed: () => Get.toNamed<void>(AppRoutes.journalEditor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
