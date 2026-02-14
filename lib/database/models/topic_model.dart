class TopicJson {
  final int? id;
  final String topic;
  final int subjectId;
  final int? createdAt;

  TopicJson({this.id, required this.topic, required this.subjectId, this.createdAt});

  factory TopicJson.fromMap(Map<String, dynamic> map) {
    return TopicJson(
      id: map['id'],
      topic: map['topic'],
      subjectId: map['subject_id'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'topic': topic,
      'created_at': createdAt,
    };
  }
}