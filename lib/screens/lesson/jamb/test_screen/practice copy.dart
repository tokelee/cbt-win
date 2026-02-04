import 'dart:async';
import 'dart:io';
import 'package:cbt_software_win/core/helper/colors.dart';
import 'package:cbt_software_win/database/helper/question_database_helper.dart';
import 'package:cbt_software_win/database/json/question_json.dart';
import 'package:cbt_software_win/database/json/question_response_json.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:cbt_software_win/screens/lesson/widgets/lesson_navbar.dart';
import 'package:cbt_software_win/utils/toLowerCamelCase_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class PractiseTestScreen extends StatefulWidget {
  const PractiseTestScreen({super.key});

  @override
  State<PractiseTestScreen> createState() => _PractiseTestScreenState();
}

class _PractiseTestScreenState extends State<PractiseTestScreen> {
  late JambDatabaseHelper handler;
  // late Future<List<QuestionsJson>> dbQuestions;
  final db = JambDatabaseHelper();
  List<QuestionsJson> dbQuestions = [];
  String? currentOption;
  String currentSubject = "";
  List<dynamic> currentSubjectQuestions = [];
  int currentQuestion = 1;
  List<String> answeredQuestions = [];
  Set<String> answeredQuestionsMarker = {};
  Duration duration = const Duration();
  static const countdownDuration = Duration(hours: 1);
  Timer? timer;
  bool showResult = false;
  bool isInReviewMode = false;
  bool confirmSubmitIsVisible = false;
  final List<SubjectQuestions> providerSelectedQuestions = [];
  // List<dynamic> clientScore = [];
  double totalScore = 0;
  final ScrollController _scrollController = ScrollController();
  Set<String> selectedSubjects = {};

  @override
  void initState() {
    handler = db;
    super.initState();
    startTimer();
    reset();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    selectedSubjects =
        Provider.of<SelectedSubject>(context, listen: false).selectedSubjects;

    for (String subject in selectedSubjects) {
      String formattedSubject = toLowerCamelCase(subject);
      await fetchQuesions(formattedSubject);
    }
    // print(providerSelectedQuestions);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchQuesions(String subject) async {
    try {
      final List<QuestionsJson> fetchedQuestions =
          await handler.getQuestions(subject);
       SubjectQuestions formattedQuestion = SubjectQuestions(questionsArray: fetchedQuestions, subject: subject);
      providerSelectedQuestions.add(formattedQuestion);
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  Future<List<QuestionsJson>> getAllQuestions() async {
    return await handler.getQuestions("mathematics");
  }

  void reset() {
    setState(() => duration = countdownDuration);
  }

  void subtractTime() {
    const removeSeconds = -1;

    setState(() {
      final seconds = duration.inSeconds + removeSeconds;
      if (seconds < 0) {
        timer?.cancel();
        print("Timer completed");
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => subtractTime());
  }

  void submitTest() {
    for (String answer in answeredQuestions) {
      if (answer[1] == answer[2]) {
        setState(() {
          totalScore += 2.5;
        });
      }
    }

    setState(() {
      showResult = !showResult;
      confirmSubmitIsVisible = !showResult;
    });

    duration = const Duration(seconds: 0);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    final countDownIsCompleted = duration.inSeconds == 0;

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    String homePath = "";

    if (Platform.isWindows) {
      Map<String, String> envVars = Platform.environment;
      homePath = p.join(envVars['UserProfile'].toString(), '.AkadaCbtSoftware',
          'Questions', '2023');
    }

    List<List<dynamic>> allSelectedSubjectQuestions = [];

    for (String subject in selectedSubjects) {
      File file = File(p.join(homePath, '${subject.toLowerCase()} 2023.csv'));
      String contents = file.readAsStringSync();

      List<List<dynamic>> questions =
          const CsvToListConverter().convert(contents);

      allSelectedSubjectQuestions.add(questions);
    }

    // File file = File('C:/Users/USER/Downloads/exam_question2.csv');
    // String contents = file.readAsStringSync();

    // List<List<dynamic>> questions =
    //     const CsvToListConverter().convert(contents);

    final firstSubjectInSelectedSubjects = selectedSubjects.toList()[0];

    final firstQuestionInAllSelectedSubjectsQuestions =
        allSelectedSubjectQuestions[0];

    List<dynamic> questions = currentSubject == ""
        ? firstQuestionInAllSelectedSubjectsQuestions
        : currentSubjectQuestions;

    // Things that have to do with radio tiles

    // Destructuring the items in the question csv file
    final String optionA = questions[currentQuestion][2];
    final String optionB = questions[currentQuestion][3];
    final String optionC = questions[currentQuestion][4];
    final String optionD = questions[currentQuestion][5];
    final String correctAnswer = questions[currentQuestion][6];

    // Returns a value that the options (radio button) holds
    String radioValueForOption(String option) {
      if (currentSubject == "") {
        return "$currentQuestion$option$correctAnswer$firstSubjectInSelectedSubjects";
      }
      return "$currentQuestion$option$correctAnswer$currentSubject";
    }

    void handleAnswerSelected(
        int questionNumber, String selectedOption, String correctOption) {
      for (String item in answeredQuestions) {
        String targetItem = "";
        if (currentSubject == "") {
          targetItem = firstSubjectInSelectedSubjects;
        } else {
          targetItem = currentSubject;
        }
        if (item.startsWith("$questionNumber") && item.contains(targetItem)) {
          int itemIndex = answeredQuestions.indexOf(item);
          if (currentSubject == "") {
            answeredQuestions[itemIndex] =
                '$questionNumber$selectedOption$correctOption$firstSubjectInSelectedSubjects';
            return;
          }
          answeredQuestions[itemIndex] =
              '$questionNumber$selectedOption$correctOption$currentSubject';
          return;
        }
      }

      setState(() {
        if (currentSubject == "") {
          answeredQuestions.add(
              '$questionNumber$selectedOption$correctOption$firstSubjectInSelectedSubjects');
          answeredQuestionsMarker
              .add("$questionNumber$firstSubjectInSelectedSubjects");
          return;
        }
        answeredQuestions
            .add('$questionNumber$selectedOption$correctOption$currentSubject');
        answeredQuestionsMarker.add("$questionNumber$currentSubject");
      });
    }

    void handleSelectNewSubject(String subject) {
      setState(() {
        currentQuestion = 1;
        currentSubject = subject;
        currentSubjectQuestions = allSelectedSubjectQuestions[
            selectedSubjects.toList().indexOf(subject)];
      });
    }

    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
        body: Stack(children: <Widget>[
          Column(children: [
            LessonNavbar(
              isInReviewMode: isInReviewMode,
              countDownIsCompleted: countDownIsCompleted,
              hour: hours,
              minute: minutes,
              second: seconds,
              onTap: () {
                if (isInReviewMode) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
                  return;
                } else {
                  setState(() {
                    confirmSubmitIsVisible = !confirmSubmitIsVisible;
                  });
                  return;
                }
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: deviceHeight - 100.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: deviceWidth * 0.025),
                      child: Row(
                        children: [
                          for (String subject in selectedSubjects)
                            MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    // context.read<UserProvider>().changeSubject(newSubject: subject);
                                    handleSelectNewSubject(subject);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        color: currentSubject == subject ||
                                                currentSubject == "" &&
                                                    subject ==
                                                        firstSubjectInSelectedSubjects
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 232, 232, 232),
                                        border: Border.all(
                                            width: 1.0,
                                            color: currentSubject == subject ||
                                                    currentSubject == "" &&
                                                        subject ==
                                                            firstSubjectInSelectedSubjects
                                                ? const Color.fromARGB(
                                                    255, 128, 128, 128)
                                                : const Color.fromARGB(
                                                    255, 201, 201, 201))),
                                    child: Text(
                                      subject,
                                      style: TextStyle(
                                          color: currentSubject == subject ||
                                                  currentSubject == "" &&
                                                      subject ==
                                                          firstSubjectInSelectedSubjects
                                              ? Colors.black
                                              : Colors.grey),
                                    ),
                                  ),
                                ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.95,
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(
                      //         width: 1.0, color: const Color.fromARGB(0, 0, 0, 0))),
                      child: Column(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          width: double.infinity,
                          child: const Text(
                            "Answer all questions in this section",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: deviceWidth * 0.95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.0,
                                    color: appBackgroundColorOpaque)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: appBackgroundColorOpaque,
                                  padding: const EdgeInsets.all(10.0),
                                  width: double.infinity,
                                  child: Text(
                                    "Question $currentQuestion",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  constraints: BoxConstraints(
                                      maxHeight: deviceHeight * 0.5),
                                  child: Scrollbar(
                                      trackVisibility: true,
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      interactive: true,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              height: 150.0,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/equation.png"),
                                                    fit: BoxFit.contain,
                                                    alignment:
                                                        Alignment.centerLeft),
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                width: double.infinity,
                                                child: Text(
                                                  questions[currentQuestion][1],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RadioListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    activeColor:
                                                        appBackgroundColorOpaque,
                                                    value: radioValueForOption(
                                                        "a"),
                                                    groupValue: answeredQuestions
                                                            .contains(
                                                                radioValueForOption(
                                                                    "a"))
                                                        ? radioValueForOption(
                                                            "a")
                                                        : currentOption,
                                                    onChanged:
                                                        countDownIsCompleted
                                                            ? null
                                                            : (value) {
                                                                setState(() {
                                                                  currentOption =
                                                                      value
                                                                          .toString();
                                                                });
                                                                handleAnswerSelected(
                                                                    currentQuestion,
                                                                    "a",
                                                                    correctAnswer);
                                                              },
                                                    title: Text(
                                                      "A. $optionA",
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                    )),
                                                RadioListTile(
                                                    activeColor:
                                                        appBackgroundColorOpaque,
                                                    dense: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    value: radioValueForOption(
                                                        "b"),
                                                    groupValue: answeredQuestions
                                                            .contains(
                                                                radioValueForOption(
                                                                    "b"))
                                                        ? radioValueForOption(
                                                            "b")
                                                        : currentOption,
                                                    onChanged:
                                                        countDownIsCompleted
                                                            ? null
                                                            : (value) {
                                                                setState(() {
                                                                  currentOption =
                                                                      value
                                                                          .toString();
                                                                });
                                                                handleAnswerSelected(
                                                                    currentQuestion,
                                                                    "b",
                                                                    correctAnswer);
                                                              },
                                                    title: Text("B. $optionB",
                                                        style: const TextStyle(
                                                            fontSize: 14.0))),
                                                RadioListTile(
                                                    activeColor:
                                                        appBackgroundColorOpaque,
                                                    dense: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    value: radioValueForOption(
                                                        "c"),
                                                    groupValue: answeredQuestions
                                                            .contains(
                                                                radioValueForOption(
                                                                    "c"))
                                                        ? radioValueForOption(
                                                            "c")
                                                        : currentOption,
                                                    onChanged:
                                                        countDownIsCompleted
                                                            ? null
                                                            : (value) {
                                                                setState(() {
                                                                  currentOption =
                                                                      value
                                                                          .toString();
                                                                });
                                                                handleAnswerSelected(
                                                                    currentQuestion,
                                                                    "c",
                                                                    correctAnswer);
                                                              },
                                                    title: Text("C. $optionC",
                                                        style: const TextStyle(
                                                            fontSize: 14.0))),
                                                RadioListTile(
                                                    activeColor:
                                                        appBackgroundColorOpaque,
                                                    dense: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    value: radioValueForOption(
                                                        "d"),
                                                    groupValue: answeredQuestions
                                                            .contains(
                                                                radioValueForOption(
                                                                    "d"))
                                                        ? radioValueForOption(
                                                            "d")
                                                        : currentOption,
                                                    onChanged:
                                                        countDownIsCompleted
                                                            ? null
                                                            : (value) {
                                                                setState(() {
                                                                  currentOption =
                                                                      value
                                                                          .toString();
                                                                });
                                                                handleAnswerSelected(
                                                                    currentQuestion,
                                                                    "d",
                                                                    correctAnswer);
                                                              },
                                                    title: Text("D. $optionD",
                                                        style: const TextStyle(
                                                            fontSize: 14.0))),
                                                if (isInReviewMode)
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 20.0),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Correct option",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            correctAnswer
                                                                .toString()
                                                                .toUpperCase(),
                                                          ),
                                                          const SizedBox(
                                                            height: 20.0,
                                                          ),
                                                          const Text(
                                                            "Explanation",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            )),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      width: deviceWidth * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                              onPressed: currentQuestion > 1
                                  ? countDownIsCompleted && !isInReviewMode
                                      ? null
                                      : () {
                                          setState(() {
                                            if (currentQuestion > 1) {
                                              currentQuestion =
                                                  currentQuestion - 1;
                                            }
                                          });
                                        }
                                  : null,
                              icon:
                                  const Icon(Icons.arrow_circle_left_outlined),
                              label: const Text("Previous")),
                          ElevatedButton.icon(
                              onPressed:
                                  currentQuestion < (questions.length - 1)
                                      ? countDownIsCompleted && !isInReviewMode
                                          ? null
                                          : () {
                                              setState(() {
                                                if (currentQuestion <
                                                    (questions.length - 1)) {
                                                  currentQuestion =
                                                      currentQuestion + 1;
                                                }
                                              });
                                            }
                                      : null,
                              icon:
                                  const Icon(Icons.arrow_circle_right_outlined),
                              label: const Text("Next"))
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: deviceWidth * 0.95,
                      child: Wrap(
                        children: [
                          for (int i = 1; i < questions.length; i++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentQuestion = i;
                                });
                              },
                              child: Container(
                                // margin: const EdgeInsets.all(5.0),
                                constraints: const BoxConstraints(
                                    maxWidth: 30, maxHeight: 30),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // color: Colors.brown,
                                  color: answeredQuestionsMarker.contains(
                                          "${i.toString()}${currentSubject == "" ? firstSubjectInSelectedSubjects : currentSubject}")
                                      ? appBackgroundColorOpaque
                                      : null,
                                  border: Border.all(
                                      width: 1,
                                      color: appBackgroundColorOpaque),
                                  // borderRadius: BorderRadius.circular(50)
                                ),
                                child: Text(i.toString(),
                                    style: const TextStyle(fontSize: 13.0)),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
          if (confirmSubmitIsVisible)
            Center(
                child: PhysicalModel(
                    color: Colors.white,
                    elevation: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      height: 140.0,
                      width: 240.0,
                      child: Column(
                        children: [
                          const Text("Are you sure you want to submit?"),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    submitTest();
                                  },
                                  child: const Text("Yes")),
                              const SizedBox(
                                width: 10.0,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      confirmSubmitIsVisible =
                                          !confirmSubmitIsVisible;
                                    });
                                  },
                                  child: const Text("No"))
                            ],
                          )
                        ],
                      ),
                    ))),
          if (showResult)
            Positioned(
              top: 0,
              child: Container(
                color: const Color(0xFFFFFFFF),
                height: deviceHeight,
                width: deviceWidth,
                // child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                        width: 70.00, height: 70.00, child: Placeholder()),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "AKAD CBT SOFTWARE",
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "EastSeaDokdo"),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Your score",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: appBackgroundColorOpaque,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Text(
                        totalScore.round().toString(),
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Score details",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    for (String subject in selectedSubjects)
                      Text(
                        "$subject - 50/100",
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Wrap(
                      children: [
                        ElevatedButton.icon(
                            icon: const Icon(Icons.book),
                            onPressed: () {
                              setState(() {
                                showResult = !showResult;
                                isInReviewMode = !isInReviewMode;
                              });
                            },
                            label: const Text("Review Test")),
                        const SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton.icon(
                            icon: const Icon(Icons.home),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                            },
                            label: const Text("Go home"))
                      ],
                    )
                  ],
                ),
                // ),
              ),
            ),
        ]));
  }
}
