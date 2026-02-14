class JambResultJson {
  final int? id;
  final String userId;
  final String subjectAndScore;
  final String totalSubject;
  final String score;
  final String? createdAt;

  JambResultJson({
    this.id,
    required this.userId,
    required this.subjectAndScore,
    required this.totalSubject,
    required this.score,
    this.createdAt
  });

  factory JambResultJson.fromMap(Map<String, dynamic> map) {
    return JambResultJson(
      id: map['id'],
      userId: map['user_id'],
      subjectAndScore: map['subject_and_score'],
      totalSubject: map['total_subject'],
      score: map['score'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject_and_score': subjectAndScore,
      'total_subject': totalSubject,
      'score': score,
      'created_at': createdAt,
    };
  }
}