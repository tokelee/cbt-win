import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonNavbar extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;
  final dynamic onTap;
  final bool countDownIsCompleted;
  final bool isInReviewMode;
  const LessonNavbar({super.key, required this.minute, required this.hour, required this.second, required this.onTap, required this.countDownIsCompleted, required this.isInReviewMode});

  @override
  Widget build(BuildContext context) {
    String lessonType = context.watch<LessonStateProvider>().lessonStateItems.lessonType;
    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          
          width: double.infinity,
          color: const Color(0xFFFFFFFF),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children:[
              SizedBox(
                width: 40.00,
                height: 40.00,
                child: Placeholder()
              ),
               SizedBox(width: 10.0,),
               Text("AKAD CBT SOFTWARE", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: "EastSeaDokdo"),),
            ]),

             Column(
                  children: <Widget>[
                  Text(countDownIsCompleted ? "Time is up, Please submit now" :"Remaining Time",
                        style: const TextStyle(
                            // color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("$hour:$minute:$second",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ],
                ),

            GestureDetector(
              onTap: lessonType != "study" ? onTap : () {
                if(lessonType == "study"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
                  return;
                }
                },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(children: [
                  Icon( isInReviewMode || lessonType == "study" ? Icons.home : Icons.logout, color: Colors.white,),
                  const SizedBox(width: 5.0),
                  Text(isInReviewMode || lessonType == "study"  ? "Go Home" : "Submit", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
              ]),
              )
            )

               
            ],
          ),
        );
  }
}