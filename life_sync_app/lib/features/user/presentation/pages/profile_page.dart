import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_spacing.dart';
import 'package:life_sync_app/core/theme/app_text_styles.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  late final ProfileController _controller;
  Worker? _profileWorker;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProfileController>();
    _profileWorker = ever(_controller.state, (state) {
      final profile = state.data;
      if (profile != null) _fillForm(profile);
    });
    final current = _controller.state.value.data;
    if (current != null) _fillForm(current);
  }

  void _fillForm(UserProfileModel profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _profileWorker?.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await _controller.updateProfile(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
    );
    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    }
  }

  Future<void> _deleteImage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove profile image?'),
        content: const Text('Your current profile image will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _controller.deleteImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final state = _controller.state.value;
        if (state.data == null && state.isBusy) {
          return const AppLoadingView(message: 'Loading your profile…');
        }
        if (state.data == null && state.exception != null) {
          return AppErrorView(
            message: state.exception!.message,
            onRetry: _controller.loadProfile,
          );
        }

        final profile = state.data;
        if (profile == null) {
          return const AppErrorView(message: 'Profile data is unavailable.');
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadProfile(refresh: true),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final bytes = _controller.imageBytes.value;
                      return CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary100,
                        backgroundImage: bytes == null
                            ? null
                            : MemoryImage(bytes),
                        child: bytes == null
                            ? const Icon(
                                Icons.person_outline_rounded,
                                size: 48,
                                color: AppColors.primary700,
                              )
                            : null,
                      );
                    }),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: IconButton.filled(
                        tooltip: 'Choose profile image',
                        onPressed: _controller.isSubmitting.value
                            ? null
                            : _controller.pickAndUploadImage,
                        icon: const Icon(Icons.photo_library_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    profile.verified
                        ? Icons.verified_rounded
                        : Icons.info_outline_rounded,
                    size: 18,
                    color: profile.verified
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    profile.verified ? 'Email verified' : 'Email not verified',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              if (profile.profileImage != null) ...[
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _controller.isSubmitting.value
                      ? null
                      : _deleteImage,
                  child: const Text('Remove profile image'),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) {
                        final name = value?.trim() ?? '';
                        if (name.isEmpty) return 'Full name is required.';
                        if (name.length > 100) {
                          return 'Full name must not exceed 100 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Email is required.';
                        if (!GetUtils.isEmail(email)) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number (optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';
                        if (phone.isNotEmpty &&
                            !RegExp(r'^[0-9]{8,15}$').hasMatch(phone)) {
                          return 'Phone number must contain 8–15 digits.';
                        }
                        return null;
                      },
                    ),
                    Obx(() {
                      final message = _controller.errorMessage.value;
                      if (message == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: Text(
                          message,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.xl),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _controller.isSubmitting.value
                              ? null
                              : _save,
                          child: _controller.isSubmitting.value
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save changes'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.insights_outlined),
                      title: const Text('Personal progress'),
                      subtitle: const Text(
                        'Check-ins, reviews, wins and rewards',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () =>
                          Get.toNamed<void>(AppRoutes.personalProgress),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.lock_outline_rounded),
                      title: const Text('Change password'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed<void>(AppRoutes.changePassword),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                      ),
                      title: const Text('Log out'),
                      onTap: () => Get.find<AuthController>().logout(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      }),
    );
  }
}
