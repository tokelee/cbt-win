import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/json/subject_json.dart';
import 'package:cbt_software_win/database/json/topc_response_json.dart';
import 'package:cbt_software_win/database/json/topic_json.dart';
import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/screens/lesson/jamb/test_screen/practice.dart';
import 'package:cbt_software_win/screens/lesson/jamb/test_screen/study.dart';
import 'package:cbt_software_win/widgets/button.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomizeLessonScreen extends StatefulWidget {
  const CustomizeLessonScreen({super.key});

  @override
  State<CustomizeLessonScreen> createState() => _CustomizeLessonScreenState();
}

class _CustomizeLessonScreenState extends State<CustomizeLessonScreen> {
  // Set<String> generalSubjects = {
  //   "Use of English",
  //   "Mathematics",
  //   "Agricultural Science",
  //   "Civic Education",
  //   "Geography",
  //   "Economics",
  // };

  // Set<String> scienceSubjects = {
  //   "Physics",
  //   "Chemistry",
  //   "Biology",
  //   "Further Mathematics",
  // };
  // Set<String> businessSubjects = {
  //   "Financial Accounting",
  //   "Commerce",
  //   "Government",
  //   "Book Keeping",
  // };
  // Set<String> humanitySubjects = {
  //   "Literature in English",
  //   "History",
  //   "Yoruba",
  //   "Igbo",
  //   "Hausa",
  // };
  // Set<String> selectedCourses = {"Use of English"};
  Set<String> selectedCourses = {};
  Set<String> selectedTopics = {};

  AppDatabaseHelper db = AppDatabaseHelper();
  late Future<List<TopicsAndSubjects>> subjectTopics;
  final String getTopicForSubject = "Nil";
  Set<String> selectedSubjects = {};
  late Future<List<SubjectJson>> generalSubjects;
  late Future<List<SubjectJson>> scienceSubjects;
  late Future<List<SubjectJson>> businessSubjects;
  late Future<List<SubjectJson>> humanitySubjects;

  @override
  void initState() {
    selectedSubjects =
        Provider.of<SelectedSubject>(context, listen: false).selectedSubjects;
    super.initState();
    generalSubjects = fetchSubjects("general");
    scienceSubjects = fetchSubjects("science");
    businessSubjects = fetchSubjects("business");
    humanitySubjects = fetchSubjects("humanity");
    subjectTopics = fetchTopics();
  }

  Future<List<SubjectJson>> fetchSubjects(String department) async {
    return await db.getSubjects(department);
  }

  Future<List<TopicsAndSubjects>> fetchTopics() async {
    List<TopicsAndSubjects> result = [];
    for (String subject in selectedSubjects) {
      List<TopicJson> subjectAndTopic = await db.getTopics(subject);
      result.add(
          TopicsAndSubjects(topicsArray: subjectAndTopic, subject: subject));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // final lessonMode = context.watch<LessonStateProvider>().lessonStateItems.lessonMode;

    // bool containsScienceSubject =
    //     selectedCourses.any((item) => scienceSubjects.contains(item));
    // bool containsBusinessSubject =
    //     selectedCourses.any((item) => businessSubjects.contains(item));
    // bool containsHumanitySubject =
    //     selectedCourses.any((item) => humanitySubjects.contains(item));

    final lessonType =
        context.watch<LessonStateProvider>().lessonStateItems.lessonType;

    final lessonMode =
        context.watch<LessonStateProvider>().lessonStateItems.lessonMode;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      body: Column(children: [
        const Navbar(),
        const SizedBox(height: 50),
        ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: deviceWidth * 0.9,
              maxHeight: deviceHeight * 0.8,
              maxWidth: deviceWidth * 0.9,
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 0))
                    ]),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                  label: const Text("Back"),
                                  style: buttonAppTheme,
                                ),
                                ElevatedButton.icon(
                                  onPressed: selectedCourses.isEmpty
                                      ? null
                                      : () {
                                          if (lessonType == "study") {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const StudyScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                            return;
                                          } else if (lessonType == "practice") {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PractiseTestScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                            return;
                                          } else if (lessonType == "mock") {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PractiseTestScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                            return;
                                          }
                                        },
                                  icon: const Icon(Icons.start,
                                      color: Colors.white),
                                  label: const Text(
                                    "Start Lesson",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: buttonSuccess,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Select Topics",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                             
                              child: FutureBuilder(
                                  future: subjectTopics,
                                  builder: (BuildContext builder,
                                      AsyncSnapshot<List<TopicsAndSubjects>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else {
                                      if (snapshot.data!.isEmpty) {
                                        return const Center(
                                          child: Text("No topic to display"),
                                        );
                                      } else {
                                        final subjectsAndTopics =
                                            snapshot.data!;
                                        return SizedBox( 
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for(int i=0; i<subjectsAndTopics.length; i++)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                            Text(snapshot.data![i].subject, style: const TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10.0,),
                                             Wrap(children: [
                                                  for (TopicJson topicJson
                                                      in subjectsAndTopics[i].topicsArray)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0,
                                                              bottom: 10.0),
                                                      child: FilterChip(
                                                          label: Text(
                                                              topicJson.topic),
                                                          selected: selectedTopics
                                                              .contains(
                                                                  topicJson
                                                                      .topic),
                                                          onSelected:
                                                              (bool value) {
                                                            context
                                                                .read<
                                                                    SelectedSubject>()
                                                                .changeSubject(
                                                                    newSelectedSubjects:
                                                                        selectedTopics);
                                                            setState(() {
                                                              if (!selectedTopics
                                                                      .contains(
                                                                          topicJson
                                                                              .topic) &&
                                                                  selectedTopics
                                                                          .length <
                                                                      4) {
                                                                selectedTopics
                                                                    .add(topicJson
                                                                        .topic);
                                                              } else {
                                                                selectedTopics
                                                                    .remove(topicJson
                                                                        .topic);
                                                              }
                                                            });
                                                          }),
                                                    )
                                                ])
                                              ]
                                          )],
                                        ));
                                      }
                                    }
                                  }),
                            ),
                           

                       
                          ],
                        )))))
      ]),
    );
  }
}
