import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/json/user_json.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:cbt_software_win/screens/load_user_screen.dart';
import 'package:cbt_software_win/widgets/custom_button_widget.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:cbt_software_win/widgets/text_hover.dart';
import 'package:cbt_software_win/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  bool firstNameHasError = false;
  bool lastNameHasError = false;
  bool usernameHasError = false;
  bool isLoading = false;
  String usernameToBeDeleted = "";
  bool deleteModalIsOpen = false;
  bool usernameExist = false;
  final db = AppDatabaseHelper();

  Future<List<UserJson>> getUser(String username) async {
    return await db.getUserByUsername(username);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

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
                  height: 450.0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: const Text("Registration",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),

                      Center(
                        child: SizedBox(
                          height: 370.0,
                          width: 350.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  Text(
                                    "All fields are required",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 245, 92, 81)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 320.0,
                                  width: 350.0,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomTextField(
                                            controller: firstNameController,
                                            hasError: firstNameHasError,
                                            hintText: "First name",
                                            obscureText: false),
                                        CustomTextField(
                                            controller: lastNameController,
                                            hasError: lastNameHasError,
                                            hintText: "Surname",
                                            obscureText: false),
                                        Column(
                                          children: [
                                            CustomTextField(
                                                controller: usernameController,
                                                hasError: usernameHasError,
                                                hintText: "Username",
                                                obscureText: false),
                                          if(usernameExist)
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                          if(usernameExist)
                                            SizedBox(
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                   const Icon(
                                                      Icons.error,
                                                      size: 17.0,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      "Username ${usernameController.text} already exist",
                                                      style: const TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            "Your first name and last name will be written on your mock results when you download and print them",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        CustomButton(
                                            hasCustomBackgroundColor: false,
                                            height: 50.0,
                                            label: isLoading
                                                ? "Please wait..."
                                                : "Create user",
                                            onPress: isLoading
                                                ? null
                                                : () async {
                                                    
                                                    if (firstNameController
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        firstNameHasError =
                                                            true;
                                                      });
                                                      return;
                                                    }
                                                    if (lastNameController
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        lastNameHasError = true;
                                                      });
                                                      return;
                                                    }
                                                    if (usernameController
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        usernameHasError = true;
                                                      });
                                                      return;
                                                    }
                                                    final user = await getUser(
                                                        usernameController
                                                            .text);
                                                    if (user.isNotEmpty) {
                                                      setState(() {
                                                        usernameExist = true;
                                                        usernameHasError = true;
                                                      });
                                                      return;
                                                    }
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    try {
                                                      await db.addUser(UserJson(
                                                          firstName:
                                                              firstNameController
                                                                  .text,
                                                          lastName:
                                                              lastNameController
                                                                  .text,
                                                          username:
                                                              usernameController
                                                                  .text));
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoadUserScreen()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                    } catch (e) {
                                                      print(
                                                          "Error: here ${e.toString()}");
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  },
                                            width: double.infinity)
                                      ],
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OnHoverText(builder: (isHovered) {
                                    final color = isHovered
                                        ? const Color.fromARGB(
                                            255, 126, 199, 199)
                                        : const Color.fromARGB(
                                            255, 228, 228, 228);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Back",
                                          style: TextStyle(
                                            color: color,
                                            // fontWeight: FontWeight.bold,
                                            // fontFamily: "EastSeaDokdo",
                                            // fontSize: 25.0,
                                          )),
                                    );
                                  }),
                                  Row(
                                    children: [
                                      OnHoverText(builder: (isHovered) {
                                        final color = isHovered
                                            ? const Color.fromARGB(255, 126, 199, 199)
                                            : const Color.fromARGB(
                                                255, 228, 228, 228);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Text("Go home",
                                              style: TextStyle(
                                                color: color,
                                                // fontWeight: FontWeight.bold,
                                                // fontFamily: "EastSeaDokdo",
                                                // fontSize: 25.0,
                                              )),
                                        );
                                      }),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      if (deleteModalIsOpen)
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
                                      Text(
                                          "Are you sure you want to delete $usernameToBeDeleted?"),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  deleteModalIsOpen =
                                                      !deleteModalIsOpen;
                                                  usernameToBeDeleted = "";
                                                });
                                              },
                                              child: const Text("No"))
                                        ],
                                      )
                                    ],
                                  ),
                                ))),
                      // Positioned(
                      //     bottom: -50.0,
                      //     right: -20.0,
                      //     child: Container(
                      //       width: 200,
                      //       height: 300,
                      //       child: Image.asset(
                      //         'assets/images/instructor.png',
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )),
                    ],
                  )),
            ))
      ]),
    );
  }
}
