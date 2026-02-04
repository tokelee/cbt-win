import 'dart:async';
import 'package:cbt_software_win/core/helper/colors.dart';
import 'package:cbt_software_win/database/helper/question_database_helper.dart';
import 'package:cbt_software_win/database/json/question_json.dart';
import 'package:cbt_software_win/database/json/question_response_json.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/screens/lesson/widgets/lesson_navbar.dart';
import 'package:cbt_software_win/utils/json/answer_json.dart';
import 'package:cbt_software_win/utils/json/lesson_analytics_json.dart';
import 'package:cbt_software_win/utils/toLowerCamelCase_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late JambDatabaseHelper handler;
  final db = JambDatabaseHelper();
  List<QuestionsJson> dbQuestions = [];
  String? currentOption;
  String currentSubject = "";
  List<QuestionsJson> currentSubjectQuestions = [];
  int currentQuestion = 1;
  int currentQuestionIndex = 0;
  List<String> answeredQuestions = [];
  Set<String> answeredQuestionsMarker = {};
  bool showResult = false;
  
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
    super.dispose();
  }

  Future<void> fetchQuesions(String subject) async {}

  Future<List<QuestionsJson>> getAllQuestions() async {
    return await handler.getQuestions("mathematics");
  }

 
  bool checkIfQuestionIsAnswered(){
    for(ChosenAnswerJson chosenAnswerJson in answersJson){
      if(chosenAnswerJson.questionNumber == currentQuestionIndex.toString() && chosenAnswerJson.subject == (currentSubject == "" ? selectedSubjects.toList()[0] : currentSubject)){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    bool questionIsAnswered = checkIfQuestionIsAnswered();

    return Scaffold(
        backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
        body: Stack(children: <Widget>[
          Column(children: [
            LessonNavbar(
              isInReviewMode: false,
              countDownIsCompleted: false,
              hour: "99",
              minute: "99",
              second: "99",
              onTap: () {},
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
                                                                onChanged: questionIsAnswered ? null : (value) {
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
                                                                onChanged:questionIsAnswered ? null : (value) {
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
                                                                onChanged: questionIsAnswered ? null : (value) {
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
                                                                onChanged: questionIsAnswered ? null : (value) {
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
                                                            
                                                            // if(questionIsAnswered)
                                                            if(questionIsAnswered)
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
                                              ? () {
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
                                              ? () {
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
                    ? "correct"
                    : "wrong",
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
                    ? "correct"
                    : "wrong",
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
