import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:life_sync_app/features/auth/presentation/validators/auth_validators.dart';

class SignUpVerifyEmailScreen extends StatefulWidget {
  const SignUpVerifyEmailScreen({super.key});

  @override
  State<SignUpVerifyEmailScreen> createState() =>
      _SignUpVerifyEmailScreenState();
}

class _SignUpVerifyEmailScreenState extends State<SignUpVerifyEmailScreen> {
  static const _fallbackResendCooldown = Duration(seconds: 60);

  final List<TextEditingController> _controllers = List.generate(
    AuthValidators.otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AuthValidators.otpLength,
    (_) => FocusNode(),
  );
  late final AuthFlowArguments _arguments;
  late final AuthController _authController;

  bool _isComplete = false;
  bool _hasError = false;
  int _resendSecondsRemaining = 0;
  int _gmailAttempts = 0;
  bool _usingTelegram = false;
  Timer? _resendTimer;

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
    _resendTimer?.cancel();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _checkCompletion() {
    final complete = AuthValidators.otp(_otp) == null;
    setState(() {
      _isComplete = complete;
      _hasError = false;
    });
    _authController.clearError();
  }

  void _setOtp(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _checkCompletion();
      return;
    }

    for (var i = 0; i < _controllers.length; i += 1) {
      _controllers[i].text = i < digits.length ? digits[i] : '';
    }

    final focusIndex = digits.length >= AuthValidators.otpLength
        ? AuthValidators.otpLength - 1
        : digits.length;
    FocusScope.of(context).requestFocus(_focusNodes[focusIndex]);
    _checkCompletion();
  }

  void _clearOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _isComplete = false;
      _hasError = false;
    });
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() {
      _resendSecondsRemaining = _fallbackResendCooldown.inSeconds;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() => _resendSecondsRemaining = 0);
        return;
      }
      setState(() => _resendSecondsRemaining -= 1);
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otp;
    final otpError = AuthValidators.otp(otp);
    if (otpError != null) {
      setState(() => _hasError = true);
      _authController.errorMessage.value = otpError;
      return;
    }

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

  Future<void> _resendOtp({String channel = 'email'}) async {
    if (_resendSecondsRemaining > 0 || _authController.isSubmitting.value) {
      return;
    }
    if (channel == 'email') setState(() => _gmailAttempts += 1);
    final sent = await _authController.resendOtp(
      _arguments.email,
      channel: channel,
    );
    if (!mounted) return;
    setState(() {});
    if (sent && mounted) {
      setState(() => _usingTelegram = channel == 'telegram');
      _clearOtp();
      _startResendCooldown();
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
                _usingTelegram
                    ? 'Check your linked Telegram chat for the latest 6-digit code.'
                    : 'Check $_maskedEmail for your latest 6-digit code, including Spam. Delivery may take a moment.',
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
                children: List.generate(AuthValidators.otpLength, (index) {
                  return SizedBox(
                    width: 44,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction: index == AuthValidators.otpLength - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          AuthValidators.otpLength,
                        ),
                      ],
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
                        if (value.length > 1) {
                          _setOtp(value);
                          return;
                        }
                        _controllers[index].text = value;
                        if (value.isNotEmpty &&
                            index < AuthValidators.otpLength - 1) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index - 1]);
                        }
                        _checkCompletion();
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
                    Obx(() {
                      final disabled =
                          _resendSecondsRemaining > 0 ||
                          _authController.isSubmitting.value;
                      return GestureDetector(
                        onTap: disabled ? null : () => _resendOtp(),
                        child: Text(
                          _resendSecondsRemaining > 0
                              ? 'Send Again ($_resendSecondsRemaining)'
                              : 'Send Again',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: disabled
                                ? Colors.grey
                                : const Color(0xFF2979FF),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (_gmailAttempts >= 3) ...[
                Obx(
                  () => TextButton(
                    onPressed:
                        _authController.isSubmitting.value ||
                            _resendSecondsRemaining > 0
                        ? null
                        : () => _resendOtp(channel: 'telegram'),
                    child: const Text('Try linked Telegram instead'),
                  ),
                ),
                const Text('Telegram must already be linked to your account.'),
              ],
              const SizedBox(height: 12),
              const Text(
                'Five incorrect codes temporarily block OTP attempts for 15 minutes.',
              ),
              const SizedBox(height: 28),

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
