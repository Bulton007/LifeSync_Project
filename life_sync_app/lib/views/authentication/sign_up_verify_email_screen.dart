import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';

class SignUpVerifyEmailScreen extends StatefulWidget {
  const SignUpVerifyEmailScreen({super.key});

  @override
  State<SignUpVerifyEmailScreen> createState() =>
      _SignUpVerifyEmailScreenState();
}

class _SignUpVerifyEmailScreenState extends State<SignUpVerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late final AuthFlowArguments _arguments;
  late final AuthController _authController;

  bool _isComplete = false;
  bool _hasError = false;

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

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkCompletion() {
    bool complete = _controllers.every((c) => c.text.isNotEmpty);
    setState(() {
      _isComplete = complete;
      _hasError = false; // Reset error on new typing
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();

    if (_arguments.purpose == AuthFlowPurpose.passwordReset) {
      await Get.toNamed<void>(
        AppRoutes.createPassword,
        arguments: _arguments.copyWith(otpCode: otp),
      );
      return;
    }

    final verified = await _authController.verifyOtp(
      email: _arguments.email,
      otpCode: otp,
    );
    if (!mounted) return;
    setState(() => _hasError = !verified);
    if (verified) {
      await Get.offAllNamed<void>(AppRoutes.createdSuccess);
    }
  }

  Future<void> _resendOtp() async {
    final sent = await _authController.resendOtp(_arguments.email);
    if (sent && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A new verification code was sent.')),
      );
    }
  }

  String get _maskedEmail {
    final parts = _arguments.email.split('@');
    if (parts.length != 2) return _arguments.email;
    final local = parts.first;
    final visible = local.length <= 2
        ? local.substring(0, 1)
        : local.substring(0, 2);
    return '$visible***@${parts.last}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),

              // Header Title
              const Text(
                'Verify your Email',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                ),
              ),
              const SizedBox(height: 8),

              // Instructions Subtitle
              Text(
                'We have sent a 6-digit OTP code to $_maskedEmail,\nCheck it and fill it below to verify your Email.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Error Message (shown only when wrong OTP is entered)
              if (_hasError || _authController.errorMessage.value != null) ...[
                Obx(
                  () => Text(
                    _authController.errorMessage.value ??
                        'Incorrect OTP! Check it and fill it in again.',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 6-Digit OTP Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _hasError
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _hasError
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _hasError
                                ? Colors.red
                                : const Color(0xFF2979FF),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _checkCompletion();
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Didn't receive code / Send Again Prompt
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Didn't receive the Code? ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: _resendOtp,
                      child: const Text(
                        'Send Again',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2979FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Verify Action Button (Blue when active, Grey when incomplete)
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        _isComplete && !_authController.isSubmitting.value
                        ? _verifyOtp
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      disabledBackgroundColor: const Color(0xFFE0E0E0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _isComplete ? 2 : 0,
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
                            'Verify',
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
    );
  }
}
