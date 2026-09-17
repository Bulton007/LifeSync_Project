import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/theme/app_radius.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';
import 'package:life_sync_app/features/assistant/presentation/controllers/assistant_controller.dart';

final class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

final class _AssistantScreenState extends State<AssistantScreen> {
  late final AssistantController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AssistantController>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _showApiKeyDialog(BuildContext context) async {
    final currentKey = await _controller.getApiKey() ?? '';
    final textController = TextEditingController(text: currentKey);

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Row(
            children: [
              Icon(Icons.key_rounded, color: Color(0xFF4F7FFF)),
              SizedBox(width: 8),
              Text('Gemini API Key', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your Google Gemini API key to power intelligent responses. You can obtain a free key from Google AI Studio (aistudio.google.com).',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'API Key',
                    hintText: 'AIzaSy...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (currentKey.isNotEmpty)
              TextButton(
                onPressed: () async {
                  await _controller.clearApiKey();
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gemini API key cleared.')),
                    );
                  }
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final newKey = textController.text.trim();
                if (newKey.isNotEmpty) {
                  await _controller.saveApiKey(newKey);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gemini API key saved successfully!'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _submit([String? suggestion]) {
    FocusScope.of(context).unfocus();
    _controller.sendMessage(suggestion);
    _scrollToBottom();
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
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: Get.back<void>,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LifeSync AI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Google Gemini',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Obx(
                        () => IconButton(
                          tooltip: _controller.hasApiKey.value
                              ? 'Gemini API Key (Configured)'
                              : 'Configure Gemini API Key',
                          onPressed: () => _showApiKeyDialog(context),
                          icon: Badge(
                            isLabelVisible: !_controller.hasApiKey.value,
                            backgroundColor: Colors.amber,
                            smallSize: 8,
                            child: Icon(
                              Icons.key_rounded,
                              color: _controller.hasApiKey.value
                                  ? colors.primaryBlue
                                  : colors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Clear Chat',
                        onPressed: () {
                          _controller.clearConversation();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                      IconButton(
                        tooltip: 'Settings',
                        onPressed: () => Get.toNamed<void>(AppRoutes.settings),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Chat Messages or Empty State
                Expanded(
                  child: Obx(() {
                    final messages = _controller.messages;
                    final isLoading = _controller.isLoading.value;

                    if (messages.isEmpty && !isLoading) {
                      return _AssistantEmpty(
                        onSuggestion: (prompt) => _submit(prompt),
                        onConfigureKey: () => _showApiKeyDialog(context),
                        hasKey: _controller.hasApiKey.value,
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      itemCount: messages.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          // Thinking Indicator
                          return _ThinkingBubble(colors: colors);
                        }

                        final msg = messages[index];
                        if (msg.sender == MessageSender.user) {
                          return _UserBubble(message: msg, colors: colors);
                        } else {
                          return _AssistantBubble(
                            message: msg,
                            colors: colors,
                            onConfigureKey: () => _showApiKeyDialog(context),
                          );
                        }
                      },
                    );
                  }),
                ),

                // Bottom Input Bar
                SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      MediaQuery.viewInsetsOf(context).bottom > 0 ? 8 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.navigationSurface,
                      border: Border(
                        top: BorderSide(
                          color: colors.primaryText.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller.inputController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              hintText: 'What can I help you achieve?',
                              hintStyle: TextStyle(
                                color: colors.secondaryText,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                borderSide: BorderSide(
                                  color: colors.primaryText.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                borderSide: BorderSide(
                                  color: colors.primaryText.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                borderSide: BorderSide(
                                  color: colors.primaryBlue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          final loading = _controller.isLoading.value;
                          return Container(
                            decoration: BoxDecoration(
                              color: colors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              tooltip: 'Send',
                              onPressed: loading ? null : () => _submit(),
                              icon: loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          );
                        }),
                      ],
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

// ============================================================================
// EMPTY STATE
// ============================================================================

final class _AssistantEmpty extends StatelessWidget {
  const _AssistantEmpty({
    required this.onSuggestion,
    required this.onConfigureKey,
    required this.hasKey,
  });

  final ValueChanged<String> onSuggestion;
  final VoidCallback onConfigureKey;
  final bool hasKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // Mascot Avatar
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF779CFF).withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Image.asset(
              AppImages.assistantAvatar,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.smart_toy_rounded,
                size: 64,
                color: Color(0xFF4F7FFF),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Let’s Get Things Done',
            style: TextStyle(
              color: colors.primaryBlue,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me to plan your schedule, break down goals, or build healthy habits.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          if (!hasKey)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.key_outlined, color: Colors.amber, size: 22),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Gemini API key is required to activate AI responses.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: onConfigureKey,
                    child: const Text('Add Key'),
                  ),
                ],
              ),
            ),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Quick Prompts',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF79788C),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              _PromptChip(
                icon: Icons.checklist_rounded,
                label: 'Organize today\'s top 3 tasks',
                onTap: () => onSuggestion(
                  'Help me pick and organize my top 3 high-impact tasks for today with a time schedule.',
                ),
              ),
              _PromptChip(
                icon: Icons.track_changes_rounded,
                label: 'Break down a new goal',
                onTap: () => onSuggestion(
                  'How do I break down a major goal into actionable weekly milestones and daily actions?',
                ),
              ),
              _PromptChip(
                icon: Icons.eco_outlined,
                label: 'Build a consistent habit',
                onTap: () => onSuggestion(
                  'What are effective science-backed strategies to stick to a new habit every day?',
                ),
              ),
              _PromptChip(
                icon: Icons.edit_note_rounded,
                label: 'Evening reflection journal',
                onTap: () => onSuggestion(
                  'Give me 3 thoughtful journal prompts for an evening reflection session.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _PromptChip extends StatelessWidget {
  const _PromptChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.primaryText.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.primaryBlue),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: colors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CHAT BUBBLES
// ============================================================================

final class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message, required this.colors});
  final ChatMessage message;
  final LifeSyncColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.80,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.primaryBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({
    required this.message,
    required this.colors,
    required this.onConfigureKey,
  });

  final ChatMessage message;
  final LifeSyncColors colors;
  final VoidCallback onConfigureKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                AppImages.assistantAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.smart_toy_rounded,
                  size: 20,
                  color: Color(0xFF4F7FFF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: message.isError
                    ? Colors.red.withValues(alpha: 0.08)
                    : colors.cardSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(
                  color: message.isError
                      ? Colors.red.withValues(alpha: 0.3)
                      : colors.primaryText.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.text,
                    style: TextStyle(
                      color: message.isError ? Colors.red.shade800 : colors.primaryText,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  if (message.isError && message.text.contains('Gemini API key')) ...[
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      onPressed: onConfigureKey,
                      icon: const Icon(Icons.key_rounded, size: 16),
                      label: const Text('Configure Gemini Key'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble({required this.colors});
  final LifeSyncColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(
                AppImages.assistantAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.smart_toy_rounded,
                  size: 20,
                  color: Color(0xFF4F7FFF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.primaryText.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F7FFF)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'LifeSync AI is thinking...',
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 12.5,
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
