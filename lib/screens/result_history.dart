import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/json/resultHistory/jamb.dart';
import 'package:cbt_software_win/database/json/resultHistory/ssce.dart';
import 'package:cbt_software_win/widgets/button.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultHistory extends StatefulWidget {
  const ResultHistory({super.key});

  @override
  State<ResultHistory> createState() => _ResultHistoryState();
}

class _ResultHistoryState extends State<ResultHistory> {
  String examType = "jamb";
  final db = AppDatabaseHelper();
  late Future<List<JambResultHistoryJson>> jambResultHistoryDBRes;
  late Future<List<SSCEResultHistoryJson>> waecResultHistoryDBRes;
  late Future<List<SSCEResultHistoryJson>> necoResultHistoryDBRes;
  List<JambResultHistoryJson> jambResultHistory = [];
  List<SSCEResultHistoryJson> waecResultHistory = [];
  List<SSCEResultHistoryJson> necoResultHistory = [];

  @override
  void initState() {
    super.initState();
    jambResultHistoryDBRes = fetchJambResultHistory();
    waecResultHistoryDBRes = fetchWaecResultHistory();
    necoResultHistoryDBRes = fetchNecoResultHistory();
  }

  Future<List<JambResultHistoryJson>> fetchJambResultHistory() async {
    List<JambResultHistoryJson> jambResult = await db.getAllJambResultHistory();
    setState(() {
      jambResultHistory = jambResult;
    });
    return jambResult;
  }

  Future<List<SSCEResultHistoryJson>> fetchWaecResultHistory() async {
    List<SSCEResultHistoryJson> waecResult = await db.getAllWaecResultHistory();
    setState(() {
      waecResultHistory = waecResult;
    });
    return waecResult;
  }

  Future<List<SSCEResultHistoryJson>> fetchNecoResultHistory() async {
    List<SSCEResultHistoryJson> necoResult = await db.getAllNecoResultHistory();
    setState(() {
      necoResultHistory = necoResult;
    });
    return necoResult;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              const Navbar(),
              const SizedBox(height: 50),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: deviceWidth * 0.9,
                    minHeight: deviceHeight * 0.8,
                    maxWidth: deviceWidth * 0.9),
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
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                  label: const Text("Back"),
                                  style: buttonAppTheme),
                            ],
                          ),
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Exam Result History",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                      label: const Text("Jamb"),
                                      selected: (examType == "jamb"),
                                      onSelected: (bool value) {
                                        setState(() {
                                          examType = "jamb";
                                          fetchJambResultHistory();
                                        });
                                      }),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                      label: const Text("WAEC"),
                                      selected: (examType == "waec"),
                                      onSelected: (bool value) {
                                        setState(() {
                                          examType = "waec";
                                          fetchWaecResultHistory();
                                        });
                                      }),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                      label: const Text("NECO"),
                                      selected: (examType == "neco"),
                                      onSelected: (bool value) {
                                        setState(() {
                                          examType = "neco";
                                          fetchNecoResultHistory();
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  if (examType == "jamb")
                                    FutureBuilder(
                                        future: jambResultHistoryDBRes,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<JambResultHistoryJson>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            if (snapshot.data!.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  "No result yet",
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              );
                                            } else {
                                              final jambResultHistoryRes =
                                                  jambResultHistory;
                                              return Column(
                                                children: [
                                                  for (JambResultHistoryJson resultHistory
                                                      in jambResultHistoryRes)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(resultHistory
                                                            .username),
                                                        Text(
                                                            "Subject(s): ${resultHistory.totalSubject}"),
                                                        Text(
                                                            "Score: ${resultHistory.score}"),
                                                        Text(
                                                            "Date: ${resultHistory.createdAt}"),
                                                        ElevatedButton.icon(
                                                            icon: const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white),
                                                            style:
                                                                buttonSuccess,
                                                            label: const Text(
                                                                "View",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            onPressed:
                                                                viewJambResult)
                                                      ],
                                                    ),
                                                ],
                                              );
                                            }
                                          }
                                        }),
                                  if (examType == "waec")
                                    FutureBuilder(
                                        future: waecResultHistoryDBRes,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<SSCEResultHistoryJson>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                                child:  Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            if (snapshot.data!.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  "No waec result yet",
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              );
                                            } else {
                                              final waecResultHistoryRes =
                                                  waecResultHistory;
                                              return Column(
                                                children: [
                                                  for (SSCEResultHistoryJson resultHistory
                                                      in waecResultHistoryRes)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(resultHistory
                                                            .username),
                                                        Text(
                                                            "Subject(s): ${resultHistory.totalSubject}"),
                                                        Text(
                                                            "Score: ${resultHistory.score}"),
                                                        Text(
                                                            "Date: ${resultHistory.createdAt}"),
                                                        ElevatedButton.icon(
                                                            icon: const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white),
                                                            style:
                                                                buttonSuccess,
                                                            label: const Text(
                                                                "View",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            onPressed:
                                                                viewJambResult)
                                                      ],
                                                    ),
                                                ],
                                              );
                                            }
                                          }
                                        }),
                                  if (examType == "neco")
                                    FutureBuilder(
                                        future: necoResultHistoryDBRes,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<SSCEResultHistoryJson>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            if (snapshot.data!.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  "No neco result yet",
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              );
                                            } else {
                                              final necoResultHistoryRes =
                                                  necoResultHistory;
                                              return Column(
                                                children: [
                                                  for (SSCEResultHistoryJson resultHistory
                                                      in necoResultHistoryRes)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(resultHistory
                                                            .username),
                                                        Text(
                                                            "Subject(s): ${resultHistory.totalSubject}"),
                                                        Text(
                                                            "Score: ${resultHistory.score}"),
                                                        Text(
                                                            "Date: ${resultHistory.createdAt}"),
                                                        ElevatedButton.icon(
                                                            icon: const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white),
                                                            style:
                                                                buttonSuccess,
                                                            label: const Text(
                                                                "View",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            onPressed:
                                                                viewJambResult)
                                                      ],
                                                    ),
                                                ],
                                              );
                                            }
                                          }
                                        }),
                                ],
                              )

                              // Column(
                              //   children: [
                              //     if(examType == "jamb")
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //         Text("User: Anonymous"),
                              //         Text("Subject(s): 2"),
                              //         Text("Score: 290/400"),
                              //         Text("Date: 04/21/2024"),
                              //         ElevatedButton.icon(
                              //           icon: Icon(Icons.remove_red_eye, color: Colors.white),
                              //           style:  buttonSuccess,
                              //           label: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              //         onPressed: viewJambResult)
                              //       ],),
                              //     if(examType == "waec")
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //         Text("User: Anonymous"),
                              //         Text("Subject(s): 2"),
                              //         Text("Date: 04/21/2024"),
                              //         ElevatedButton.icon(
                              //           icon: Icon(Icons.remove_red_eye, color: Colors.white),
                              //           style:  buttonSuccess,
                              //           label: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              //         onPressed: (){})
                              //       ],),
                              //     if(examType == "neco")
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //         Text("User: Anonymous"),
                              //         Text("Subject(s): 2"),
                              //         Text("Date: 04/21/2024"),
                              //         ElevatedButton.icon(
                              //           icon: Icon(Icons.remove_red_eye, color: Colors.white),
                              //           style:  buttonSuccess,
                              //           label: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              //         onPressed: (){})
                              //       ],),
                              //   ],
                              // ),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void viewJambResult() {
    print(DateTime.now().toString().split(" ")[0]);
  }

  void viewWaecResult() {
    print(DateTime.now().toString().split(" ")[0]);
  }

  void changeResultHistory() {}
}
