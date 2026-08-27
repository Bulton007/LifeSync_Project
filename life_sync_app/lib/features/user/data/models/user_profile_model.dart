final class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.verified,
    required this.createdAt,
    this.phoneNumber,
    this.profileImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      verified: json['verified'] as bool,
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final bool verified;
  final String? profileImage;
  final DateTime createdAt;
}
