import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:life_sync_app/features/auth/presentation/validators/auth_validators.dart';

class FillNameScreen extends StatefulWidget {
  const FillNameScreen({super.key});

  @override
  State<FillNameScreen> createState() => _FillNameScreenState();
}

class _FillNameScreenState extends State<FillNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AuthFlowArguments _arguments;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _arguments = Get.arguments is AuthFlowArguments
        ? Get.arguments as AuthFlowArguments
        : const AuthFlowArguments(
            email: '',
            purpose: AuthFlowPurpose.registration,
          );
    _authController = Get.find<AuthController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _authController.clearError();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final registered = await _authController.register(
      fullName: _nameController.text.trim(),
      email: _arguments.email,
      password: _arguments.password!,
    );
    if (registered) {
      await Get.toNamed<void>(AppRoutes.verifyEmail, arguments: _arguments);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Hello Dana Illustration from Life-Sync SVG File (Hello.svg)
                SvgPicture.asset(
                  LifeSyncSvgAssets.hello,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Question Heading
                const Text(
                  'Hello! What should we call you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2979FF),
                  ),
                ),
                const SizedBox(height: 24),

                // Name Input Field
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  onFieldSubmitted: (_) => _submit(),
                  validator: AuthValidators.fullName,
                  decoration: InputDecoration(
                    hintText: 'Your Name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF2979FF),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  final message = _authController.errorMessage.value;
                  if (message == null) return const SizedBox(height: 32);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  );
                }),

                // Next Action Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: _authController.isSubmitting.value
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2979FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: _authController.isSubmitting.value
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
