class SSCEResultJson {
  final int? id;
  final String userId;
  final String subjectAndScore;
  final String totalSubject;
  final String score;
  final String examType;
  final String? createdAt;

  SSCEResultJson({
    this.id,
    required this.userId,
    required this.subjectAndScore,
    required this.totalSubject,
    required this.score,
    required this.examType,
    this.createdAt
  });

  factory SSCEResultJson.fromMap(Map<String, dynamic> map) {
    return SSCEResultJson(
      id: map['id'],
      userId: map['user_id'],
      subjectAndScore: map['subject_and_score'],
      totalSubject: map['total_subject'],
      score: map['score'],
      examType: map['exam_type'],
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
      'exam_type': examType,
      'created_at': createdAt,
    };
  }
}