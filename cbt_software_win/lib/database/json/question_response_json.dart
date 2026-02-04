import 'package:cbt_software_win/database/json/question_json.dart';

class SubjectQuestions {
   
    final List<QuestionsJson> questionsArray;
    final String subject;
   

    SubjectQuestions({
        // this.id,
        required this.questionsArray,
        required this.subject,
        
    });

    factory SubjectQuestions.fromMap(Map<String, dynamic> json) => SubjectQuestions(
        questionsArray: (json["questionsArray"] as List).map((e) => QuestionsJson.fromMap(e)).toList(),
        subject: json["subject"],
    );

    Map<String, dynamic> toMap() => {
        "subject": subject,
        "questionsArray": questionsArray.map((e) => e.toMap()).toList(),
            };
}
