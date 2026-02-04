import 'dart:convert';

QuestionsJson questionsJsonFromMap(String str) => QuestionsJson.fromMap(json.decode(str));

String questionsJsonToMap(QuestionsJson data) => json.encode(data.toMap());

class QuestionsJson {
    // final String? id;
    final String question;
    final String optionA;
    final String optionB;
    final String optionC;
    final String optionD;
    final String answer;
    final String topic;
    final String section;
    final String imageName;
    final String mark;
    final String type;
    final String externalLinkUrl;
    final String isActive;
    final String instruction;
    final String explanation;
    final String createAt;

    QuestionsJson({
        // this.id,
        required this.question,
        required this.optionA,
        required this.optionB,
        required this.optionC,
        required this.optionD,
        required this.answer,
        required this.topic,
        required this.section,
        required this.imageName,
        required this.mark,
        required this.type,
        required this.externalLinkUrl,
        required this.isActive,
        required this.instruction,
        required this.explanation,
        required this.createAt,
    });

    factory QuestionsJson.fromMap(Map<String, dynamic> json) => QuestionsJson(
        // id: json["id"].toString(),
        question: json["question"],
        optionA: json["optionA"],
        optionB: json["optionB"],
        optionC: json["optionC"],
        optionD: json["optionD"],
        answer: json["answer"],
        topic: json["topic"],
        section: json["section"],
        imageName: json["imageName"],
        mark: json["mark"],
        type: json["type"],
        externalLinkUrl: json["externalLinkUrl"],
        isActive: json["isActive"].toString(),
        instruction: json["instruction"],
        explanation: json["explanation"],
        createAt: json["createAt"],
    );

    Map<String, dynamic> toMap() => {
        // "id": id,
        "question": question,
        "optionA": optionA,
        "optionB": optionB,
        "optionC": optionC,
        "optionD": optionD,
        "answer": answer,
        "topic": topic,
        "section": section,
        "imageName": imageName,
        "mark": mark,
        "type": type,
        "externalLinkUrl": externalLinkUrl,
        "isActive": isActive,
        "instruction": instruction,
        "explanation": explanation,
        "createAt": createAt,
    };
}
