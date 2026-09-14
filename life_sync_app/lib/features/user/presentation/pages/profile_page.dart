import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/settings/presentation/widgets/settings_layout.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';
import 'package:life_sync_app/features/user/presentation/pages/telegram_link_page.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;
  String? _name;
  String? _email;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProfileController>();
  }

  void _notice(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _edit(String field, String initial) async {
    final form = GlobalKey<FormState>();
    String value = initial;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit $field'),
        content: Form(
          key: form,
          child: TextFormField(
            initialValue: initial,
            autofocus: true,
            keyboardType: field == 'Email'
                ? TextInputType.emailAddress
                : field == 'Phone'
                ? TextInputType.phone
                : TextInputType.name,
            decoration: InputDecoration(labelText: field),
            onChanged: (text) => value = text.trim(),
            validator: (text) {
              final input = text?.trim() ?? '';
              if (field == 'Name' && (input.isEmpty || input.length > 100)) {
                return 'Enter a name of 1–100 characters.';
              }
              if (field == 'Email' && !GetUtils.isEmail(input)) {
                return 'Enter a valid email address.';
              }
              if (field == 'Phone' &&
                  input.isNotEmpty &&
                  !RegExp(r'^[0-9]{8,15}$').hasMatch(input)) {
                return 'Enter 8–15 digits.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (field == 'Name') _name = result;
      if (field == 'Email') _email = result;
      if (field == 'Phone') _phone = result;
    });
  }

  Future<void> _save() async {
    final profile = _controller.state.value.data;
    if (profile == null) return;
    final saved = await _controller.updateProfile(
      fullName: _name ?? profile.fullName,
      email: _email ?? profile.email,
      phoneNumber: _phone ?? profile.phoneNumber,
    );
    if (saved && mounted) {
      setState(() {
        _name = null;
        _email = null;
        _phone = null;
      });
      _notice('Profile updated successfully.');
    }
  }

  Future<void> _avatar() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Choose photo'),
              leading: const Icon(Icons.photo_library_outlined),
              onTap: () => Navigator.pop(context, 'choose'),
            ),
            if (_controller.imageBytes.value != null)
              ListTile(
                title: const Text('Remove photo'),
                leading: const Icon(Icons.delete_outline),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (choice == 'choose') await _controller.pickAndUploadImage();
    if (choice == 'remove') await _controller.deleteImage();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final state = _controller.state.value;
    final profile = state.data;
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: state.isBusy
            ? const AppLoadingView(message: 'Loading your profile…')
            : AppErrorView(
                message: state.exception?.message ?? 'Profile unavailable.',
                onRetry: _controller.loadProfile,
              ),
      );
    }
    return ProfileLayout(
      name: _name ?? profile.fullName,
      email: _email ?? profile.email,
      avatar: _controller.imageBytes.value,
      error: _controller.errorMessage.value,
      onClose: () => Navigator.of(context).maybePop(),
      onSave: _controller.isSubmitting.value ? null : _save,
      onAvatar: () {
        if (!_controller.isSubmitting.value) _avatar();
      },
      onName: () => _edit('Name', _name ?? profile.fullName),
      onEmail: () => _edit('Email', _email ?? profile.email),
      onPassword: () => Get.toNamed<void>(AppRoutes.changePassword),
      onProvider: (provider) =>
          _notice('$provider account linking is not available yet.'),
      onDelete: () => _notice(
        'Account deletion is not supported by the current API. No data was deleted.',
      ),
      extra: ExpansionTile(
        title: const Text(
          'More account options',
          style: TextStyle(fontSize: 13),
        ),
        children: [
          ListTile(
            title: const Text('Phone number'),
            subtitle: Text(_phone ?? profile.phoneNumber ?? 'Not set'),
            onTap: () => _edit('Phone', _phone ?? profile.phoneNumber ?? ''),
          ),
          ListTile(
            title: const Text('Link Telegram'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const TelegramLinkPage()),
            ),
          ),
          ListTile(
            title: const Text('Personal progress'),
            onTap: () => Get.toNamed<void>(AppRoutes.personalProgress),
          ),
        ],
      ),
    );
  });
}
