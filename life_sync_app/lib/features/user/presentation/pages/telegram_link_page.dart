import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_client.dart';

class TelegramLinkPage extends StatefulWidget {
  const TelegramLinkPage({super.key});

  @override
  State<TelegramLinkPage> createState() => _TelegramLinkPageState();
}

class _TelegramLinkPageState extends State<TelegramLinkPage> {
  final _chat = TextEditingController();
  final _code = TextEditingController();
  bool _sent = false;
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _chat.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = (_sent ? _code : _chat).text.trim();
    final valid = RegExp(
      _sent ? r'^\d{6}$' : r'^[1-9]\d{0,18}$',
    ).hasMatch(value);
    if (!valid) {
      setState(
        () => _message = _sent
            ? 'Enter the six-digit Telegram code.'
            : 'Enter your private Telegram chat ID.',
      );
      return;
    }
    setState(() => _busy = true);
    final result = await Get.find<ApiClient>().post<String>(
      _sent ? '/api/auth/telegram/confirm' : '/api/auth/telegram/link',
      data: {_sent ? 'otpCode' : 'chatId': value},
      decoder: (data) => data as String,
    );
    if (!mounted) return;
    result.when(
      success: (message) {
        if (_sent) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        } else {
          setState(() {
            _sent = true;
            _message = message;
          });
        }
      },
      failure: (error) => setState(() => _message = error.message),
    );
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Link Telegram')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Start a private chat with the LifeSync bot first. Link Telegram here to use it for future password recovery when Gmail does not arrive.',
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _sent ? _code : _chat,
          enabled: !_busy,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: _sent
                ? 'Telegram verification code'
                : 'Your private Telegram chat ID',
          ),
        ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(_message!),
          ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(
            _busy
                ? 'Please wait…'
                : _sent
                ? 'Confirm link'
                : 'Send linking code',
          ),
        ),
      ],
    ),
  );
}
