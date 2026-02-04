import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/screens/lesson/jamb/select_subject_jamb.dart';
import 'package:cbt_software_win/widgets/lesson_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JambLessonMode extends StatelessWidget {
  const JambLessonMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LessonMode(
        onStandardTap: (){
          context.read<LessonStateProvider>().changeLessonMode("standard");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> const SelectJambCourse()),
          );
        },
        onCustomizeTap: (){
          context.read<LessonStateProvider>().changeLessonMode("customized");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> const SelectJambCourse()),
          );
        },
      ),
    );
  }
}