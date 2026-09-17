import 'package:get/get.dart';

abstract final class AuthValidators {
  static const otpLength = 6;
  static const passwordMinLength = 8;
  static const passwordMaxLength = 100;
  static const fullNameMaxLength = 100;

  static String? email(String? value) {
    final email = normalizeEmail(value);
    if (email.isEmpty) return 'Email is required.';
    if (!GetUtils.isEmail(email)) return 'Enter a valid email address.';
    return null;
  }

  static String normalizeEmail(String? value) =>
      (value ?? '').trim().toLowerCase();

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required.';
    if (password.length < passwordMinLength) {
      return 'Password must contain at least $passwordMinLength characters.';
    }
    if (password.length > passwordMaxLength) {
      return 'Password must not exceed $passwordMaxLength characters.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final passwordError = AuthValidators.password(value);
    if (passwordError != null) return passwordError;
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  static String? fullName(String? value) {
    final name = (value ?? '').trim();
    if (name.isEmpty) return 'Full name is required.';
    if (name.length > fullNameMaxLength) {
      return 'Full name must not exceed $fullNameMaxLength characters.';
    }
    return null;
  }

  static String? otp(String value) {
    if (value.isEmpty) return 'OTP is required.';
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only digits.';
    }
    if (value.length != otpLength) {
      return 'OTP must contain exactly $otpLength digits.';
    }
    return null;
  }
}
