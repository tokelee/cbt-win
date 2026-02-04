import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/screens/lesson/jamb/jamb_lesson_mode.dart';
import 'package:cbt_software_win/screens/lesson/widgets/hover_effect.dart';
import 'package:cbt_software_win/widgets/button.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectJambLessonTypeScreen extends StatelessWidget {
  const SelectJambLessonTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFFF),
      body: Column(children: [
        const Navbar(),
        SizedBox(
          height: deviceHeight * 0.8,
          width: double.infinity,
          child: Center(
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
                width: deviceWidth > 650.00 ? 600.0 : deviceWidth * 0.9,
                height: 400.0,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            label: const Text("Back"),
                            style: buttonNoColor,
                          ),
                        )),
                    const Text("Select Lesson Type",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HoverEffect(builder: (isHovered) {
                          final borderColor = isHovered
                              ? const Color.fromARGB(255, 230, 230, 230)
                              : const Color.fromARGB(255, 255, 255, 255);
                          return GestureDetector(
                              onTap: () {
                                context.read<LessonStateProvider>().changeLessonType("practice");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const JambLessonMode()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 40.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: borderColor)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80.0,
                                      width: 80.0,
                                      child: Image.asset('assets/jamb_logo.png',
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Text(
                                      "Practice",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      height: 100.0,
                                      width: 80.0,
                                      child: Text(
                                        "Allows you to complete the whole lesson before revealing your score",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }),
                        HoverEffect(builder: (isHovered) {
                          final borderColor = isHovered
                              ? const Color.fromARGB(255, 230, 230, 230)
                              : const Color.fromARGB(255, 255, 255, 255);
                          return GestureDetector(
                              onTap: () {
                                context.read<LessonStateProvider>().changeLessonType("study");
                                 Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const JambLessonMode()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 40.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: borderColor)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80.0,
                                      width: 80.0,
                                      child: Image.asset('assets/jamb_logo.png',
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Text(
                                      "Study",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      height: 100.0,
                                      width: 80.0,
                                      child: Text(
                                        "Reveals a comprehensive explanation after every chosen option",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.0),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }),
                        HoverEffect(builder: (isHovered) {
                          final borderColor = isHovered
                              ? const Color.fromARGB(255, 230, 230, 230)
                              : const Color.fromARGB(255, 255, 255, 255);
                          return GestureDetector(
                              onTap: () {
                                context.read<LessonStateProvider>().changeLessonType("mock");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const JambLessonMode()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 40.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: borderColor)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80.0,
                                      width: 80.0,
                                      child: Image.asset('assets/waec_logo.png',
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Text(
                                      "Mock",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      height: 100.0,
                                      width: 80.0,
                                      child: Text(
                                        "Allows you to print out your score after completing the whole lesson.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.0),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        })
                      ],
                    ),
                  ],
                )),
          ),
        )
      ]),
    );
  }
}
