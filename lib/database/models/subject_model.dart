class SubjectJson {
  final int? id;
  final String subject;
  final String? department;
  final String? slug;
  final String? createdAt;

  SubjectJson({this.id, required this.subject, this.department, this.slug, this.createdAt});

  factory SubjectJson.fromMap(Map<String, dynamic> map) {
    return SubjectJson(
      id: map['id'],
      subject: map['subject'],
      department: map['department'],
      slug: map['slug'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'department': department,
      'slug': slug,
      'created_at': createdAt,
    };
  }
}