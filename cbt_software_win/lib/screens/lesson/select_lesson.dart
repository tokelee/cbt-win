import 'package:cbt_software_win/screens/lesson/jamb/lesson_type.dart';
import 'package:cbt_software_win/screens/lesson/widgets/hover_effect.dart';
import 'package:cbt_software_win/widgets/button.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:flutter/material.dart';

class SelectTestTypeScreen extends StatefulWidget {
  const SelectTestTypeScreen({super.key});

  @override
  State<SelectTestTypeScreen> createState() => _SelectTestTypeScreenState();
}

class _SelectTestTypeScreenState extends State<SelectTestTypeScreen> {
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
                height: 320.0,
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
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
                        const Text("Choose an option",
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectJambLessonTypeScreen()));
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
                                          child: Image.asset(
                                              'assets/jamb_logo.png',
                                              fit: BoxFit.cover),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          "JAMB",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 40.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: borderColor)),
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
                                    "WAEC",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 40.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: borderColor)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80.0,
                                    width: 80.0,
                                    child: Image.asset('assets/neco_logo.png',
                                        fit: BoxFit.cover),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    "NECO",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ));
                            })
                          ],
                        ),
                      ],
                    ))),
          ),
        )
      ]),
    );
  }
}
