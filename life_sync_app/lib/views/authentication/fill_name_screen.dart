import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';

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
      fullName: _nameController.text,
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

                // Illustration / Graphic Placeholder Container
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Simulated Illustration elements
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2979FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'HELLO\nDana',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 16,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.waving_hand_rounded,
                              color: Colors.orangeAccent,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Welcome!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  validator: (value) {
                    final name = value?.trim() ?? '';
                    if (name.isEmpty) return 'Full name is required.';
                    if (name.length > 100) {
                      return 'Full name must not exceed 100 characters.';
                    }
                    return null;
                  },
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
