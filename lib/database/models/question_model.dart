class QuestionsJson {
  final int? id;
  final String uniqueId;
  final int subjectId; // Changed from String to match Foreign Key
  final String year;
  final String question;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? answer;
  final int? topicId; // Linked to the topics table
  final int? mark;
  final String? type;
  final bool isObjective;
  final bool isDeleted;
  final String? imageName;
  final String? explanation;
  final int sectionId;
  final String? updatedAt;
  final String? createdAt;

  QuestionsJson({
    this.id,
    required this.uniqueId,
    required this.subjectId,
    required this.year,
    required this.question,
    this.optionA, this.optionB, this.optionC, this.optionD,
    this.answer,
    this.topicId,
    this.mark,
    this.type,
    this.isObjective = true,
    this.isDeleted = false,
    this.imageName,
    this.explanation,
    required this.sectionId,
    this.updatedAt,
    this.createdAt,
  });

  factory QuestionsJson.fromMap(Map<String, dynamic> map) {
    return QuestionsJson(
      id: map['id'],
      uniqueId: map['unique_id'],
      subjectId: map['subject_id'],
      year: map['year'],
      question: map['question'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      optionD: map['option_d'],
      answer: map['answer'],
      topicId: map['topic_id'],
      mark: map['mark'],
      type: map['type'],
      isObjective: map['is_objective'] == 1 || map['is_objective'] == true,
      isDeleted: map['is_deleted'] == 1 || map['is_deleted'] == true,
      imageName: map['image_name'],
      explanation: map['explanation'],
      sectionId: map['section_id'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'subject_id': subjectId,
      'year': year,
      'question': question,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'answer': answer,
      'topic_id': topicId,
      'mark': mark,
      'type': type,
      'is_objective': isObjective ? 1 : 0, // SQLite needs 1/0
      'is_deleted': isDeleted ? 1 : 0,
      'image_name': imageName,
      'explanation': explanation,
      'section_id': sectionId,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }
}