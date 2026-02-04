import 'package:cbt_software_win/utils/json/answer_json.dart';

class SubjectChosenAnswer {
  final List<ChosenAnswerJson> chosenAnswerArray;
  final String subject;

  SubjectChosenAnswer({
    required this.chosenAnswerArray,
    required this.subject,
  });

  factory SubjectChosenAnswer.fromMap(Map<String, dynamic> json) =>
      SubjectChosenAnswer(
        chosenAnswerArray: (json["chosenAnswerArray"] as List)
            .map((e) => ChosenAnswerJson.fromMap(e))
            .toList(),
        subject: json["subject"],
      );

  Map<String, dynamic> toMap() => {
        "subject": subject,
        "questionsArray": chosenAnswerArray.map((e) => e.toMap()).toList(),
      };
}
