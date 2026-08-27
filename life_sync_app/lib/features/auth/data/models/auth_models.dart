final class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );
  }

  final String accessToken;
  final String tokenType;
  final int userId;
  final String fullName;
  final String email;
}

enum AuthFlowPurpose { registration, passwordReset }

final class AuthFlowArguments {
  const AuthFlowArguments({
    required this.email,
    required this.purpose,
    this.password,
    this.otpCode,
  });

  final String email;
  final AuthFlowPurpose purpose;
  final String? password;
  final String? otpCode;

  AuthFlowArguments copyWith({String? password, String? otpCode}) {
    return AuthFlowArguments(
      email: email,
      purpose: purpose,
      password: password ?? this.password,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
