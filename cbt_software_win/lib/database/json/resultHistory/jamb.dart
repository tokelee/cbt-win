import 'dart:convert';

JambResultHistoryJson jambResultHistoryJsonFromMap(String str) => JambResultHistoryJson.fromMap(json.decode(str));

String jambResultHistoryJsonToMap(JambResultHistoryJson data) => json.encode(data.toMap());

class JambResultHistoryJson {
    final String subjectAndScore;
    final String username;
    final String totalSubject;
    final String score;
    final String createdAt;
   

    JambResultHistoryJson({
        required this.subjectAndScore,
        required this.username,
        required this.totalSubject,
        required this.score,
        required this.createdAt,
    });

    factory JambResultHistoryJson.fromMap(Map<String, dynamic> json) => JambResultHistoryJson(
        subjectAndScore: json["subjectAndScore"],
        username: json["username"],
        totalSubject: json["totalSubject"],
        score: json["score"],
        createdAt: json["createdAt"],
       
    );

    Map<String, dynamic> toMap() => {
        "subjectAndScore": subjectAndScore,
        "username": username,
        "totalSubject": totalSubject,
        "score": score,
        "createdAt": createdAt,
    };
}
