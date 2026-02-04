import 'dart:convert';

TopicJson topicJsonFromMap(String str) => TopicJson.fromMap(json.decode(str));

String topicJsonToMap(TopicJson data) => json.encode(data.toMap());

class TopicJson {
    final String subject;
    final String topic;
   

    TopicJson({
        required this.topic,
        required this.subject,
    });

    factory TopicJson.fromMap(Map<String, dynamic> json) => TopicJson(
        topic: json["topic"],
        subject: json["subject"]
       
    );

    Map<String, dynamic> toMap() => {
        "topic": topic,
        "subject": subject,
    };
}
