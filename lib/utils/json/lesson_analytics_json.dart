class SubjectSummary {
   
    final String subject;
    final String totalCorrect;
    final String totalAttempted;
    final String totalScore;
    final String totalQuestions;
   

    SubjectSummary({
        required this.subject,
        required this.totalCorrect,
        required this.totalScore,
        required this.totalAttempted,
        required this.totalQuestions,

        
    });

    factory SubjectSummary.fromMap(Map<String, dynamic> json) => SubjectSummary(
        subject: json["subject"],
        totalCorrect: json["totalCorrect"],
        totalScore: json["totalScore"],
        totalAttempted: json["totalAttempted"],
        totalQuestions: json["totalQuestions"]
    );

    Map<String, dynamic> toMap() => {
        "subject": subject,
        "totalCorrect": totalCorrect,
        "totalScore": totalScore,
        "totalAttempted": totalAttempted,
        "totalQuestions": totalQuestions
    };

}