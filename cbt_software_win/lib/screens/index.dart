import 'package:cbt_software_win/database/helper/question_database_helper.dart';
import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late JambDatabaseHelper handler;
  late AppDatabaseHelper appHandler;
  final db = JambDatabaseHelper();
  final appDB = AppDatabaseHelper();
  final String jsonString = '''[
  {
    "question": "What is geography 1?",
    "optionA": "A SDK",
    "optionB": "A Framework",
    "optionC": "A Language",
    "optionD": "An IDE",
    "answer": "a",
    "topic": "Topic 1",
    "section": "Basics",
    "imageName": "",
    "mark": "1",
    "type": "MCQ",
    "externalLinkUrl": "",
    "isActive": 1,
    "instruction": "",
    "explanation": "Flutter is a UI toolkit from Google.",
    "createAt": "2024-01-01"
  },
 {
    "question": "What is geography 2?",
    "optionA": "A SDK",
    "optionB": "A Framework",
    "optionC": "A Language",
    "optionD": "An IDE",
    "answer": "b",
    "topic": "Topic 2",
    "section": "Basics",
    "imageName": "",
    "mark": "1",
    "type": "MCQ",
    "externalLinkUrl": "",
    "isActive": 1,
    "instruction": "",
    "explanation": "Flutter is a UI toolkit from Google.",
    "createAt": "2024-01-01"
  },
   {
    "question": "What is geography 3?",
    "optionA": "A SDK",
    "optionB": "A Framework",
    "optionC": "A Language",
    "optionD": "An IDE",
    "answer": "c",
    "topic": "Topic 3",
    "section": "Basics",
    "imageName": "",
    "mark": "1",
    "type": "MCQ",
    "externalLinkUrl": "",
    "isActive": 1,
    "instruction": "",
    "explanation": "Flutter is a UI toolkit from Google.",
    "createAt": "2024-01-01"
  },
   {
    "question": "What is geography 4?",
    "optionA": "A SDK",
    "optionB": "A Framework",
    "optionC": "A Language",
    "optionD": "An IDE",
    "answer": "a",
    "topic": "Topic 4",
    "section": "Basics",
    "imageName": "",
    "mark": "1",
    "type": "MCQ",
    "externalLinkUrl": "",
    "isActive": 1,
    "instruction": "",
    "explanation": "Flutter is a UI toolkit from Google.",
    "createAt": "2024-01-01"
  }
]''';

  final String subjectString = '''
  [
    {
      "subject":"Use of English",
      "department":"general",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Mathematics",
      "department":"general",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Economics",
      "department":"general",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Agricultural Science",
      "department":"general",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Physics",
      "department":"science",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Chemistry",
      "department":"science",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Biology",
      "department":"science",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Financial Accounting",
      "department":"business",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Commerce",
      "department":"business",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Book keeping",
      "department":"business",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"History",
      "department":"humanity",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Literature in English",
      "department":"humanity",
      "createdAt":"${DateTime.now().toString()}"
    }
  ]
''';

  final String topicString = '''
  [
    {
      "subject":"Use of English",
      "topic":"Register",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Use of English",
      "topic":"Letter writing",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Use of English",
      "topic":"Vowels",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Mathematics",
      "topic":"Surds",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Mathematics",
      "topic":"Indices",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Mathematics",
      "topic":"Construction",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Physics",
      "topic":"Heat Energy",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Physics",
      "topic":"Motion",
      "createdAt":"${DateTime.now().toString()}"
    },
    {
      "subject":"Physics",
      "topic":"Electric field",
      "createdAt":"${DateTime.now().toString()}"
    }
  ]
''';



  @override
  void initState() {
    handler = db;
    appHandler = appDB;
    super.initState();
    // addQuestion();
    appHandler.defaultCommand();
  }

//   List<QuestionsJson> parseQuestionsJson(String jsonString) {
//   final List<dynamic> jsonData = json.decode(jsonString);
//   return jsonData.map((item) => QuestionsJson.fromMap(item)).toList();
// }

  void addQuestion() {
    // appHandler.insertSubjects(subjectString);
    // appHandler.insertTopics(topicString);
    // appHandler.getSubjects();
    // appHandler.addUser(UserJson(firstName: "firstName", lastName: "lastName", username: "username"));
    // String 
    // handler.insertQuestions('geography', jsonString);
    // print(jsonString.toString());
    // handler.insertQuestion(
    //     QuestionsJson(
    //         question: "What is physics in 5",
    //         optionA: "Bus",
    //         optionB: "Building",
    //         optionC: "Lorry",
    //         optionD: "Car",
    //         answer: "c",
    //         topic: "new topic",
    //         section: "a",
    //         imageName: "equation.png",
    //         mark: "2.5",
    //         type: "definition",
    //         externalLinkUrl: "",
    //         isActive: "1",
    //         instruction: "Answer all questions",
    //         explanation: "Testing additional mark, image and question number",
    //         createAt: "12/10/2020"),
    //     "physics");
  }

  @override
  Widget build(BuildContext context) {
    String folderPath = "";

    if (Platform.isWindows) {
      Map<String, String> envVars = Platform.environment;
      folderPath =
          p.join(envVars['UserProfile'].toString(), '.AkadaCbtSoftware');
    }

    Directory directory = Directory(folderPath);

    if (!directory.existsSync() && folderPath != "") {
      directory.createSync(recursive: true);
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
