import 'dart:convert';

SSCEResultHistoryJson ssceResultHistoryJsonFromMap(String str) => SSCEResultHistoryJson.fromMap(json.decode(str));

String ssceResultHistoryJsonToMap(SSCEResultHistoryJson data) => json.encode(data.toMap());

class SSCEResultHistoryJson {
    final String subjectAndScore;
    final String username;
    final String totalSubject;
    final String score;
    final String createdAt;
   

    SSCEResultHistoryJson({
        required this.subjectAndScore,
        required this.username,
        required this.totalSubject,
        required this.score,
        required this.createdAt,
    });

    factory SSCEResultHistoryJson.fromMap(Map<String, dynamic> json) => SSCEResultHistoryJson(
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
