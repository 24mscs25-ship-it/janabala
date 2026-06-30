class AppUser {
  AppUser({
    required this.id,
    required this.phone,
    this.name,
    this.constituencyId,
    required this.role,
    required this.isVerified,
  });

  final String id;
  final String phone;
  final String? name;
  final String? constituencyId;
  final String role;
  final bool isVerified;

  bool get isAdmin => role == "admin";

  factory AppUser.fromApi(Map<String, dynamic> json) => AppUser(
        id: json["id"] as String,
        phone: json["phone"] as String,
        name: json["name"] as String?,
        constituencyId: json["constituency_id"] as String?,
        role: json["role"] as String,
        isVerified: json["is_verified"] as bool? ?? false,
      );
}
