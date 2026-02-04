class ChosenAnswerJson {
   
    final String questionNumber;
    final String chosenAnswer;
    final String correctAnswer;
    final String mark;
    final String subject;
    final String remark;
    final bool isCorrect;
    final String topic;
    final String totalQuestions;

    ChosenAnswerJson({
        required this.questionNumber,
        required this.chosenAnswer,
        required this.correctAnswer,
        required this.mark,
        required this.subject,
        required this.remark,
        required this.isCorrect,
        required this.topic,
        required this.totalQuestions,

        
    });

    factory ChosenAnswerJson.fromMap(Map<String, dynamic> json) => ChosenAnswerJson(
        questionNumber: json["questionNumber"],
        chosenAnswer: json["chosenAnswer"],
        correctAnswer: json["correctAnswer"],
        mark: json["mark"],
        subject: json["subject"],
        remark: json["remark"],
        isCorrect: json["isCorrect"],
        topic: json["topic"],
        totalQuestions: json["totalQuestions"],
    );

    Map<String, dynamic> toMap() => {
        "questionNumber": questionNumber,
        "chosenAnswer": chosenAnswer,
        "correctAnswer": correctAnswer,
        "mark": mark,
        "subject": subject,
        "remark": remark,
        "isCorrect": isCorrect,
        "topic": topic,
        "totalQuestions": totalQuestions,
    };

}