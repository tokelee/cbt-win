class UserJson {
  final int? id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? updatedAt;

  UserJson({
    this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt
  });

  factory UserJson.fromMap(Map<String, dynamic> map) {
    return UserJson(
      id: map['id'],
      username: map['username'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}