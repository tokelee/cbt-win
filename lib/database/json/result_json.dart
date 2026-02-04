import 'dart:convert';

ResultHistoryJson resultHistoryJsonFromMap(String str) => ResultHistoryJson.fromMap(json.decode(str));

String resultHistoryJsonToMap(ResultHistoryJson data) => json.encode(data.toMap());

class ResultHistoryJson {
    final String firstName;
    final String lastName;
    final String username;
   

    ResultHistoryJson({
        // this.id,
        required this.firstName,
        required this.lastName,
        required this.username,
    });

    factory ResultHistoryJson.fromMap(Map<String, dynamic> json) => ResultHistoryJson(
        // id: json["id"].toString(),
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
       
    );

    Map<String, dynamic> toMap() => {
        // "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
    };
}
