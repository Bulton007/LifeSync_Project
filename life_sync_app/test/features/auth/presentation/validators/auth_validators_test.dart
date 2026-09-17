import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/auth/presentation/validators/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    test('accepts valid email addresses including Gmail', () {
      expect(AuthValidators.email('person@example.com'), isNull);
      expect(AuthValidators.email('person@gmail.com'), isNull);
    });

    test('rejects empty and invalid email addresses', () {
      expect(AuthValidators.email(''), 'Email is required.');
      expect(
        AuthValidators.email('not-an-email'),
        'Enter a valid email address.',
      );
    });

    test('normalizes email casing and whitespace', () {
      expect(
        AuthValidators.normalizeEmail('  Person.Name@GMAIL.com  '),
        'person.name@gmail.com',
      );
    });

    test('validates password length rules', () {
      expect(AuthValidators.password(''), 'Password is required.');
      expect(
        AuthValidators.password('short'),
        'Password must contain at least 8 characters.',
      );
      expect(AuthValidators.password('Test123456'), isNull);
      expect(
        AuthValidators.password(List.filled(101, 'a').join()),
        'Password must not exceed 100 characters.',
      );
    });

    test('validates password confirmation', () {
      expect(
        AuthValidators.confirmPassword('Test123456', 'Test123456'),
        isNull,
      );
      expect(
        AuthValidators.confirmPassword('Test123457', 'Test123456'),
        'Passwords do not match.',
      );
    });

    test('validates required full name and max length', () {
      expect(AuthValidators.fullName(' Codex Tester '), isNull);
      expect(AuthValidators.fullName('  '), 'Full name is required.');
      expect(
        AuthValidators.fullName(List.filled(101, 'a').join()),
        'Full name must not exceed 100 characters.',
      );
    });

    test('validates OTP format and exact backend length', () {
      expect(AuthValidators.otp('123456'), isNull);
      expect(AuthValidators.otp(''), 'OTP is required.');
      expect(AuthValidators.otp('12345'), 'OTP must contain exactly 6 digits.');
      expect(
        AuthValidators.otp('1234567'),
        'OTP must contain exactly 6 digits.',
      );
      expect(AuthValidators.otp('12a456'), 'OTP must contain only digits.');
    });
  });
}
