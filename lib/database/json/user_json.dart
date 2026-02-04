import 'dart:convert';

UserJson userJsonFromMap(String str) => UserJson.fromMap(json.decode(str));

String userJsonToMap(UserJson data) => json.encode(data.toMap());

class UserJson {
    // final String? id;
    final String firstName;
    final String lastName;
    final String username;
   

    UserJson({
        // this.id,
        required this.firstName,
        required this.lastName,
        required this.username,
    });

    factory UserJson.fromMap(Map<String, dynamic> json) => UserJson(
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
