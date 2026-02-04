import 'package:cbt_software_win/screens/lesson/select_lesson.dart';
import 'package:cbt_software_win/screens/load_user_screen.dart';
import 'package:cbt_software_win/screens/result_history.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:cbt_software_win/widgets/text_hover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  

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
                      // color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.brown, width: 10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 0))
                      ]),
                  width: deviceWidth > 650.00 ? 600.0 : deviceWidth * 0.9,
                  height: 390.0,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: -50.0,
                          right: -20.0,
                          child: SizedBox(
                            width: 200,
                            height: 300,
                            child: Image.asset(
                              'assets/images/instructor.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectTestTypeScreen(),
                                ));
                              },
                              child: Text("Quick Test",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                          
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoadUserScreen(),
                                ));
                              },
                              child: Text("Load User",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                           OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResultHistory(),
                                ));
                              },
                              child: Text("Result History",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ResultHistory(),
                                ));
                              },
                              child: Text("Settings",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectTestTypeScreen(),
                                ));
                              },
                              child: Text("Software updates",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectTestTypeScreen(),
                                ));
                              },
                              child: Text("About",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                          OnHoverText(builder: (isHovered) {
                            final color = isHovered
                                ? const Color.fromARGB(255, 126, 199, 199)
                                : const Color.fromARGB(255, 228, 228, 228);
                            return GestureDetector(
                              onTap: () {
                                SystemNavigator.pop();
                              },
                              child: Text("Quit",
                                  style: TextStyle(
                                    color: color,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "EastSeaDokdo",
                                    fontSize: 30.0,
                                  )),
                            );
                          }),
                        ],
                      )),
                    ],
                  )),
            ))
      ]),
    );
  }
}
