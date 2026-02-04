import 'dart:convert';

SubjectJson subjectJsonFromMap(String str) => SubjectJson.fromMap(json.decode(str));

String subjectJsonToMap(SubjectJson data) => json.encode(data.toMap());

class SubjectJson {
    final String subject;
    final String department;
   

    SubjectJson({
        required this.department,
        required this.subject,
    });

    factory SubjectJson.fromMap(Map<String, dynamic> json) => SubjectJson(
        department: json["department"],
        subject: json["subject"]
       
    );

    Map<String, dynamic> toMap() => {
        // "id": id,
        "department": department,
        "subject": subject,
    };
}
