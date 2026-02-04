import 'package:cbt_software_win/database/json/topic_json.dart';

class TopicsAndSubjects {
   
    final List<TopicJson> topicsArray;
    final String subject;
   

    TopicsAndSubjects({
        // this.id,
        required this.topicsArray,
        required this.subject,
        
    });

    factory TopicsAndSubjects.fromMap(Map<String, dynamic> json) => TopicsAndSubjects(
        topicsArray: (json["topicsArray"] as List).map((e) => TopicJson.fromMap(e)).toList(),
        subject: json["subject"],
    );

    Map<String, dynamic> toMap() => {
        "subject": subject,
        "topicsArray": topicsArray.map((e) => e.toMap()).toList(),
            };
}
