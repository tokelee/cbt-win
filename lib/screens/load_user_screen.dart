import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/json/user_json.dart';
import 'package:cbt_software_win/providers/user_provider.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:cbt_software_win/screens/lesson/select_lesson.dart';
import 'package:cbt_software_win/screens/user/create_user_auth_screen.dart';
import 'package:cbt_software_win/widgets/navbar.dart';
import 'package:cbt_software_win/widgets/text_hover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadUserScreen extends StatefulWidget {
  const LoadUserScreen({super.key});

  @override
  State<LoadUserScreen> createState() => _LoadUserScreenState();
}

class _LoadUserScreenState extends State<LoadUserScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedUsername = "";
  String usernameToBeDeleted = "";
  bool deleteModalIsOpen = false;
  final db = AppDatabaseHelper();
  // List<UserJson> users;
  late Future<List<UserJson>> usersRes;
  UserJson selectedUser = UserJson(firstName: "", lastName: "", username: "");

  @override
  void initState() {
    super.initState();
    usersRes = fetchUsers();
  }

  Future<List<UserJson>> fetchUsers() async {
    return await db.getUsers();
  }

  Future<bool> deleteUser(String username) async {
    return await db.deleteUserByUsername(username);
  }

  Future<bool> testDelay() async {
    Duration duration = const Duration(seconds: 3);
    await Future.delayed(duration);
    return true;
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
                  height: 390.0,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: const Text("Select user",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),

                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          height: 320.0,
                          width: 350.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 250.0,
                                  width: 350.0,
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: FutureBuilder(
                                      future: usersRes,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<UserJson>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        } else {
                                          if (snapshot.data!.isEmpty) {
                                            return const Center(
                                              child: Text(
                                                "No users yet",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                            );
                                          } else {
                                            final users = snapshot.data!;
                                            return Scrollbar(
                                                thumbVisibility: true,
                                                controller: _scrollController,
                                                trackVisibility: true,
                                                interactive: true,
                                                thickness: 5.0,
                                                child: ListView.separated(
                                                    controller:
                                                        _scrollController,
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedUsername =
                                                                users[index]
                                                                    .username;
                                                            selectedUser = users[index];
                                                          });
                                                        },
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    right:
                                                                        15.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7.0),
                                                            decoration: BoxDecoration(
                                                                color: _selectedUsername ==
                                                                        users[index]
                                                                            .username
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        145,
                                                                        145,
                                                                        145)
                                                                    : null,
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(2.0))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  users[index]
                                                                      .username,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      deleteModalIsOpen =
                                                                          !deleteModalIsOpen;
                                                                      usernameToBeDeleted =
                                                                          users[index]
                                                                              .username;
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .delete_outline_outlined,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          194,
                                                                          58,
                                                                          48)),
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    }));
                                          }
                                        }
                                      })),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  const HomeScreen()),
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      child: Text("Go home",
                                          style: TextStyle(
                                            color: color,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "EastSeaDokdo",
                                            fontSize: 25.0,
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
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateUserScreen(),
                                            ));
                                          },
                                          child: Text("Create user",
                                              style: TextStyle(
                                                color: color,
                                                // fontWeight: FontWeight.bold,
                                                fontFamily: "EastSeaDokdo",
                                                fontSize: 25.0,
                                              )),
                                        );
                                      }),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      OnHoverText(builder: (isHovered) {
                                        final color = isHovered
                                            ? const Color.fromARGB(255, 126, 199, 199)
                                            : const Color.fromARGB(
                                                255, 228, 228, 228);
                                        return GestureDetector(
                                          onTap: _selectedUsername.isEmpty ? null : () {
                                            if(selectedUser.username.isEmpty){
                                              return;
                                            }
                                            context.read<UserProvider>().setUserState(firstName: selectedUser.firstName, lastName: selectedUser.lastName, username: selectedUser.username);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectTestTypeScreen(),
                                            ));
                                          },
                                          child: Text("Start",
                                              style: TextStyle(
                                                color: _selectedUsername.isNotEmpty ? color : Colors.grey,
                                                // fontWeight: FontWeight.bold,
                                                fontFamily: "EastSeaDokdo",
                                                fontSize: 25.0,
                                              )),
                                        );
                                      }),
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
                                              onPressed: () async {
                                                deleteUser(usernameToBeDeleted)
                                                    .then((isDeleted) {
                                                  if (isDeleted) {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoadUserScreen()));
                                                  }
                                                });
                                              },
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
