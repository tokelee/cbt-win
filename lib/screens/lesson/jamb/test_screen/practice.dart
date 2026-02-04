import 'dart:async';
import 'package:cbt_software_win/core/helper/colors.dart';
import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/helper/question_database_helper.dart';
import 'package:cbt_software_win/database/json/question_json.dart';
import 'package:cbt_software_win/database/json/question_response_json.dart';
import 'package:cbt_software_win/database/json/resultHistory/jamb.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/providers/user_provider.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:cbt_software_win/screens/lesson/widgets/lesson_navbar.dart';
import 'package:cbt_software_win/utils/json/answer_json.dart';
import 'package:cbt_software_win/utils/json/lesson_analytics_json.dart';
import 'package:cbt_software_win/utils/toLowerCamelCase_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PractiseTestScreen extends StatefulWidget {
  const PractiseTestScreen({super.key});

  @override
  State<PractiseTestScreen> createState() => _PractiseTestScreenState();
}

class _PractiseTestScreenState extends State<PractiseTestScreen> {
  late JambDatabaseHelper handler;
  final db = JambDatabaseHelper();
  final appDB = AppDatabaseHelper();
  List<QuestionsJson> dbQuestions = [];
  String? currentOption;
  String currentSubject = "";
  List<QuestionsJson> currentSubjectQuestions = [];
  int currentQuestion = 1;
  int currentQuestionIndex = 0;
  List<String> answeredQuestions = [];
  Set<String> answeredQuestionsMarker = {};
  Duration duration = const Duration();
  static const countdownDuration = Duration(hours: 1);
  Timer? timer;
  bool showResult = false;
  bool isInReviewMode = false;
  bool confirmSubmitIsVisible = false;
  final List<SubjectQuestions> providerSelectedQuestions = [];
  double totalScore = 0;
  double totalCorrectScore = 0;
  final ScrollController _scrollController = ScrollController();
  Set<String> selectedSubjects = {};
  late Future<List<QuestionsJson>> firstQuestionInAllSelectedSubjectsQuestions;
  final List<ChosenAnswerJson> answersJson = [];
  int totalAttempted = 0;
  List<SubjectSummary> subjectSummary = [];

  @override
  void initState() {
    handler = db;
    selectedSubjects =
        Provider.of<SelectedSubject>(context, listen: false).selectedSubjects;

    super.initState();
    startTimer();
    reset();
    firstQuestionInAllSelectedSubjectsQuestions = _fetchAllSubjectQuestions();
  }

  Future<List<QuestionsJson>> _fetchAllSubjectQuestions() async {
    for (String subject in selectedSubjects) {
      String formattedSubject = toLowerCamelCase(subject);
      try {
        final List<QuestionsJson> fetchedQuestions =
            await handler.getQuestions(formattedSubject);
        SubjectQuestions formattedQuestion = SubjectQuestions(
            questionsArray: fetchedQuestions, subject: formattedSubject);
        providerSelectedQuestions.add(formattedQuestion);
      } catch (e) {
        print('Error fetching questions: $e');
      }
    }
    return providerSelectedQuestions[0].questionsArray;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchQuesions(String subject) async {}

  Future<List<QuestionsJson>> getAllQuestions() async {
    return await handler.getQuestions("mathematics");
  }

  void recordJambHistory(List<SubjectSummary> subjectAndScore, String username, String totalSubject, String score, String createdAt) async {
    String subjectAndScoreCummulation ="";
    for(SubjectSummary summary in subjectAndScore){
      subjectAndScoreCummulation+="${summary.subject}-${summary.totalCorrect}/${summary.totalScore}";
    }
    await appDB.insertJambResultHistory(
      JambResultHistoryJson(subjectAndScore: subjectAndScoreCummulation, username: username, totalSubject: totalSubject, score: score, createdAt: createdAt)
    );
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
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => subtractTime());
  }

  void submitTest() {
    double subjectTotalScore = 0.0; //total score for a particular subject
    double subjectTotalAttempt = 0;
    double subjectTotalCorrect = 0;
    double subjectTotalQuestion = 0;
    for (String subject in selectedSubjects) {
      subjectTotalCorrect = 0.0;
      subjectTotalAttempt = 0;
      subjectTotalScore = 0.0;

      for (SubjectQuestions question in providerSelectedQuestions) {
        if (question.subject == toLowerCamelCase(subject)) {
          for (QuestionsJson questionJson in question.questionsArray) {
            subjectTotalScore += double.parse(questionJson.mark);
            setState(() {
              totalScore += double.parse(questionJson.mark);
            });
          }
        }

      }

      for (ChosenAnswerJson answerJson in answersJson) {
        if (answerJson.subject == subject) {
          subjectTotalAttempt += 1;
          subjectTotalQuestion = double.parse(answerJson.totalQuestions);

          if (answerJson.chosenAnswer == answerJson.correctAnswer) {
            subjectTotalCorrect += double.parse(answerJson.mark);

            setState(() {
              totalCorrectScore += double.parse(answerJson.mark);
            });
          }
        }
      }

     
        subjectSummary.add(SubjectSummary(
            subject: subject,
            totalCorrect: subjectTotalCorrect.round().toString(),
            totalScore: subjectTotalScore.round().toString(),
            totalAttempted: subjectTotalAttempt.toString(), 
            totalQuestions: subjectTotalQuestion.toString()));
            
    }

    

    setState(() {
      showResult = !showResult;
      confirmSubmitIsVisible = !showResult;
      totalAttempted = answeredQuestionsMarker.length;
    });

    String username = Provider.of<UserProvider>(context, listen:false).userStateItems.username;

    recordJambHistory(subjectSummary, username.isNotEmpty ? username : "Anonymous", selectedSubjects.length.toString(), "${totalCorrectScore.round().toString()}/${totalScore.round().toString()}", DateTime.now().toString().split(" ")[0]);

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                        future: firstQuestionInAllSelectedSubjectsQuestions,
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                                height: deviceHeight - 100.0,
                                child: const Center(
                                    child: CircularProgressIndicator()));
                          }
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            final firstSubjectInSelectedSubjects =
                                selectedSubjects.toList()[0];

                            List<QuestionsJson> questions = currentSubject == ""
                                ? providerSelectedQuestions[0].questionsArray
                                : currentSubjectQuestions;

                            // Things that have to do with radio tiles

                            // Destructuring the items in the question csv file
                            final String optionA =
                                questions[currentQuestionIndex].optionA;
                            final String optionB =
                                questions[currentQuestionIndex].optionB;
                            final String optionC =
                                questions[currentQuestionIndex].optionC;
                            final String optionD =
                                questions[currentQuestionIndex].optionD;
                            final String questionDiagram =
                                questions[currentQuestionIndex].imageName;
                            final String correctAnswer =
                                questions[currentQuestionIndex].answer;

                            final String mark =
                                questions[currentQuestionIndex].mark;
                            final String topic =
                                questions[currentQuestionIndex].topic;

                            final String instruction =
                                questions[currentQuestionIndex].instruction;

                            // final String section =
                            //     questions[currentQuestionIndex].section;

                            // Returns a value that the options (radio button) holds
                            String radioValueForOption(String option) {
                              if (currentSubject == "") {
                                return "$currentQuestionIndex$option$correctAnswer$firstSubjectInSelectedSubjects";
                              }
                              return "$currentQuestionIndex$option$correctAnswer$currentSubject";
                            }

                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: deviceWidth * 0.025),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                                decoration: BoxDecoration(
                                                    color: currentSubject ==
                                                                subject ||
                                                            currentSubject == "" &&
                                                                subject ==
                                                                    firstSubjectInSelectedSubjects
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 232, 232, 232),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: currentSubject ==
                                                                    subject ||
                                                                currentSubject == "" &&
                                                                    subject ==
                                                                        firstSubjectInSelectedSubjects
                                                            ? const Color.fromARGB(255, 128, 128, 128)
                                                            : const Color.fromARGB(255, 201, 201, 201))),
                                                child: Text(
                                                  subject,
                                                  style: TextStyle(
                                                      color: currentSubject ==
                                                                  subject ||
                                                              currentSubject ==
                                                                      "" &&
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      width: double.infinity,
                                      child: Text(
                                        instruction,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        width: deviceWidth * 0.95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1.0,
                                                color:
                                                    appBackgroundColorOpaque)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                color: appBackgroundColorOpaque,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Question ${currentQuestionIndex + 1}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (isInReviewMode)
                                                      for (ChosenAnswerJson answerJson
                                                          in answersJson)
                                                        if (answerJson
                                                                    .subject ==
                                                                (currentSubject ==
                                                                        ""
                                                                    ? firstSubjectInSelectedSubjects
                                                                    : currentSubject) &&
                                                            answerJson
                                                                    .questionNumber ==
                                                                currentQuestionIndex
                                                                    .toString())
                                                          answerJson.isCorrect
                                                              ? Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            51,
                                                                            119,
                                                                            53)),
                                                                    Text(
                                                                      answerJson
                                                                          .remark,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              51,
                                                                              119,
                                                                              53)),
                                                                    )
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    Text(
                                                                      answerJson
                                                                          .remark,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  ],
                                                                )
                                                  ],
                                                )),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15.0),
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      deviceHeight * 0.5),
                                              child: Scrollbar(
                                                  trackVisibility: true,
                                                  thumbVisibility: true,
                                                  controller: _scrollController,
                                                  interactive: true,
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        _scrollController,
                                                    child: Column(
                                                      children: [
                                                        if (isInReviewMode)
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          20.0),
                                                              width: double
                                                                  .infinity,
                                                              child: Text(topic,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          51,
                                                                          119,
                                                                          53)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right)),
                                                        if (questionDiagram
                                                            .isNotEmpty)
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            height: 150.0,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/$questionDiagram"),
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft),
                                                            ),
                                                          ),
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              questions[
                                                                      currentQuestionIndex]
                                                                  .question,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            RadioListTile(
                                                                dense: true,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                activeColor:
                                                                    appBackgroundColorOpaque,
                                                                value:
                                                                    radioValueForOption(
                                                                        "a"),
                                                                groupValue: answeredQuestions.contains(
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
                                                                              currentOption = value.toString();
                                                                            });
                                                                            handleAnswerSelected(
                                                                                currentQuestionIndex,
                                                                                "a",
                                                                                correctAnswer,
                                                                                firstSubjectInSelectedSubjects,
                                                                                mark,
                                                                                topic,
                                                                                questions.length.toString());
                                                                          },
                                                                title: Text(
                                                                  "A. $optionA",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                                )),
                                                            RadioListTile(
                                                                activeColor:
                                                                    appBackgroundColorOpaque,
                                                                dense: true,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                value:
                                                                    radioValueForOption(
                                                                        "b"),
                                                                groupValue: answeredQuestions.contains(
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
                                                                              currentOption = value.toString();
                                                                            });
                                                                            handleAnswerSelected(
                                                                                currentQuestionIndex,
                                                                                "b",
                                                                                correctAnswer,
                                                                                firstSubjectInSelectedSubjects,
                                                                                mark,
                                                                                topic,
                                                                                questions.length.toString());
                                                                          },
                                                                title: Text(
                                                                    "B. $optionB",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0))),
                                                            RadioListTile(
                                                                activeColor:
                                                                    appBackgroundColorOpaque,
                                                                dense: true,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                value:
                                                                    radioValueForOption(
                                                                        "c"),
                                                                groupValue: answeredQuestions.contains(
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
                                                                              currentOption = value.toString();
                                                                            });
                                                                            handleAnswerSelected(
                                                                                currentQuestionIndex,
                                                                                "c",
                                                                                correctAnswer,
                                                                                firstSubjectInSelectedSubjects,
                                                                                mark,
                                                                                topic,
                                                                                questions.length.toString());
                                                                          },
                                                                title: Text(
                                                                    "C. $optionC",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0))),
                                                            RadioListTile(
                                                                activeColor:
                                                                    appBackgroundColorOpaque,
                                                                dense: true,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                value:
                                                                    radioValueForOption(
                                                                        "d"),
                                                                groupValue: answeredQuestions.contains(
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
                                                                              currentOption = value.toString();
                                                                            });
                                                                            handleAnswerSelected(
                                                                                currentQuestionIndex,
                                                                                "d",
                                                                                correctAnswer,
                                                                                firstSubjectInSelectedSubjects,
                                                                                mark,
                                                                                topic,
                                                                                questions.length.toString());
                                                                          },
                                                                title: Text(
                                                                    "D. $optionD",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0))),
                                                            if (isInReviewMode)
                                                              Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                        "Correct option",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        correctAnswer
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20.0,
                                                                      ),
                                                                      const Text(
                                                                        "Explanation",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(questions[
                                                                              currentQuestionIndex]
                                                                          .explanation
                                                                          .toString()),
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
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  width: deviceWidth * 0.95,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: currentQuestionIndex > 0
                                              ? countDownIsCompleted &&
                                                      !isInReviewMode
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (currentQuestionIndex >
                                                            0) {
                                                          currentQuestionIndex =
                                                              currentQuestionIndex -
                                                                  1;
                                                        }
                                                      });
                                                    }
                                              : null,
                                          icon: const Icon(
                                              Icons.arrow_circle_left_outlined),
                                          label: const Text("Previous")),
                                      ElevatedButton.icon(
                                          onPressed: currentQuestionIndex <
                                                  (questions.length - 1)
                                              ? countDownIsCompleted &&
                                                      !isInReviewMode
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (currentQuestionIndex <
                                                            (questions.length -
                                                                1)) {
                                                          currentQuestionIndex =
                                                              currentQuestionIndex +
                                                                  1;
                                                        }
                                                      });
                                                    }
                                              : null,
                                          icon: const Icon(Icons
                                              .arrow_circle_right_outlined),
                                          label: const Text("Next"))
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  width: deviceWidth * 0.95,
                                  child: Wrap(
                                    children: [
                                      for (int i = 0; i < questions.length; i++)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentQuestionIndex = i;
                                            });
                                          },
                                          child: Container(
                                            // margin: const EdgeInsets.all(5.0),
                                            constraints: const BoxConstraints(
                                                maxWidth: 30, maxHeight: 30),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              // color: Colors.brown,
                                              color: answeredQuestionsMarker
                                                      .contains(
                                                          "${i.toString()}${currentSubject == "" ? firstSubjectInSelectedSubjects : currentSubject}")
                                                  ? appBackgroundColorOpaque
                                                  : null,
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      appBackgroundColorOpaque),
                                              // borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Text((i + 1).toString(),
                                                style:
                                                    const TextStyle(fontSize: 13.0)),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
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
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Text(
                        "${totalCorrectScore.round().toString()}/${totalScore.round().toString()}",
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Score summary",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    for (SubjectSummary summary in subjectSummary)
                      Text(
                        "${summary.subject} - ${summary.totalCorrect}/${summary.totalScore} - Attempted -- ${summary.totalAttempted}",
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

  void handleAnswerSelected(
      int questionNumber,
      String selectedOption,
      String correctOption,
      String firstSubjectInSelectedSubjectsParam,
      String mark,
      String topic,
      String totalQuestions) {
    for (ChosenAnswerJson answerJson in answersJson) {
      if (answerJson.subject ==
              (currentSubject == ""
                  ? firstSubjectInSelectedSubjectsParam
                  : currentSubject) &&
          answerJson.questionNumber == questionNumber.toString()) {
        int answerIndex = answersJson.indexOf(answerJson);
        answersJson[answerIndex] = (currentSubject == ""
            ? ChosenAnswerJson(
                questionNumber: questionNumber.toString(),
                isCorrect: answerJson.chosenAnswer == answerJson.correctAnswer
                    ? true
                    : false,
                remark: answerJson.chosenAnswer == answerJson.correctAnswer
                    ? "Correct"
                    : "Wrong",
                chosenAnswer: selectedOption,
                correctAnswer: correctOption,
                mark: mark,
                topic: topic,
                subject: firstSubjectInSelectedSubjectsParam,
                totalQuestions: totalQuestions)
            : ChosenAnswerJson(
                questionNumber: questionNumber.toString(),
                isCorrect: answerJson.chosenAnswer == answerJson.correctAnswer
                    ? true
                    : false,
                remark: answerJson.chosenAnswer == answerJson.correctAnswer
                    ? "Correct"
                    : "Wrong",
                chosenAnswer: selectedOption,
                correctAnswer: correctOption,
                mark: mark,
                topic: topic,
                subject: currentSubject,
                totalQuestions: totalQuestions));
      }
    }

    for (String item in answeredQuestions) {
      String targetItem = "";
      if (currentSubject == "") {
        targetItem = firstSubjectInSelectedSubjectsParam;
      } else {
        targetItem = currentSubject;
      }
      if (item.startsWith("$questionNumber") && item.contains(targetItem)) {
        int itemIndex = answeredQuestions.indexOf(item);
        if (currentSubject == "") {
          answeredQuestions[itemIndex] =
              '$questionNumber$selectedOption$correctOption$firstSubjectInSelectedSubjectsParam';
          return;
        }
        answeredQuestions[itemIndex] =
            '$questionNumber$selectedOption$correctOption$currentSubject';
        return;
      }
    }

    // ChosenAnswerJson _chosenAnswer = ChosenAnswerJson(questionNumber: questionNumber.toString(), chosenAnswer: selectedOption, correctAnswer: correctOption, mark: mark, subject: currentSubject);

    setState(() {
      if (currentSubject == "") {
        answersJson.add(ChosenAnswerJson(
            questionNumber: questionNumber.toString(),
            chosenAnswer: selectedOption,
            isCorrect: selectedOption == correctOption ? true : false,
            remark: selectedOption == correctOption ? "correct" : "wrong",
            correctAnswer: correctOption,
            mark: mark,
            topic: topic,
            subject: firstSubjectInSelectedSubjectsParam,
            totalQuestions: totalQuestions));
        answeredQuestions.add(
            '$questionNumber$selectedOption$correctOption$firstSubjectInSelectedSubjectsParam');
        answeredQuestionsMarker
            .add("$questionNumber$firstSubjectInSelectedSubjectsParam");
        return;
      }

      answersJson.add(ChosenAnswerJson(
          questionNumber: questionNumber.toString(),
          isCorrect: selectedOption == correctOption ? true : false,
          remark: selectedOption == correctOption ? "correct" : "wrong",
          chosenAnswer: selectedOption,
          correctAnswer: correctOption,
          mark: mark,
          topic: topic,
          subject: currentSubject,
          totalQuestions: totalQuestions));
      answeredQuestions
          .add('$questionNumber$selectedOption$correctOption$currentSubject');
      answeredQuestionsMarker.add("$questionNumber$currentSubject");
    });
  }

  void handleSelectNewSubject(String subject) {
    for (SubjectQuestions subjectQuestions in providerSelectedQuestions) {
      if (toLowerCamelCase(subject) == subjectQuestions.subject) {
        setState(() {
          currentQuestionIndex = 0;
          currentSubject = subject;
          currentSubjectQuestions = subjectQuestions.questionsArray;
        });
      }
    }
  }
}
