class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String role; // "user" or "admin"

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.role = "user",
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }
}
