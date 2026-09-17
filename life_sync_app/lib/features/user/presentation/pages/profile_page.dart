import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
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
    final colors = context.lifeSyncColors;
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

    final cardBgColor = colors.cardSurface;
    final avatarBytes = _controller.imageBytes.value;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Top App Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.elevatedSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: colors.primaryText,
                    ),
                  ),
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _controller.isSubmitting.value ? null : _save,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.elevatedSurface,
                      shape: BoxShape.circle,
                    ),
                    child: _controller.isSubmitting.value
                        ? const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Icon(
                            Icons.check_rounded,
                            size: 22,
                            color: colors.primaryText,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile Fields Section
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Avatar Row
                  InkWell(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    onTap: () {
                      if (!_controller.isSubmitting.value) _avatar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Avatar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colors.primaryText,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: colors.elevatedSurface,
                            backgroundImage: avatarBytes != null
                                ? MemoryImage(avatarBytes)
                                : null,
                            child: avatarBytes == null
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 20,
                                    color: colors.secondaryText,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ProfileOptionRow(
                    title: 'Name',
                    value: _name ?? profile.fullName,
                    onTap: () => _edit('Name', _name ?? profile.fullName),
                  ),
                  _ProfileOptionRow(
                    title: 'Email',
                    value: _email ?? profile.email,
                    onTap: () => _edit('Email', _email ?? profile.email),
                  ),
                  _ProfileOptionRow(
                    title: 'Change Password',
                    isLast: true,
                    onTap: () => Get.toNamed<void>(AppRoutes.changePassword),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Third Party Connection Header
            Text(
              'Third Party Connection',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 12),

            // Third Party Connection Section
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _ConnectedAccountRow(
                    iconWidget: const Icon(
                      Icons.facebook,
                      color: Color(0xFF1877F2),
                      size: 24,
                    ),
                    title: 'Facebook',
                    status: 'Not Linked',
                    onTap: () => _notice(
                      'Facebook account linking is not available yet.',
                    ),
                  ),
                  _ConnectedAccountRow(
                    iconWidget: const _GoogleIcon(),
                    title: 'Google',
                    status: 'Not Linked',
                    onTap: () =>
                        _notice('Google account linking is not available yet.'),
                  ),
                  _ConnectedAccountRow(
                    iconWidget: Icon(
                      Icons.apple,
                      color: colors.primaryText,
                      size: 24,
                    ),
                    title: 'Apple',
                    status: 'Not Linked',
                    isLast: true,
                    onTap: () =>
                        _notice('Apple account linking is not available yet.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delete Account Tile
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _notice(
                'Account deletion is not supported by the current API. No data was deleted.',
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444),
                      size: 22,
                    ),
                    SizedBox(width: 14),
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // More account options
            ExpansionTile(
              title: Text(
                'More account options',
                style: TextStyle(fontSize: 13, color: colors.primaryText),
              ),
              iconColor: colors.primaryBlue,
              collapsedIconColor: colors.secondaryText,
              children: [
                ListTile(
                  title: Text(
                    'Phone number',
                    style: TextStyle(color: colors.primaryText),
                  ),
                  subtitle: Text(
                    _phone ?? profile.phoneNumber ?? 'Not set',
                    style: TextStyle(color: colors.secondaryText),
                  ),
                  onTap: () =>
                      _edit('Phone', _phone ?? profile.phoneNumber ?? ''),
                ),
                ListTile(
                  title: Text(
                    'Link Telegram',
                    style: TextStyle(color: colors.primaryText),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.secondaryText,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const TelegramLinkPage(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Personal progress',
                    style: TextStyle(color: colors.primaryText),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.secondaryText,
                  ),
                  onTap: () => Get.toNamed<void>(AppRoutes.personalProgress),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  });
}

class _ProfileOptionRow extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback onTap;
  final bool isLast;

  const _ProfileOptionRow({
    required this.title,
    this.value,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return InkWell(
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(20))
          : BorderRadius.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryText,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: TextStyle(fontSize: 14, color: colors.secondaryText),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectedAccountRow extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String status;
  final VoidCallback onTap;
  final bool isLast;

  const _ConnectedAccountRow({
    required this.iconWidget,
    required this.title,
    required this.status,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return InkWell(
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(20))
          : BorderRadius.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(width: 26, height: 26, child: Center(child: iconWidget)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryText,
                ),
              ),
            ),
            Text(
              status,
              style: TextStyle(fontSize: 14, color: colors.secondaryText),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }
}
