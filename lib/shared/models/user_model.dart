class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? universityName;
  final String? department;
  final String? semester;
  final String? studentId;
  final bool isPremium;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.universityName,
    this.department,
    this.semester,
    this.studentId,
    this.isPremium = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      universityName: json['universityName'] as String?,
      department: json['department'] as String?,
      semester: json['semester'] as String?,
      studentId: json['studentId'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'universityName': universityName,
    'department': department,
    'semester': semester,
    'studentId': studentId,
    'isPremium': isPremium,
  };
}
